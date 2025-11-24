import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:SerialMan/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/providers/auth_provider/auth_providers.dart';
import 'package:SerialMan/request_model/seviceTaker_request/update_bookSerialRequest/update_bookSerialRequest.dart';
import '../../../../global_widgets/MyRadio Button.dart';
import '../../../../global_widgets/My_Appbar.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../model/ServiceTypesDeFaultifNotSet.dart';
import '../../../../model/mybooked_model.dart';

import '../../../../model/service_type_model.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../../../../providers/serviceTaker_provider/serviceType_serialbook_provider.dart';
import '../../../../providers/serviceTaker_provider/service_types_de_fault_provider/service_types_de_fault_provider.dart';
import '../../../../providers/serviceTaker_provider/update_bookserialProvider/update_bookserial_provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/date_formatter/date_formatter.dart';
import '../../servicetaker_homescreen.dart';

class UpdateBookSerialDlalog extends StatefulWidget {
  final MybookedModel bookingDetails;
  final bool showAppBar;
  final bool showBottomNavBar;
  final bool isServiceTaker;

  const UpdateBookSerialDlalog({
    super.key,
    required this.bookingDetails,
    this.showAppBar = true,
    this.showBottomNavBar = false,
    this.isServiceTaker = false,
  });

  @override
  State<UpdateBookSerialDlalog> createState() => _UpdateBookSerialDlalogState();
}

