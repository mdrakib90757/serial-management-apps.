import 'dart:async';
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/providers/serviceCenter_provider/nextButton_provider/get_nextButton_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/custom_date_display/custom_date_display.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/new_serial_button_dialog/new_serial_button_dialog.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/queue_list_edit_dialog/queue_list_edit_dialog.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/statusDialogServiceCenter/statusDialog_serviceCenter.dart';
import 'package:SerialMan/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_sanckbar.dart';
import '../../global_widgets/custom_textfield.dart';
import '../../model/serialService_model.dart';
import '../../model/serviceCenter_model.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/addUser_serviceCenter_provider/SingleUserInfoProvider/singleUserInfoProvider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../providers/serviceCenter_provider/statusButtonProvider/status_UpdateButton_provider.dart';
import '../../request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';
import '../../utils/color.dart';
import '../../utils/date_formatter/date_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _FormatedDateTime = "";
  Timer? _timer;
  ServiceCenterModel? _selectedServiceCenter;
  DateTime _selectedDate = DateTime.now();

  //TabBar List
  final List<String> tabList = ["Queue", "Served "];
  int indexNo = 0;
  late TabController tabController;
  final TextEditingController _dateController = TextEditingController();
  bool _isInitialDataLoaded = false;
  bool _isNextButtonLoading = false;

  // fetch date
  Future<void> _fetchDataForUI() async {
    if (_selectedServiceCenter != null) {
      debugPrint(
        " FETCHING SERIALS for Service Center ID: ${_selectedServiceCenter!.id!}",
      );
      final formattedDate = DateFormatter.formatForApi(_selectedDate);
      Provider.of<GetNewSerialButtonProvider>(
        context,
        listen: false,
      ).fetchSerialsButton(_selectedServiceCenter!.id!, formattedDate);
    } else {
      debugPrint("⚠_fetchDataForUI called but _selectedServiceCenter is null.");
      return Future.value();
    }
  }

  // update date
  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formatted = DateFormat('EEEE, dd MMMM,yyyy ').format(now);
    setState(() {
      _FormatedDateTime = formatted;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });

    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialDataLoad();
    });
    _dateController.text = DateFormatter.formatForApi(_selectedDate);
  }

  // Initial data load
  Future<void> _initialDataLoad() async {
    final profileProvider = context.read<Getprofileprovider>();
    final serviceCenterProvider = context.read<GetAddButtonProvider>();
    final singleUserInfoProvider = context.read<SingleUserInfoProvider>();

    await profileProvider.fetchProfileData();
    final profile = profileProvider.profileData;

    if (mounted && profile != null) {
      final companyId = profile.currentCompany.id;
      final userId = profile.id;
      print("homeScreen - $companyId");

      await Future.wait([
        serviceCenterProvider.fetchGetAddButton(companyId),
        singleUserInfoProvider.fetchUserInfo(companyId, userId),
      ]);

      if (mounted) {
        setState(() {
          _isInitialDataLoaded = true;
        });
      }
    }
  }

  //Date function
  Future<void> _SelectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: false,
            colorScheme: ColorScheme.light(
              primary: AppColor().primariColor,
              // Header color
              onPrimary: Colors.white,
              // Header text color
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor().primariColor,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate != null && newDate != _selectedDate) {
      setState(() {
        _selectedDate = newDate;
        _dateController.text = DateFormatter.formatForApi(newDate);
      });
      _fetchDataForUI();
    }
  }

  // next button Background update
  Future<void> _processNextSerialInBackground(
    SerialModel serialToServe,
    GetNewSerialButtonProvider serialProvider,
    statusUpdateButton_provder statusUpdateProvider,
  ) async {
    // Update the current 'Serving' serial to 'Served'
    StatusButtonRequest servedRequest = StatusButtonRequest(
      serviceId: serialToServe.id!,
      serviceCenterId: serialToServe.serviceCenterId!,
      status: "Served",
      isPresent: true,
    );

    final bool servedSuccess = await statusUpdateProvider.updateStatus(
      servedRequest,
      serialToServe.serviceCenterId!,
      serialToServe.id!,
    );

    if (!servedSuccess) {
      print("Background update to 'Served' failed.");
      return;
    }

    // To avoid race conditions, show success and then fetch
    if (mounted) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Serial Completed",
        message: "Serial #${serialToServe.serialNo} is now Served.",
      );
    }

    // Fetch the list to find the new "next in queue"
    await serialProvider.fetchSerialsButton(
      _selectedServiceCenter!.id!,
      DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
    final newNextSerial = serialProvider.nextInQueue;
    //  If there is a new serial, update it to 'Serving' and the next to 'Waiting'
    if (newNextSerial != null) {
      StatusButtonRequest newServingRequest = StatusButtonRequest(
        serviceId: newNextSerial.id!,
        serviceCenterId: newNextSerial.serviceCenterId!,
        status: "Serving",
        isPresent: true,
      );
      await statusUpdateProvider.updateStatus(
        newServingRequest,
        newNextSerial.serviceCenterId!,
        newNextSerial.id!,
      );
      final finalNextWaiting = serialProvider.queueSerials.firstWhereOrNull(
        (s) =>
            s.serialNo! > newNextSerial.serialNo! &&
            s.status?.toLowerCase() == 'booked',
      );
      if (finalNextWaiting != null) {
        StatusButtonRequest finalWaitingRequest = StatusButtonRequest(
          serviceId: finalNextWaiting.id!,
          serviceCenterId: finalNextWaiting.serviceCenterId!,
          status: "Waiting",
          isPresent: false,
        );
        await statusUpdateProvider.updateStatus(
          finalWaitingRequest,
          finalNextWaiting.serviceCenterId!,
          finalNextWaiting.id!,
        );
      }
    }

    //  Final fetch to update the UI with all changes
    await serialProvider.fetchSerialsButton(
      _selectedServiceCenter!.id!,
      DateFormat('yyyy-MM-dd').format(_selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;
    final serialProvider = context.watch<GetNewSerialButtonProvider>();
    final getProfile = context.watch<Getprofileprovider>();

    final getAddButtonProvider = context.watch<GetAddButtonProvider>();
    final singleUserInfoProvider = context.watch<SingleUserInfoProvider>();

    final profile = getProfile.profileData;
    final bool shouldShowAddButton =
        profile?.currentCompany.businessTypeId == 1;

    ServiceCenterModel? defaultSelectItem;
    if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
      defaultSelectItem = getAddButtonProvider.serviceCenterList.first;
    }
    final getNextButtonProvider = context.watch<GetNextButtonProvider>();

    if (profile == null || getAddButtonProvider.isLoading) {
      return Scaffold(
        backgroundColor: AppColor().backgroundColor,
        body: CustomShimmerList(itemCount: 10),
      );
    }
    final company = profile.currentCompany;
    final userInfo = singleUserInfoProvider.userInfo;
    if (userInfo == null) {
      return Scaffold(
        backgroundColor: AppColor().backgroundColor,
        body: CustomShimmerList(itemCount: 10),
      );
    }
    final allCompanyServiceCenters = getAddButtonProvider.serviceCenterList;
    final assignedCenterIds = userInfo.serviceCenterIds;
    final userAssignedServiceCenters = allCompanyServiceCenters.where((center) {
      return assignedCenterIds.contains(center.id);
    }).toList();
    if (_selectedServiceCenter == null &&
        userAssignedServiceCenters.isNotEmpty) {
      _selectedServiceCenter = userAssignedServiceCenters.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fetchDataForUI();
      });
    }

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      body: RefreshIndicator(
        onRefresh: _fetchDataForUI,
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: Stack(
          children: [
            // cliPath top design
            ClipPath(
              clipper: ClipPathClipper(),
              child: Container(
                height: 250,
                decoration: BoxDecoration(color: AppColor().primariColor),
                width: double.maxFinite,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
              ),
            ),

            // main container for the app
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: Colors.transparent.withOpacity(0.0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: GoogleFonts.acme(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),

                    //customToday date and serving circle
                    CustomDateDisplay(selectedDate: _selectedDate),
                    const SizedBox(height: 5),

                    //service center dropdown
                    CustomDropdown<ServiceCenterModel>(
                      items: userAssignedServiceCenters,
                      value: _selectedServiceCenter,
                      selectedItem: _selectedServiceCenter,
                      onChanged: (ServiceCenterModel? newvalue) {
                        debugPrint(
                          "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                        );
                        setState(() {
                          _selectedServiceCenter = newvalue;
                        });
                        _fetchDataForUI();
                      },
                      itemAsString: (ServiceCenterModel item) =>
                          item.name ?? "No Name",
                    ),
                    const SizedBox(height: 5),

                    //serviceCenter date
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _SelectDate(context);
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                readOnly: true,
                                filled: true,
                                fillColor: Colors.white,
                                controller: _dateController,
                                hintText: todayString,
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                isPassword: false,
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    "Service Date:",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColor().primariColor,
                                  //color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //serial button and next button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Serial Button
                        GestureDetector(
                          onTap: isToday
                              ? () async {
                                  final NewSerialButton =
                                      Provider.of<NewSerialButtonProvider>(
                                        context,
                                        listen: false,
                                      );
                                  if (_selectedServiceCenter == null) {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text(
                                    //       "Please select a service center first.",
                                    //     ),
                                    //   ),
                                    // );
                                    return;
                                  }

                                  final bool? wasSuccessful =
                                      await showDialog<bool?>(
                                        context: context,
                                        builder: (context) {
                                          return NewSerialButtonDialog(
                                            serviceCenterModel:
                                                _selectedServiceCenter!,
                                            rootContext: context,
                                          );
                                        },
                                      );

                                  if (mounted) {
                                    if (wasSuccessful == true) {
                                      await CustomFlushbar.showSuccess(
                                        context: context,
                                        title: "Success",
                                        message:
                                            "New serial has been booked successfully.",
                                      );

                                      _fetchDataForUI();
                                    } else if (wasSuccessful == false) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          behavior: SnackBarBehavior.floating,
                                          content: CustomSnackBarWidget(
                                            title: "Error",
                                            message:
                                                NewSerialButton.errorMessage ??
                                                "Failed to create new serial. Please try again.",
                                          ),
                                        ),
                                      );
                                    } else {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   const SnackBar(
                                      //     content: Text(
                                      //       "Please select a service center first.",
                                      //     ),
                                      //   ),
                                      // );
                                    }
                                  }
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColor().primariColor
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: isToday
                                        ? Colors.white
                                        : Colors.grey.shade400,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "New Serial",
                                    style: TextStyle(
                                      color: isToday
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //NextButton
                        GestureDetector(
                          onTap: isToday && !_isNextButtonLoading
                              ? () async {
                                  setState(() {
                                    _isNextButtonLoading = true;
                                  });
                                  try {
                                    final serialProvider =
                                        Provider.of<GetNewSerialButtonProvider>(
                                          context,
                                          listen: false,
                                        );

                                    final statusUpdateProvider =
                                        Provider.of<statusUpdateButton_provder>(
                                          context,
                                          listen: false,
                                        );

                                    final SerialModel? nextSerial =
                                        serialProvider.nextInQueue;
                                    if (nextSerial == null) {
                                      if (mounted)
                                        setState(
                                          () => _isNextButtonLoading = false,
                                        );
                                      return;
                                    }

                                    final String currentStatus =
                                        nextSerial.status?.toLowerCase() ?? "";

                                    if ([
                                      'booked',
                                      'waiting',
                                      'present',
                                    ].contains(currentStatus)) {
                                      StatusButtonRequest servingRequest =
                                          StatusButtonRequest(
                                            serviceId: nextSerial.id!,
                                            serviceCenterId:
                                                nextSerial.serviceCenterId!,
                                            status: "Serving",
                                            isPresent: true,
                                          );

                                      final bool servingSuccess =
                                          await statusUpdateProvider
                                              .updateStatus(
                                                servingRequest,
                                                nextSerial.serviceCenterId!,
                                                nextSerial.id!,
                                              );

                                      if (!servingSuccess) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                statusUpdateProvider
                                                        .errorMessage ??
                                                    "Failed to update status to Serving.",
                                              ),
                                            ),
                                          );
                                        }
                                        return;
                                      }

                                      if (mounted) {
                                        CustomFlushbar.showSuccess(
                                          context: context,
                                          title: "Status Updated",
                                          message:
                                              "Serial #${nextSerial.serialNo} is now Serving.",
                                        );
                                        await serialProvider.fetchSerialsButton(
                                          _selectedServiceCenter!.id!,
                                          DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(_selectedDate),
                                        );
                                        final nextWaitingCandidate =
                                            serialProvider.queueSerials
                                                .firstWhereOrNull(
                                                  (s) =>
                                                      s.serialNo! >
                                                          nextSerial
                                                              .serialNo! &&
                                                      s.status?.toLowerCase() ==
                                                          'booked',
                                                );
                                        if (nextWaitingCandidate != null) {
                                          StatusButtonRequest waitingRequest =
                                              StatusButtonRequest(
                                                serviceId:
                                                    nextWaitingCandidate.id!,
                                                serviceCenterId:
                                                    nextWaitingCandidate
                                                        .serviceCenterId!,
                                                status: "Waiting",
                                                isPresent: false,
                                              );
                                          await statusUpdateProvider
                                              .updateStatus(
                                                waitingRequest,
                                                nextWaitingCandidate
                                                    .serviceCenterId!,
                                                nextWaitingCandidate.id!,
                                              );
                                        }
                                        await serialProvider.fetchSerialsButton(
                                          _selectedServiceCenter!.id!,
                                          DateFormat(
                                            'yyyy-MM-dd',
                                          ).format(_selectedDate),
                                        );
                                      }
                                    }
                                    // REVISED LOGIC for Second Tap (Status is 'serving')
                                    else if (currentStatus == 'serving') {
                                      if (mounted) {
                                        showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return ManageSerialDialog(
                                              serialDetails: nextSerial,
                                              isFromNextButton: true,
                                              date: DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(_selectedDate),
                                            );
                                          },
                                        ).then((result) async {
                                          if (result == true) {
                                            print(
                                              "Dialog made changes. Refreshing list one last time.",
                                            );
                                            await serialProvider
                                                .fetchSerialsButton(
                                                  _selectedServiceCenter!.id!,
                                                  DateFormat(
                                                    'yyyy-MM-dd',
                                                  ).format(_selectedDate),
                                                );
                                          }
                                        });
                                      }

                                      //  Start the background processing WITHOUT awaiting it.
                                      _processNextSerialInBackground(
                                        nextSerial,
                                        serialProvider,
                                        statusUpdateProvider,
                                      );
                                    }
                                  } catch (e) {
                                    print("Error in NextButton tap: $e");
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isNextButtonLoading = false;
                                      });
                                    }
                                  }
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  !isToday ||
                                      serialProvider.queueSerials.isEmpty
                                  ? Colors.grey.shade200
                                  : AppColor().primariColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: _isNextButtonLoading
                                      ? CustomLoading(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          size: 10,
                                        )
                                      : Text(
                                          "Next",
                                          style: TextStyle(
                                            color:
                                                !isToday ||
                                                    serialProvider
                                                        .queueSerials
                                                        .isEmpty
                                                ? Colors.grey.shade400
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  color:
                                      !isToday ||
                                          serialProvider.queueSerials.isEmpty
                                      ? Colors.grey.shade400
                                      : Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // queue and served tabBar
                    Row(
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelColor: Colors.grey.shade600,
                            labelColor: AppColor().primariColor,
                            labelStyle: TextStyle(fontWeight: FontWeight.w500),
                            indicatorColor: AppColor().primariColor,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  return Colors.transparent;
                                }),
                            tabs: [
                              Tab(
                                child: Text(
                                  "Queue${serialProvider.totalQueueCount > 0 ? '(${serialProvider.totalQueueCount})' : ''}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Served${serialProvider.totalServedCount > 0 ? '(${serialProvider.totalServedCount})' : ''}",

                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // refresh button
                        TextButton.icon(
                          onPressed: () {
                            _fetchDataForUI();
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 18,
                            color: AppColor().primariColor,
                          ),
                          label: Text(
                            "Refresh",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor().primariColor,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),

                    // //tabBar list
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height,
                    //   child: TabBarView(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     controller: tabController,
                    //     children: [_buildQueueList(), _buildServedList()],
                    //   ),
                    // ),
                    IndexedStack(
                      index: tabController.index,
                      children: <Widget>[_buildQueueList(), _buildServedList()],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //queue build Widget
  Widget _buildQueueList() {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return CustomShimmerList(itemCount: 10);
        }
        final queueList = serialProvider.queueSerials;
        if (queueList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12),
                Text(
                  'No items in the queue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: queueList.length,
          itemBuilder: (context, index) {
            final serial = queueList[index];

            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            final bool canBeEdited = serial.status?.toLowerCase() != 'serving';
            final bool wasCreatedByAdmin = serial.isAdmin ?? false;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 1),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      serial.name ?? "N/A",
                                      style: TextStyle(
                                        color: AppColor().primariColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (isToday &&
                                      wasCreatedByAdmin &&
                                      canBeEdited) ...[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return QueueListEditDialog(
                                              serviceCenterModel:
                                                  _selectedServiceCenter!,
                                              serialToEdit: serial,
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: AppColor().primariColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: isToday
                                  ? () async {
                                      _showDialogBoxManage(serial);
                                    }
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(statusTime, style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Text(serial.serviceType!.name.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // served build widget
  Widget _buildServedList() {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(child: CustomShimmerList(itemCount: 10));
        }
        final servedList = serialProvider.servedSerials;

        if (servedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  'No items have been served yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: servedList.length + 1,
          itemBuilder: (context, index) {
            if (index == servedList.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ${serialProvider.totalServedCount} Person(s)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${serialProvider.totalServedAmount.toStringAsFixed(2)}BDT",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }
            final serial = servedList[index];
            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            return Container(
              margin: EdgeInsets.symmetric(vertical: 1),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    serial.name ?? "N/A",
                                    style: TextStyle(
                                      color: AppColor().primariColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: isToday
                                      ? () async {
                                          _showDialogBoxManage(serial);
                                        }
                                      : null,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        serial.status.toString(),
                                        style: TextStyle(
                                          color: AppColor.getStatusColor(
                                            serial.status,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(
                              statusTime,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(serial.serviceType!.name.toString()),
                            Text("${serial.charge!.toString()} BDT"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Status DialogBox
  void _showDialogBoxManage(SerialModel serial) {
    final String? serviceCenterId = _selectedServiceCenter?.id;
    final String? serviceId = serial.id;

    if (serviceCenterId == null || serviceId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error: ID is missing!")));
      return;
    }
    final String formattedDate = DateFormatter.formatForApi(_selectedDate);
    showDialog<bool?>(
      context: context,
      builder: (context) {
        return ManageSerialDialog(
          date: formattedDate,
          serialDetails: serial,
          isFromNextButton: false,
        );
      },
    ).then((wasSuccessful) {
      if (mounted) {
        if (wasSuccessful == true) {
          debugPrint("Dialog returned success. Refreshing UI...");
          _fetchDataForUI();
        }
      }
    });
  }
}
