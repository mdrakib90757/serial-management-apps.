import 'dart:async';
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import 'package:SerialMan/request_model/seviceTaker_request/bookSerial_request/bookSerial_request.dart';
import '../../../../api/auth_api/auth_api.dart';
import '../../../../global_widgets/MyRadio Button.dart';
import '../../../../global_widgets/My_Appbar.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../model/organization_model.dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../model/service_type_model.dart';
import '../../../../model/user_model.dart' hide UserType;
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../providers/serviceTaker_provider/ServiceCenterByTypeProvider.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/bookSerialButton_provider.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
//import '../../../../providers/serviceTaker_provider/getBookSerialButtonProvider/getBookSerial_provider.dart';
import '../../../../providers/serviceTaker_provider/organaizationProvider/organization_provider.dart';
import '../../../../providers/serviceTaker_provider/serviceCenter_serialBookProvider/serviceCenter_serialBookProvider.dart';
import '../../../../providers/serviceTaker_provider/serviceType_serialbook_provider.dart';
import '../../../../utils/color.dart';
import '../../../../utils/date_formatter/date_formatter.dart';
import '../../servicetaker_homescreen.dart';

class BookSerialButton extends StatefulWidget {
  final String businessTypeId;
  final bool showAppBar;
  final bool showBottomNavBar;
  final bool isServiceTaker;

  const BookSerialButton({
    super.key,
    required this.businessTypeId,
    this.showAppBar = true,
    this.showBottomNavBar = false,
    this.isServiceTaker = false,
  });
  @override
  State<BookSerialButton> createState() => _BookSerialButtonState();
}

