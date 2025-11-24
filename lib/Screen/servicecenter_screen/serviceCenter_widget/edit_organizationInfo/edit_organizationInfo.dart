//
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
//
//
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/division_model.dart';
import 'package:SerialMan/providers/serviceCenter_provider/divisionProvider/divisionProvider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/update_organization_settingScreen/update_organization_Provider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/update_orginization_request/update_orginization_request.dart';
import '../../../../global_widgets/My_Appbar.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../model/company_details_model.dart';
import '../../../../model/user_model.dart' hide UserType;
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import '../../../../providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import '../../../../providers/serviceCenter_provider/company_details_provider/company_details_provider.dart';
import '../../../../providers/serviceCenter_provider/location_provider/location_provider.dart';
import '../../../../providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import '../../../../providers/serviceCenter_provider/update_organization_settingScreen/get_update_organization/get_update_organization_provider.dart';
import '../../../../utils/color.dart';
import '../google_locationDialog/locationPickerDialogContant/locationPickerDialog.dart';

class EditOrganizationInfo extends StatefulWidget {
  final CompanyDetailsModel companyDetails;

  const EditOrganizationInfo({super.key, required this.companyDetails});

  @override
  State<EditOrganizationInfo> createState() => _EditOrganizationInfoState();
}

class _EditOrganizationInfoState extends State<EditOrganizationInfo> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController name;
  late TextEditingController addressLine1;
  late TextEditingController addressLine2;
  late TextEditingController contactName;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController organization;
  late TextEditingController _locationController;
  bool _isLoadingBusinessTypes = false;
  Businesstype? _selectedBusinessType;
  bool _isLoadingDivision = false;
  DivisionModel? _selectDivision;
  LocationPart? _selectedDivision;
  LocationPart? _selectedDistrict;
  LocationPart? _selectedThana;
  LocationPart? _selectedArea;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final company = widget.companyDetails;
    name = TextEditingController();
    addressLine1 = TextEditingController();
    addressLine2 = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    _locationController = TextEditingController(
      text: company.location?.toString() ?? '',
    );
    _selectedDivision = company.division;
    _selectedDistrict = company.district;
    _selectedThana = company.thana;
    _selectedArea = company.area;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
      _loadInitialDropdownLists();
    });
  }

  // fetch initial data
  Future<void> _fetchInitialData() async {
    final divisionProvider = Provider.of<DivisionProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final companyDetailsProvider = Provider.of<CompanyDetailsProvider>(
      context,
      listen: false,
    );
    final businessTypeProvider = Provider.of<BusinessTypeProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoadingBusinessTypes = true;
      _isLoadingDivision = true;
    });

    try {
      await Future.wait([
        divisionProvider.fetchDivisions(),
        authProvider.fetchBusinessTypes(),
      ]);
      if (companyDetailsProvider.companyDetails != null) {
        final company = companyDetailsProvider.companyDetails!;

        name.text = company.name ?? '';
        addressLine1.text = company.addressLine1 ?? '';
        addressLine2.text = company.addressLine2 ?? '';
        email.text = company.email ?? "";
        phone.text = company.phone ?? '';

        if (authProvider.userModel != null &&
            authProvider.businessTypes.isNotEmpty) {
          _selectedBusinessType = authProvider.businessTypes.firstWhere(
            (type) => type.id == authProvider.userModel!.businessTypeId,
            orElse: () => authProvider.businessTypes.first,
          );
        }
      }
    } catch (e) {
      print("Error fetching initial data: $e");
    } finally {
      setState(() {
        _isLoadingBusinessTypes = false;
        _isLoadingDivision = false;
      });
    }
  }

  // load initial dropdown lists
  Future<void> _loadInitialDropdownLists() async {
    final locationProvider = context.read<LocationProvider>();
    final authProvider = context.read<AuthProvider>();

    setState(() => _isLoading = true);
    try {
      await Future.wait([
        authProvider.fetchBusinessTypes(),
        locationProvider.getDivisions(),
      ]);

      if (authProvider.userModel != null &&
          authProvider.businessTypes.isNotEmpty) {
        _selectedBusinessType = authProvider.businessTypes.firstWhere(
          (type) => type.id == authProvider.userModel!.businessTypeId,
          orElse: () => authProvider.businessTypes.first,
        );
      }

      if (_selectedDivision != null) {
        await locationProvider.getDistricts(_selectedDivision!.id!);
      }

      if (_selectedDistrict != null) {
        await locationProvider.getThanas(_selectedDistrict!.id!);
      }

      if (_selectedThana != null) {
        await locationProvider.getAreas(_selectedThana!.id!);
      }
    } catch (e) {
      print("Error loading initial dropdown lists: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    addressLine1.dispose();
    addressLine2.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  // save organization data
  Future<void> _updateOrganizationInfo() async {
    if (_dialogFormKey.currentState!.validate()) {
      _dialogFormKey.currentState!.save();
      final navigator = Navigator.of(context);
      final UpdateOrgProvider = context.read<UpdateOrganizationInfoProvider>();
      final getUpdateOrgProvider = context.read<getUpdateOrganization>();
      final companyDetails = widget.companyDetails;
      final companyId = companyDetails.id;
      if (companyId != null) {
        UpdateOrginizationRequest request = UpdateOrginizationRequest(
          name: name.text,
          addressLine1: addressLine1.text,
          addressLine2: addressLine2.text,
          email: email.text,
          phone: phone.text,
          businessTypeId: _selectedBusinessType?.id,
          divisionId: _selectedDivision?.id,
          districtId: _selectedDistrict?.id,
          thanaId: _selectedThana?.id,
          areaId: _selectedArea?.id,
          location: _locationController.text,
        );
        final success = await UpdateOrgProvider.updateOrignazation(
          request,
          companyId,
        );
        if (!mounted) return;
        if (success) {
          await getUpdateOrgProvider.fetchDetails(companyId);
          if (!mounted) return;
          navigator.pop(true);
          await CustomFlushbar.showSuccess(
            context: context,
            title: "Success",
            message: "  Organization Update Successfully",
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackBarWidget(
                title: "Error",
                message: UpdateOrgProvider.errorMessage ?? "Failed to Add User",
                iconColor: Colors.red.shade400,
                icon: Icons.dangerous_outlined,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleRefresh() async {
    await Future.wait([_fetchInitialData(), _loadInitialDropdownLists()]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final UpdateOrgProvider = Provider.of<UpdateOrganizationInfoProvider>(
      context,
    );
    final companyDetailsProvider = context.watch<CompanyDetailsProvider>();
    final updateOrgProvider = context.read<UpdateOrganizationInfoProvider>();

    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: UserType.company,
      isExtraScreen: true,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: Form(
          key: _dialogFormKey,
          child: _isLoading
              ? CustomShimmerList(itemCount: 10)
              : Stack(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Edit Information",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // custom name field
                            const CustomLabeltext("Name"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: "Name",
                              isPassword: false,
                              controller: name,
                            ),
                            const SizedBox(height: 10),

                            // custom address1 field
                            const CustomLabeltext(
                              "Address Line 1",
                              showStar: false,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: "Address Line 1",
                              isPassword: false,
                              controller: addressLine1,
                              enableValidation: false,
                            ),
                            const SizedBox(height: 10),

                            // custom address2 field
                            const CustomLabeltext(
                              "Address Line 2",
                              showStar: false,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: addressLine2,
                              enableValidation: false,
                              hintText: "Address Line 2",
                              isPassword: false,
                            ),
                            const SizedBox(height: 10),

                            // custom email field
                            const CustomLabeltext("Email"),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: "Email",
                              isPassword: false,
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),

                            // custom phone field
                            const CustomLabeltext("Mobile Number"),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: "Mobile Number",
                              isPassword: false,
                              controller: phone,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),

                            // custom business type field
                            const CustomLabeltext("Business Type"),
                            const SizedBox(height: 10),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return CustomDropdown<Businesstype>(
                                  hinText: "Select BusinessType",
                                  items: authProvider.businessTypes,
                                  value: _selectedBusinessType,
                                  selectedItem: _selectedBusinessType,
                                  onChanged: (Businesstype? newvalue) {
                                    debugPrint(
                                      "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                                    );
                                    setState(() {
                                      _selectedBusinessType = newvalue;
                                    });
                                  },
                                  itemAsString: (Businesstype type) =>
                                      type.name,
                                  validator: (value) {
                                    if (value == null)
                                      return "Please select a business type";
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // custom Division dropdown fields
                            const CustomLabeltext("Division", showStar: false),
                            const SizedBox(height: 8),
                            CustomDropdown<LocationPart>(
                              itemAsString: (item) => item.name ?? '',
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDivision = newValue;
                                  _selectedDistrict = null;
                                  _selectedThana = null;
                                  _selectedArea = null;
                                });
                                locationProvider.clearDistricts();
                                locationProvider.clearThanas();
                                locationProvider.clearAreas();

                                if (newValue != null) {
                                  locationProvider.getDistricts(newValue.id!);
                                }
                              },
                              // validator: (value) {
                              //       if (value == null)
                              //         return "Please select a business type";
                              //       return null;
                              //     },
                              selectedItem: _selectedDivision,
                              items: locationProvider.divisions,
                            ),
                            const SizedBox(height: 10),

                            // custom District dropdown fields
                            const CustomLabeltext("District", showStar: false),
                            const SizedBox(height: 8),
                            CustomDropdown<LocationPart>(
                              hinText: "Select District",
                              itemAsString: (item) => item.name ?? '',
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDistrict = newValue;
                                  _selectedThana = null;
                                  _selectedArea = null;
                                });
                                locationProvider.clearThanas();
                                locationProvider.clearAreas();
                                if (newValue != null) {
                                  locationProvider.getThanas(newValue.id!);
                                }
                              },

                              // validator: (value) {
                              //       if (value == null)
                              //         return "Please select a business type";
                              //       return null;
                              //     },
                              items: locationProvider.districts,
                              selectedItem: _selectedDistrict,
                            ),
                            const SizedBox(height: 10),

                            // custom Thana dropdown fields
                            const CustomLabeltext("Thana", showStar: false),
                            const SizedBox(height: 8),
                            CustomDropdown<LocationPart>(
                              hinText: "Select Thana",
                              itemAsString: (item) => item.name ?? '',
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedThana = newValue;
                                  _selectedArea = null;
                                });
                                //locationProvider.clearThanas();
                                locationProvider.clearAreas();

                                if (newValue != null) {
                                  locationProvider.getAreas(newValue.id!);
                                }
                              },
                              items: locationProvider.thanas,
                              selectedItem: _selectedThana,
                            ),
                            SizedBox(height: 10),

                            // custom Area dropdown fields
                            const CustomLabeltext("Area", showStar: false),
                            const SizedBox(height: 8),
                            CustomDropdown<LocationPart>(
                              hinText: "Select Area",
                              itemAsString: (item) => item.name ?? '',
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedArea = newValue;
                                });
                                // locationProvider.clearAreas();
                                // if (newValue != null) {
                                //   locationProvider.getAreas(newValue.id!);
                                // }
                              },
                              items: locationProvider.areas,
                              selectedItem: _selectedArea,
                            ),
                            const SizedBox(height: 10),

                            // custom location field
                            const CustomLabeltext("Location", showStar: false),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: "Location",
                              isPassword: false,
                              controller: _locationController,
                              suffixIcon: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  // borderRadius: BorderRadiusGeometry.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          LocationPickerDialog(),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        _locationController.text =
                                            '${result.latitude.toStringAsFixed(6)}, ${result.longitude.toStringAsFixed(6)}';
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.location_on_outlined,
                                    color: AppColor().primariColor,
                                  ),
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // save button and cancel button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(5),
                                    ),
                                    backgroundColor: AppColor().primariColor,
                                  ),
                                  onPressed: updateOrgProvider.isLoading
                                      ? null
                                      : _updateOrganizationInfo,
                                  child: UpdateOrgProvider.isLoading
                                      ? Text(
                                          "please wait...",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(5),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "cancel",
                                    style: TextStyle(
                                      color: AppColor().primariColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
