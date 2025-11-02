import 'dart:async';

//
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
//
//
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/servicetaker_screen/serviceTakerWidget/comment_cancelbutton_dialog/comment_cancelbutton_dialog.dart';
import 'package:SerialMan/Screen/servicetaker_screen/serviceTakerWidget/serviceTakerBookSerialButton/bookSerialButtonDialog.dart';
import 'package:SerialMan/Screen/servicetaker_screen/serviceTakerWidget/update_bookSerialDialog/update_bookSerialDlalog.dart';
import 'package:SerialMan/api/auth_api/auth_api.dart';
import 'package:SerialMan/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import 'package:SerialMan/model/mybooked_model.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../../providers/serviceTaker_provider/organaizationProvider/organization_provider.dart';

import '../../utils/color.dart';
import '../../utils/date_formatter/date_formatter.dart';

class ServicetakerHomescreen extends StatefulWidget {
  final String businessTypeId;
  const ServicetakerHomescreen({super.key, required this.businessTypeId});

  @override
  State<ServicetakerHomescreen> createState() => _ServicetakerHomescreenState();
}

enum UserName { Self, Other }

class _ServicetakerHomescreenState extends State<ServicetakerHomescreen> {
  TextEditingController contactNoController = TextEditingController();
  TextEditingController NameController = TextEditingController();

  List<Businesstype> _businessTypes = [];
  Businesstype? _selectedBusinessType;
  bool _isLoadingBusinessTypes = false;
  String? _businessTypeError;

  DateTime date = DateTime(2022, 12, 24);
  bool _isInit = true;
  bool _controllersInitialized = false;

  String _FormatedDateTime = "";
  Timer? _timer;
  DateTime _selectedDate = DateTime.now();

  void _updateTime() {
    if (mounted) {
      final DateTime now = DateTime.now();
      final String formatted = DateFormat('EEE, dd MMMM, yyyy ').format(now);
      setState(() {
        _FormatedDateTime = formatted;
      });
    }
  }

  // BusinessType LoadIng
  Future<void> _loadBusinessTypes() async {
    try {
      final types = await AuthApi().fetchBusinessType();
      setState(() {
        _businessTypes = types;
        _selectedBusinessType = null;
        print("Loaded Business Types: ${types.length}");
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _businessTypeError = e.toString();
          _businessTypeError = "Failed to load business types";
          debugPrint('Error loading business types: $e');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBusinessTypes = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(today);

      Provider.of<OrganizationProvider>(
        context,
        listen: false,
      ).get_Organization(businessTypeId: widget.businessTypeId);
      _loadBusinessTypes();
      _updateTime();
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AuthProvider>(context, listen: false).loadUserFromToken();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _handleRefresh() async {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await Future.wait([
      context.read<GetBookSerialProvider>().fetchgetBookSerial(today),

      context.read<OrganizationProvider>().get_Organization(
        businessTypeId: widget.businessTypeId,
      ),
      _loadBusinessTypes(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Timedate = _FormatedDateTime;
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final authProvider = Provider.of<AuthProvider>(context);

    final bookSerialButton = Provider.of<GetBookSerialProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: Builder(
          builder: (context) {
            if (authProvider.userModel == null) {
              return Center(
                child: Text("No User Data found. Please try again."),
              );
            }

            if (!_controllersInitialized) {
              contactNoController.text = authProvider.userModel!.user.mobileNo;
              NameController.text = authProvider.userModel!.user.name;
              _controllersInitialized = true;
            }

            if (authProvider.isLoading) {
              return CustomShimmerList(itemCount: 10);
            }

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Timedate,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        BookSerialButton(businessTypeId: ''),
                                    transitionsBuilder: (_, anim, __, child) {
                                      return FadeTransition(
                                        opacity: anim,
                                        child: child,
                                      );
                                    },
                                    fullscreenDialog: true,
                                  ),
                                );
                              },

                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  color: AppColor().primariColor,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 7),
                                      const Text(
                                        "Book Serial",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Consumer<GetBookSerialProvider>(
                          builder: (context, bookSerialProvider, child) {
                            if (bookSerialProvider.isLoading) {
                              return CustomShimmerList(itemCount: 10);
                            }

                            if (bookSerialProvider.bookSerialList.isEmpty) {
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
                                      'No appointment for today',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: bookSerialProvider.bookSerialList.map((
                                bookSerial,
                              ) {
                                final String statusTime =
                                    DateFormatter.formatForStatusTime(
                                      bookSerial.statusTime,
                                    );
                                final String ApproxTime =
                                    DateFormatter.formatForApproxTime(
                                      bookSerial.approxServeTime,
                                    );

                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              bookSerial.company?.name ??
                                                  "No Company Name",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  bookSerial.status.toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColor.getStatusColor(
                                                          bookSerial.status,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              bookSerial.serviceCenter?.name ??
                                                  "No serviceCenter Name",
                                              style: TextStyle(
                                                color: AppColor().primariColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              statusTime,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: bookSerial.forSelf == false,
                                          child: Text(
                                            "For ${bookSerial.name ?? "Other"}",
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  bookSerial
                                                          .serviceType
                                                          ?.name ??
                                                      "No ServiceType Name",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "(${bookSerial.serialNo})",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible:
                                                  bookSerial.status !=
                                                      "Cancelled" &&
                                                  bookSerial.status !=
                                                      "Serving",
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 17,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CommentCancelButtonDialog(
                                                          bookingDetails:
                                                              bookSerial,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Visibility(
                                                        visible:
                                                            bookSerial.status !=
                                                                "Cancelled" &&
                                                            bookSerial.status !=
                                                                "Serving",
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                right: 17,
                                                              ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) => UpdateBookSerialDlalog(
                                                                        bookingDetails:
                                                                            bookSerial,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            child: Icon(
                                                              Icons.edit,
                                                              size: 19,
                                                              color: AppColor()
                                                                  .primariColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.close,
                                                        size: 19,
                                                        color: AppColor()
                                                            .primariColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Text("Approx Time : ${ApproxTime}"),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
