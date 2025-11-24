import 'dart:async';
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import '../../../../model/ServiceTypesDeFaultifNotSet.dart';
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
import '../../../../providers/serviceTaker_provider/service_center_search_provider/service_center_search_provider.dart';
import '../../../../providers/serviceTaker_provider/service_types_de_fault_provider/service_types_de_fault_provider.dart';
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
  final TextEditingController _serviceCenterController =
      TextEditingController();
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
  ServiceTypesDeFaultifNotSetModel? _selectedServiceTypeDeFault;
  bool _isInit = true;
  DateTime _selectedDate = DateTime.now();
  final FocusNode _serviceCenterFocusNode = FocusNode();
  bool _isSuggestionSelected = false;
  final ScrollController _scrollController = ScrollController();
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<service_types_de_fault_provider>(
        context,
        listen: false,
      ).clearData();
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
    _serviceCenterFocusNode.addListener(_onFocusChange);
    _scrollController.addListener(() {});
  }

  void _onFocusChange() {
    if (!_serviceCenterFocusNode.hasFocus && !_isSuggestionSelected) {
      if (mounted) {
        context.read<ServiceCenterSearchProvider>().clearResults();
      }
    }
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
    _serviceCenterController.dispose();
    _serviceCenterFocusNode.removeListener(_onFocusChange);
    _serviceCenterFocusNode.dispose();
    _scrollController.dispose();
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
    final String? serviceTypeId = _selectedServiceTypeDeFault?.id;

    bool isIdMissing =
        businessTypeId == null ||
        serviceCenterId == null ||
        serviceTypeId == null;

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

  // handleRefresh load business types
  Future<void> _handleRefresh() async {
    await _loadBusinessTypes();
    // final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // await context.read<GetBookSerialProvider>().fetchgetBookSerial(today);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<bookSerialButton_provider>(context);
    final orgProvider = Provider.of<OrganizationProvider>(context);

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
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "Book a Serial",
                                style: TextStyle(
                                 //color: Colors.black,
                                 color: AppColor().primariColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // serviceType Provider Type field
                          const CustomLabeltext("ServiceType Provider Type"),
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
                                        .read<
                                          serviceCenter_serialBookProvider
                                        >()
                                        .clearData();
                                    context
                                        .read<ServiceCenterByTypeProvider>()
                                        .clearData();
                                    context
                                        .read<serviceTypeSerialbook_Provider>()
                                        .clearData();

                                    context
                                        .read<service_types_de_fault_provider>()
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
                                          businessTypeId: newValue.id
                                              .toString(),
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

                          // service center field
                          const CustomLabeltext("Service Center"),
                          const SizedBox(height: 8),
                          Consumer2<
                            ServiceCenterSearchProvider,
                            OrganizationProvider
                          >(
                            builder: (context, searchProvider, orgProvider, child) {
                              String getOrgNameById(String? companyId) {
                                if (companyId == null)
                                  return 'Organization not found';
                                try {
                                  return orgProvider.organizations
                                          .firstWhere(
                                            (org) => org.id == companyId,
                                          )
                                          .name ??
                                      'Unknown Org';
                                } catch (e) {
                                  return 'Organization not found';
                                }
                              }

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  return RawAutocomplete<ServiceCenterModel>(
                                    textEditingController:
                                        _serviceCenterController,
                                    focusNode: _serviceCenterFocusNode,
                                    displayStringForOption: (option) =>
                                        option.name ?? '',
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                              ServiceCenterModel
                                            >.empty();
                                          }
                                          return searchProvider.results;
                                        },
                                    fieldViewBuilder:
                                        (
                                          context,
                                          controller,
                                          focusNode,
                                          onFieldSubmitted,
                                        ) {
                                          return CompositedTransformTarget(
                                            link: _layerLink,
                                            child: TextFormField(
                                              cursorColor: Colors.grey.shade500,
                                              controller: controller,
                                              focusNode: focusNode,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              onChanged: (value) {
                                                _isSuggestionSelected = false;
                                                Future.delayed(
                                                  const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  () {
                                                    if (focusNode.hasFocus) {
                                                      context
                                                          .read<
                                                            ServiceCenterSearchProvider
                                                          >()
                                                          .search(value);
                                                    }
                                                  },
                                                );
                                              },

                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText:
                                                    "Search Service Center",
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),

                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 14,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey
                                                            .shade400,
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppColor()
                                                            .primariColor,
                                                        width: 2,
                                                      ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    //width: 2,
                                                  ),
                                                ),
                                                suffixIcon:
                                                    searchProvider.isLoading
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              12.0,
                                                            ),
                                                        child: CustomLoading(
                                                          size: 2.5,
                                                          strokeWidth: 2.5,
                                                        ),
                                                      )
                                                    : null,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (_selectedServiceCenter ==
                                                        null ||
                                                    value!.isEmpty) {
                                                  return "Please select a Service Center";
                                                }
                                                return null;
                                              },
                                            ),
                                          );
                                        },
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return CompositedTransformFollower(
                                        link: _layerLink,
                                        showWhenUnlinked: false,
                                        targetAnchor: Alignment.bottomLeft,
                                        followerAnchor: Alignment.topLeft,
                                        offset: const Offset(0.0, 5.0),
                                        child: Material(
                                          elevation: 4.0,
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          child: Container(
                                            width: constraints.maxWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: 280,
                                              ),
                                              child: Scrollbar(
                                                controller: _scrollController,
                                                thumbVisibility: true,
                                                thickness: 6.0,
                                                radius: Radius.circular(10),
                                                interactive: true,
                                                child: ListView.separated(
                                                  controller: _scrollController,
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          Divider(
                                                            height: 1,
                                                            thickness: 1,
                                                            indent: 16,
                                                            endIndent: 16,
                                                          ),
                                                  itemBuilder: (context, index) {
                                                    final option = options
                                                        .elementAt(index);
                                                    final orgName =
                                                        getOrgNameById(
                                                          option.companyId,
                                                        );
                                                    return InkWell(
                                                      onTap: () =>
                                                          onSelected(option),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 12.0,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              orgName,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                      0.9,
                                                                    ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              option.name ??
                                                                  'No Name',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Text(
                                                              option.hotlineNo ??
                                                                  'No contact',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onSelected: (selection) {
                                      _isSuggestionSelected = true;
                                      setState(() {
                                        _selectedServiceCenter = selection;
                                        _serviceCenterController.text =
                                            selection.name ?? '';
                                        _selectedServiceTypeDeFault = null;
                                      });
                                      if (selection.id != null &&
                                          selection.id!.isNotEmpty) {
                                        Provider.of<
                                              service_types_de_fault_provider
                                            >(context, listen: false)
                                            .fetchServiceTypes(selection.id!);
                                      }
                                      _serviceCenterFocusNode.unfocus();
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
                          Consumer<service_types_de_fault_provider>(
                            builder: (context, serviceTypeProvider, child) {
                              final bool isLoading =
                                  serviceTypeProvider.state ==
                                  NotifierState.loading;
                              return CustomDropdown<
                                ServiceTypesDeFaultifNotSetModel
                              >(
                                hinText: "select ServiceType",
                                itemAsString:
                                    (ServiceTypesDeFaultifNotSetModel item) =>
                                        item.name ?? "",
                                selectedItem: _selectedServiceTypeDeFault,
                                items: serviceTypeProvider.serviceTypes,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedServiceTypeDeFault = newValue;
                                  });
                                  print(newValue?.name);
                                },
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
                                onPressed: bookProvider.isLoading
                                    ? null
                                    : () async {
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