class _UpdateBookSerialDlalogState extends State<UpdateBookSerialDlalog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceCenterController =
      TextEditingController();

  ServiceTypesDeFaultifNotSetModel? _ServiceTypesDeFaultifNotSetModel;
  //serviceTypeModel? _selectedServiceType;
  UserName? _selectUserName = UserName.Self;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isInit = true;
  final Date = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _isFetchingServiceTypes = true;
  bool _isUpdating = false;

  // initialize fields
  void _initializeFields() {
    final booking = widget.bookingDetails;
    _serviceCenterController.text = booking.serviceCenter?.name ?? 'N/A';
    if (_selectUserName == UserName.Self) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _contactNoController.text =
          authProvider.userModel?.user.mobileNo ?? booking.contactNo ?? '';
      _nameController.text =
          (authProvider.userModel?.user.name ?? booking.name) ?? "";
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      _contactNoController.text = booking.contactNo ?? '';
      _nameController.text = booking.name ?? "";
    }
  }

  // fetch initial data
  void _fetchInitialData() {
    final serviceCenterId = widget.bookingDetails.serviceCenterId;
    if (serviceCenterId != null) {
      Provider.of<service_types_de_fault_provider>(
        context,
        listen: false,
      ).fetchServiceTypes(serviceCenterId).then((_) {
        if (mounted) {
          final serviceTypeProvider =
              Provider.of<service_types_de_fault_provider>(
                context,
                listen: false,
              );
          ServiceTypesDeFaultifNotSetModel? preSelectedType;
          if (widget.bookingDetails.serviceType?.id != null &&
              serviceTypeProvider.serviceTypes.isNotEmpty) {
            try {
              preSelectedType = serviceTypeProvider.serviceTypes.firstWhere(
                (type) => type.id == widget.bookingDetails.serviceType!.id,
              );
            } catch (e) {
              print("Pre-selected service type not found by ID. Error: $e");
              preSelectedType = null;
            }
          }

          setState(() {
            _ServiceTypesDeFaultifNotSetModel = preSelectedType;
            _isFetchingServiceTypes = false;
          });
        }
      });
    } else {
      setState(() {
        _isFetchingServiceTypes = false;
      });
    }
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeFields();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchInitialData();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // save book serial request
  Future<void> _UpdateBook_serial() async {
    if (!_dialogFormKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    final updateProvider = Provider.of<UpdateBookSerialProvider>(
      context,
      listen: false,
    );
    final bookingId = widget.bookingDetails.id;
    final serviceCenterId = widget.bookingDetails.serviceCenter?.id;
    final serviceTypeId = _ServiceTypesDeFaultifNotSetModel?.id;

    if (bookingId == null || serviceCenterId == null || serviceTypeId == null) {
      if (!mounted) return;
      setState(() => _isUpdating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            message: "Error: Missing required information to update.",
            title: "Error",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    UpdateBookSerialRequest request = UpdateBookSerialRequest(
      id: bookingId,
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      forSelf: _selectUserName == UserName.Self,
      name: _nameController.text,
      contactNo: _contactNoController.text,
    );
    // if (!mounted) return;
    final success = await updateProvider.update_bookSerial(
      request,
      bookingId,
      serviceCenterId,
    );
    if (!mounted) return;
    setState(() {
      _isUpdating = false;
    });

    if (success) {
      final isoDate = DateTime.now().toIso8601String().split('.').first;
      await Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(isoDate);
      if (!mounted) return;
      Navigator.pop(context);
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Serial booked successfully!",
      );
    } else {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: updateProvider.errorMessage ?? "Booking Failed",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Future<void> _handleRefresh() async {
  //   _fetchInitialData();
  //   // await Future.delayed(const Duration(seconds: 1));
  // }

  @override
  Widget build(BuildContext context) {
    final updateProvider = Provider.of<UpdateBookSerialProvider>(context);
    final getUpdateProvider = Provider.of<GetBookSerialProvider>(
      context,
      listen: false,
    );
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: UserType.customer,
      isExtraScreen: true,
      child: RefreshIndicator(
        onRefresh: () async => _fetchInitialData(),
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: _isFetchingServiceTypes
            ? CustomShimmerList()
            : Form(
                key: _dialogFormKey,
                child: Stack(
                  children: [
                    // top custom design
                    ClipPath(
                      clipper: ClipPathClipper(),
                      child: Container(
                        color: AppColor().primariColor,
                        height: 250,
                        width: double.maxFinite,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(
                          top: 0,
                          left: 10,
                          right: 10,
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //color: Colors.transparent.withOpacity(0.0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    weight: 3,
                                    //color: Colors.black,
                                    color: AppColor().primariColor,
                                  ),
                                ),
                                Text(
                                  "Edit Book Serial",
                                  style: TextStyle(
                                    // color: Colors.black,
                                    color: AppColor().primariColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Custom service center filed
                            const CustomLabeltext("Service Center"),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _serviceCenterController,
                              fillColor: Colors.red.shade50,
                              filled: true,
                              isPassword: false,
                              enabled: false,
                            ),
                            const SizedBox(height: 10),

                            // Custom service type field
                            const CustomLabeltext("Service Type"),
                            const SizedBox(height: 8),
                            Consumer<service_types_de_fault_provider>(
                              builder: (context, serviceTypeProvider, child) {
                                final bool isLoading =
                                    serviceTypeProvider.state ==
                                    NotifierState.loading;
                                return CustomDropdown<
                                  ServiceTypesDeFaultifNotSetModel
                                >(
                                  hinText: "select serviceType",
                                  items: serviceTypeProvider.serviceTypes,
                                  onChanged:
                                      (
                                        ServiceTypesDeFaultifNotSetModel?
                                        newValue,
                                      ) {
                                        setState(() {
                                          _ServiceTypesDeFaultifNotSetModel =
                                              newValue;
                                        });
                                        print(newValue?.name);
                                      },
                                  itemAsString:
                                      (ServiceTypesDeFaultifNotSetModel item) =>
                                          item.name ?? "no data",
                                  selectedItem:
                                      _ServiceTypesDeFaultifNotSetModel,
                                  validator: (value) {
                                    if (value == null)
                                      return "Please select a Service Type";
                                    return null;
                                  },
                                  suffixIcon: isLoading
                                      ? Container(
                                          padding: const EdgeInsets.all(12.0),
                                          child: SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CustomLoading(
                                              color: AppColor().primariColor,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : null,
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // Custom date field
                            const CustomLabeltext("Date"),
                            const SizedBox(height: 8),
                            CustomTextField(
                              fillColor: Colors.red.shade50,
                              filled: true,
                              enabled: false,
                              controller: _dateController,
                              hintText: todayString,
                              isPassword: false,
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          useMaterial3: false,
                                          colorScheme: ColorScheme.light(
                                            primary: AppColor().primariColor,
                                            // Header color
                                            onPrimary: Colors.white,
                                            // Header text color
                                            onSurface:
                                                Colors.black, // Body text color
                                          ),
                                          dialogTheme: DialogThemeData(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: AppColor()
                                                  .primariColor, // Button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    context: context,
                                    initialDate: _selectedDate,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (newDate != null) {
                                    setState(() {
                                      _selectedDate = newDate;
                                      _dateController.text = DateFormat(
                                        "yyyy-MM-dd",
                                      ).format(newDate);
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            const Text(
                              "For",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // Custom radio button for user name
                            CustomRadioGroup<UserName>(
                              groupValue: _selectUserName,
                              items: const [UserName.Self, UserName.Other],
                              onChanged: (newValue) {
                                setState(() {
                                  _selectUserName = newValue;
                                  final authProvider =
                                      Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );
                                  if (newValue == UserName.Self) {
                                    _contactNoController.text =
                                        authProvider.userModel?.user.mobileNo ??
                                        '';
                                    _nameController.text =
                                        authProvider.userModel?.user.name ?? '';
                                  } else {
                                    _contactNoController.text =
                                        widget.bookingDetails.contactNo ?? '';
                                    _nameController.text =
                                        widget.bookingDetails.name!;
                                  }
                                });
                              },
                              itemTitleBuilder: (value) =>
                                  value == UserName.Self ? "Self" : "Other",
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: _selectUserName == UserName.Self,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Custom name field
                                  CustomLabeltext("Name"),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    enabled: false,
                                    filled: true,
                                    fillColor: Colors.red.shade50,
                                    isPassword: false,
                                    controller: _nameController,
                                  ),
                                  SizedBox(height: 10),

                                  // Custom contact no field
                                  CustomLabeltext("Contact No"),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    enabled: false,
                                    fillColor: Colors.red.shade50,
                                    filled: true,
                                    isPassword: false,
                                    controller: _contactNoController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Visibility(
                              visible: _selectUserName == UserName.Other,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Custom name field
                                  CustomLabeltext("Name"),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    isPassword: false,
                                    controller: _nameController,
                                  ),
                                  SizedBox(height: 10),

                                  // Custom contact no field
                                  CustomLabeltext("Contact No"),
                                  SizedBox(height: 10),
                                  CustomTextField(
                                    isPassword: false,
                                    controller: _contactNoController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Custom button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor().primariColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: _isUpdating
                                      ? null
                                      : () async {
                                          await _UpdateBook_serial();
                                        },
                                  child: _isUpdating
                                      ? Text(
                                          "Please wait...",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Request for serial",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: AppColor().primariColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