class _BookSerialButtonState extends State<BookSerialButton> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  UserName? _SelectUserName = UserName.Self;
  List<Businesstype> _businessTypes = [];

  bool _isLoadingBusinessTypes = true;
  String? _businessTypeError;
  String _FormatedDateTime = "";
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  UserName? _selectUserName = UserName.Self;
  Businesstype? _selectedBusinessType;
  OrganizationModel? _selectedOrganization;
  ServiceCenterModel? _selectedServiceCenter;
  serviceTypeModel? _selectedServiceType;
  bool _isInit = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String currentDateTimeISO = DateTime.now().toIso8601String();
      Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(currentDateTimeISO);

      if (widget.businessTypeId.isNotEmpty) {
        Provider.of<OrganizationProvider>(
          context,
          listen: false,
        ).get_Organization(businessTypeId: widget.businessTypeId);
      } else {
        print("Warning: businessTypeId is empty. Skipping organization fetch.");
      }

      _loadBusinessTypes();
    });

    _dateController.text = DateFormat("yyyy-MM-dd").format(_selectedDate);
  }

  // load business types
  Future<void> _loadBusinessTypes() async {
    try {
      final types = await AuthApi().fetchBusinessType();
      if (mounted) {
        setState(() {
          _businessTypes = types;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _businessTypeError = "Failed to load business types";
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.loadUserFromToken().then((_) {
        if (_selectUserName == UserName.Self &&
            authProvider.userModel != null) {
          setState(() {
            _contactNoController.text = authProvider.userModel!.user.mobileNo;
            _nameController.text = authProvider.userModel!.user.name;
          });
        }
      });
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _contactNoController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // save book serial request
  Future<void> _saveBookSerialRequest() async {
    if (!_dialogFormKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final String? businessTypeId = _selectedBusinessType?.id?.toString();
    final String? organizationId = _selectedOrganization?.id;
    final String? serviceCenterId = _selectedServiceCenter?.id;
    final String? serviceTypeId = _selectedServiceType?.id;

    bool isIdMissing =
        businessTypeId == null ||
        serviceCenterId == null ||
        serviceTypeId == null;
    if (_selectedBusinessType?.id == 1 && organizationId == null) {
      isIdMissing = true;
    }

    if (isIdMissing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "A required field is missing. Please re-select all items.",
          ),
        ),
      );
      return;
    }

    final bookProvider = Provider.of<bookSerialButton_provider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final String serviceTakerId = authProvider.userModel!.user.id;
    final bool forSelfValue = _selectUserName == UserName.Self;
    final String serviceDate = _dateController.text;

    try {
      BookSerialRequest bookSerialRequest = BookSerialRequest(
        businessTypeId: businessTypeId!,
        serviceCenterId: serviceCenterId!,
        serviceTypeId: serviceTypeId!,
        serviceDate: serviceDate,
        serviceTaker: serviceTakerId,
        contactNo: _contactNoController.text,
        name: _nameController.text,
        organizationId: organizationId,
        forSelf: forSelfValue,
      );

      final success = await bookProvider.fetchBookSerialButton(
        bookSerialRequest,
        serviceCenterId,
      );

      if (!mounted) return;
      if (success) {
        await Provider.of<GetBookSerialProvider>(
          context,
          listen: false,
        ).fetchgetBookSerial(serviceDate);
        Navigator.pop(context);
        await CustomFlushbar.showSuccess(
          context: context,
          title: "Success",
          message: "Serial booked successfully!",
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackBarWidget(
              title: "Error",
              message: bookProvider.errorMessage ?? "Booking Failed",
              iconColor: Colors.red.shade400,
              icon: Icons.dangerous_outlined,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  // date picker
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _dateController.text = DateFormat("yyyy-MM-dd").format(newDate);
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _loadBusinessTypes();
    // final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // await context.read<GetBookSerialProvider>().fetchgetBookSerial(today);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<bookSerialButton_provider>(context);
    final orgProvider = Provider.of<OrganizationProvider>(context);
    DateTime selectedDialogDate = DateTime.now();

    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: UserType.customer,
      isExtraScreen: true,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: Container(
          //height: 415,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _dialogFormKey,
            child: SingleChildScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                            ),

                            Text(
                              "Book a Serial",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // serviceType Provider Type field
                        const CustomLabeltext(
                          "ServiceType Provider Type",
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Consumer<BusinessTypeProvider>(
                          builder: (context, BusProvider, child) {
                            return CustomDropdown<Businesstype>(
                              selectedItem: _selectedBusinessType,
                              value: _selectedBusinessType,
                              items: _businessTypes,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedBusinessType = newValue;
                                  _selectedOrganization = null;
                                  _selectedServiceCenter = null;
                                  _selectedServiceType = null;
                                  context
                                      .read<OrganizationProvider>()
                                      .clearData();
                                  context
                                      .read<serviceCenter_serialBookProvider>()
                                      .clearData();
                                  context
                                      .read<ServiceCenterByTypeProvider>()
                                      .clearData();
                                  context
                                      .read<serviceTypeSerialbook_Provider>()
                                      .clearData();
                                });
                                if (newValue == null) return;

                                if (newValue.id == 1) {
                                  print(
                                    "Fetching organizations for Business Type ID: ${newValue.id}",
                                  );

                                  context
                                      .read<OrganizationProvider>()
                                      .get_Organization(
                                        businessTypeId: newValue.id.toString(),
                                      );
                                } else {
                                  context
                                      .read<ServiceCenterByTypeProvider>()
                                      .fetchServiceCenters(
                                        newValue.id.toString(),
                                      );
                                }
                              },
                              itemAsString: (Businesstype type) => type.name,
                              hinText: "Select ServiceType",
                              validator: (value) {
                                if (value == null)
                                  return "Please select a business type";
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        // organization field
                        if (_selectedBusinessType?.id == 1) ...[
                          const CustomLabeltext(
                            "Organization",
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Consumer<OrganizationProvider>(
                            builder: (context, OrgProvider, child) {
                              return CustomDropdown<OrganizationModel>(
                                hinText: "Select Organization",
                                selectedItem: _selectedOrganization,
                                items: OrgProvider.organizations,
                                onChanged: (OrganizationModel? Newvalue) {
                                  setState(() {
                                    _selectedOrganization = Newvalue;
                                    _selectedServiceCenter = null;
                                    _selectedServiceType = null;
                                    context
                                        .read<ServiceCenterByTypeProvider>()
                                        .clearData();
                                  });
                                  if (Newvalue != null && Newvalue.id != null) {
                                    print(
                                      " Organization Selected. Fetching Service Centers for Company ID: ${Newvalue.id}",
                                    );

                                    Provider.of<
                                          serviceCenter_serialBookProvider
                                        >(context, listen: false)
                                        .fetchserviceCnter_serialbook(
                                          Newvalue.id!,
                                        );
                                  } else {
                                    Provider.of<
                                          serviceCenter_serialBookProvider
                                        >(context, listen: false)
                                        .clearData();
                                  }
                                },
                                itemAsString: (OrganizationModel type) =>
                                    type.name ?? "",
                                validator: (value) {
                                  if (value == null)
                                    return "Please select aOrganization";
                                  return null;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                        const SizedBox(height: 10),

                        // service center field
                        const CustomLabeltext(
                          "Service Center",
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Consumer<serviceCenter_serialBookProvider>(
                          builder: (context, orgServiceCenterProvider, child) {
                            return Consumer<ServiceCenterByTypeProvider>(
                              builder: (context, typeServiceCenterProvider, child) {
                                final List<ServiceCenterModel>
                                allServiceCenters = [
                                  ...orgServiceCenterProvider.serviceCenterList,
                                  ...typeServiceCenterProvider.serviceCenters,
                                ];
                                final bool isLoading =
                                    orgServiceCenterProvider.isLoading ||
                                    typeServiceCenterProvider.isLoading;

                                return CustomDropdown<ServiceCenterModel>(
                                  hinText: "select serviceCenter",
                                  selectedItem: _selectedServiceCenter,
                                  items: allServiceCenters,
                                  onChanged: (ServiceCenterModel? newValue) {
                                    setState(() {
                                      _selectedServiceCenter = newValue;
                                      _selectedServiceType = null;
                                    });

                                    if (newValue != null &&
                                        newValue.companyId != null &&
                                        newValue.companyId!.isNotEmpty) {
                                      final String companyId =
                                          newValue.companyId!;
                                      print(
                                        "Service Center Selected. Fetching Service Types for Company ID: $companyId",
                                      );
                                      Provider.of<
                                            serviceTypeSerialbook_Provider
                                          >(context, listen: false)
                                          .serviceType_serialbook(companyId);
                                    } else {
                                      print(
                                        "Company ID not found in the selected Service Center. Clearing service types.",
                                      );
                                      Provider.of<
                                            serviceTypeSerialbook_Provider
                                          >(context, listen: false)
                                          .clearData();
                                    }

                                    print(newValue?.name);
                                  },
                                  itemAsString: (ServiceCenterModel item) =>
                                      item.name ?? "",
                                  validator: (value) {
                                    if (value == null)
                                      return "Please select a Service Center";
                                    return null;
                                  },
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        // service type field
                        const CustomLabeltext("Service Type"),
                        const SizedBox(height: 8),
                        Consumer<serviceTypeSerialbook_Provider>(
                          builder: (context, serviceTypeProvider, child) {
                            return CustomDropdown<serviceTypeModel>(
                              hinText: "select ServiceType",
                              itemAsString: (serviceTypeModel item) =>
                                  item.name ?? "",
                              selectedItem: _selectedServiceType,
                              items: serviceTypeProvider.serviceTypeList,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedServiceType = newValue;
                                });
                                print(newValue?.name);
                              },
                              validator: (value) {
                                if (value == null)
                                  return "Please select a Service Type";
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        // date field
                        const CustomLabeltext("Date"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            _SelectDate(context);
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller: _dateController,
                              //hintText: "Select Date",
                              readOnly: true,
                              isPassword: false,
                              suffixIcon: Icon(
                                Icons.date_range_outlined,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "For",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CustomRadioGroup<UserName>(
                          groupValue: _SelectUserName,
                          items: [UserName.Self, UserName.Other],
                          onChanged: (UserName? newValue) {
                            setState(() {
                              _SelectUserName = newValue;
                            });
                          },
                          itemTitleBuilder: (UserName value) {
                            switch (value) {
                              case UserName.Self:
                                return "Self";
                              case UserName.Other:
                                return "Other";
                            }
                          },
                        ),
                        Visibility(
                          visible: _SelectUserName == UserName.Self,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomLabeltext("Name"),
                              SizedBox(height: 10),
                              CustomTextField(
                                enabled: false,
                                filled: true,
                                isPassword: false,
                                controller: _nameController,
                              ),
                              SizedBox(height: 15),
                              CustomLabeltext("Contact No"),
                              SizedBox(height: 10),
                              CustomTextField(
                                enabled: false,
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
                          visible: _SelectUserName == UserName.Other,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomLabeltext("Name"),
                              SizedBox(height: 10),
                              CustomTextField(
                                isPassword: false,
                                controller: _nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              CustomLabeltext("Contact No"),
                              SizedBox(height: 10),
                              CustomTextField(
                                isPassword: false,
                                controller: _contactNoController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // book button
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
                              onPressed: () async {
                                await _saveBookSerialRequest();
                              },
                              child: bookProvider.isLoading
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
