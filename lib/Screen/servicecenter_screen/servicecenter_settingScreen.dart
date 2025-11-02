import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/addUser_setting_serviceCenterDialog/addUser_setting_serviceCenterdialo.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/edit_addUser_settingDialog/edit_addUser_settingDialog.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/edit_organizationInfo/edit_organizationInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../global_widgets/custom_clip_path.dart';
import '../../global_widgets/custom_flushbar.dart';
import '../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../model/AddUser_serviceCenterModel.dart';
import '../../model/roles_model.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../providers/profile_provider/getprofile_provider.dart';
import '../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../providers/serviceCenter_provider/addUser_serviceCenter_provider/deleteUserProvider/deleteUserProvider.dart';
import '../../providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import '../../providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import '../../providers/serviceCenter_provider/company_details_provider/company_details_provider.dart';
import '../../providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import '../../utils/color.dart';

class Servicecenter_Settingscreen extends StatefulWidget {
  const Servicecenter_Settingscreen({super.key});

  @override
  State<Servicecenter_Settingscreen> createState() =>
      _Servicecenter_SettingscreenState();
}

class _Servicecenter_SettingscreenState
    extends State<Servicecenter_Settingscreen> {
  Data? _selectedRole;
  List<Data> rolesList = [];
  bool _isDataFetched = false;
  String? _lastFetchedCompanyId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _fetchScreenData(String companyId) async {
    if (_lastFetchedCompanyId == companyId) {}

    _lastFetchedCompanyId = companyId;

    final companyDetailsProvider = Provider.of<CompanyDetailsProvider>(
      context,
      listen: false,
    );
    final businessTypeProvider = Provider.of<BusinessTypeProvider>(
      context,
      listen: false,
    );
    final addUserServiceCenterProvider =
        Provider.of<GetAdduserServiceCenterProvider>(context, listen: false);
    final rolesProvider = Provider.of<RolesProvider>(context, listen: false);

    debugPrint("Triggering all data fetches for Company ID: $companyId");
    await Future.wait([
      companyDetailsProvider.fetchDetails(companyId),
      businessTypeProvider.fetchBusinessTypes(),
      addUserServiceCenterProvider.fetchUsers(companyId),
      rolesProvider.fetchRoles(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Getprofileprovider>(
      builder: (context, profileProvider, child) {
        final companyId = profileProvider.profileData?.currentCompany.id;
        if (companyId != null && _lastFetchedCompanyId != companyId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _fetchScreenData(companyId);
          });
        }

        if (companyId == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLoading(
                    color: AppColor().primariColor,
                    strokeWidth: 2.5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Loading company information...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        final rolesProvider = Provider.of<RolesProvider>(context);
        final getAdduser = Provider.of<GetAdduserServiceCenterProvider>(
          context,
        );
        final businessType = Provider.of<BusinessTypeProvider>(context);
        final companyDetails = Provider.of<CompanyDetailsProvider>(context);
        if ((companyDetails.isLoading &&
                companyDetails.companyDetails == null) ||
            (businessType.isLoading && businessType.businessTypes.isEmpty) ||
            (rolesProvider.isLoading && rolesProvider.roles.isEmpty) ||
            (getAdduser.isLoading && getAdduser.users.isEmpty)) {
          return Scaffold(
            backgroundColor: AppColor().backgroundColor,
            body: CustomShimmerList(itemCount: 10),
          );
        }

        // Error handling for company details
        if (companyDetails.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColor().backgroundColor,
            body: Center(child: Text(companyDetails.errorMessage!)),
          );
        }

        if (companyDetails.companyDetails == null) {
          return Scaffold(
            backgroundColor: AppColor().backgroundColor,
            body: Center(
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
                    'No company info available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
          );
        }

        final company_man = companyDetails.companyDetails!;
        final String businessTypeName =
            businessType.getBusinessTypeNameById(company_man.businessTypeId) ??
            'N/A';
        print("businessTypeName ${businessTypeName}");

        // handle refresh
        Future<void> _handleRefresh() async {
          final profileProvider = context.read<Getprofileprovider>();
          final companyId = profileProvider.profileData?.currentCompany.id;

          if (companyId != null) {
            await _fetchScreenData(companyId);
          }
        }

        return Scaffold(
          backgroundColor: AppColor().backgroundColor,
          body: RefreshIndicator(
            onRefresh: _handleRefresh,
            backgroundColor: Colors.white,
            color: AppColor().primariColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  // top custom color
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
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Organization info",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        EditOrganizationInfo(
                                          companyDetails: company_man,
                                        ),
                                    transitionsBuilder: (_, anim, __, child) {
                                      return FadeTransition(
                                        opacity: anim,
                                        child: child,
                                      );
                                    },
                                    fullscreenDialog: true,
                                  ),
                                );
                                final companyId =
                                    Provider.of<Getprofileprovider>(
                                      context,
                                      listen: false,
                                    ).profileData?.currentCompany.id;
                                if (companyId != null) {
                                  print(
                                    "Returning from edit screen. Refetching data...",
                                  );
                                  _fetchScreenData(companyId);
                                }
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                            ),
                          ],
                        ),
                        // name
                        Row(
                          children: [
                            Text(
                              "Name : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Address Line1 : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.addressLine1} ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // addressLine2 info
                        Row(
                          children: [
                            Text(
                              "AddressLine2:- ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.addressLine2}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // email info
                        Row(
                          children: [
                            Text(
                              "Email: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.email}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // phone info
                        Row(
                          children: [
                            Text(
                              "Phone : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.phone} ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // business type info
                        Row(
                          children: [
                            Text(
                              "Business Type : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${companyDetails.companyDetails?.businessType?.name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // division info
                        Row(
                          children: [
                            Text(
                              "Division : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.division?.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // district info
                        Row(
                          children: [
                            Text(
                              "District :",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.district?.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // thana info
                        Row(
                          children: [
                            Text(
                              "Thana : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.thana?.name} ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // area info
                        Row(
                          children: [
                            Text(
                              "Area : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${company_man.area?.name}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // location info
                        Row(
                          children: [
                            Text(
                              "Location : ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),

                            if (company_man.location != null &&
                                company_man.location!.isNotEmpty)
                              GestureDetector(
                                onTap: () async {
                                  final String locationString =
                                      company_man.location!;

                                  final Uri googleMapsUrl = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=$locationString',
                                  );

                                  if (await canLaunchUrl(googleMapsUrl)) {
                                    await launchUrl(googleMapsUrl);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not open the map.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.location_on,
                                  color: AppColor().primariColor,
                                  size: 24.0,
                                ),
                              )
                            else
                              Text("N/A", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 30),

                        /// add user button section 2
                        //add user Button
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Service Man",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                    bool isServiceTakerUser =
                                        authProvider.userType
                                            ?.toLowerCase()
                                            .trim() ==
                                        "customer";

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            AddUser_SettingServiceCenterDialog(),
                                        transitionsBuilder:
                                            (_, anim, __, child) {
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
                                    height: 35,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: AppColor().primariColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 18,
                                          weight: 8,
                                        ),
                                        SizedBox(width: 5),
                                        Center(
                                          child: Text(
                                            "Add user",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Name",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    "Role",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    "Active",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    "Action",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Consumer<GetAdduserServiceCenterProvider>(
                          builder: (context, getAddUser_Provider, child) {
                            if (getAddUser_Provider.isLoading &&
                                getAddUser_Provider.users.isEmpty) {
                              return Center(
                                child: CustomLoading(
                                  color: AppColor().primariColor,
                                  //size: 20,
                                  strokeWidth: 2.5,
                                ),
                              );
                            }

                            final UserList = getAddUser_Provider.users;
                            if (UserList.isEmpty) {
                              return Center(
                                child: CustomLoading(
                                  color: AppColor().primariColor,
                                  //size: 20,
                                  strokeWidth: 2.5,
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: UserList.length,
                              itemBuilder: (context, index) {
                                final user = UserList[index];

                                final String? userRoleId = user.roleId;
                                String roleName = 'N/A';

                                if (userRoleId != null &&
                                    rolesProvider.roles.isNotEmpty) {
                                  try {
                                    final foundRole = rolesProvider.roles
                                        .firstWhere(
                                          (role) => role.id == userRoleId,
                                        );
                                    roleName = foundRole.name ?? 'N/A';
                                  } catch (e) {
                                    roleName = 'Unknown Role';
                                  }
                                }

                                return Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.grey.shade400,
                                        child: Icon(
                                          Icons.person_outline_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text(user.name)),
                                            const SizedBox(width: 20),
                                            Expanded(child: Text(roleName)),
                                            Expanded(
                                              child: Text(
                                                user.isActive == true
                                                    ? "Yes"
                                                    : "No",
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    final allServiceCenters =
                                                        Provider.of<
                                                              GetAddButtonProvider
                                                            >(
                                                              context,
                                                              listen: false,
                                                            )
                                                            .serviceCenterList;
                                                    final allRoles =
                                                        Provider.of<
                                                              RolesProvider
                                                            >(
                                                              context,
                                                              listen: false,
                                                            )
                                                            .roles;

                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (_, __, ___) =>
                                                            EditAdduserSettingDialog(
                                                              userModel: user,
                                                              availableServiceCenters:
                                                                  allServiceCenters,
                                                              availableRoles:
                                                                  allRoles,
                                                            ),
                                                        transitionsBuilder:
                                                            (
                                                              _,
                                                              anim,
                                                              __,
                                                              child,
                                                            ) {
                                                              return FadeTransition(
                                                                opacity: anim,
                                                                child: child,
                                                              );
                                                            },
                                                        fullscreenDialog: true,
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                      color: AppColor()
                                                          .scoenddaryColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Builder(
                                                  builder: (BuildContext context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        _showDeleteConfirmationMenu(
                                                          context,
                                                          user,
                                                        );
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: AppColor()
                                                              .scoenddaryColor,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationMenu(
    BuildContext menuContext,
    AddUserModel user,
  ) {
    final deleteProvider = Provider.of<DeleteUserProvider>(
      context,
      listen: false,
    );
    final getUserProvider = Provider.of<GetAdduserServiceCenterProvider>(
      context,
      listen: false,
    );
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu<bool>(
      context: menuContext,
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height * -5, // Top
        offset.dx + size.width, // Right
        offset.dy + size.height, // Bottom
      ),
      items: [
        PopupMenuItem(
          // value: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure to delete?",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(menuContext).pop(false);
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(menuContext).pop(true);
                      if (companyId == null) return;
                      final success = await deleteProvider.deleteUser(
                        companyId,
                        user.id,
                      );
                      if (mounted && success) {
                        await getUserProvider.fetchUsers(companyId);
                        CustomFlushbar.showSuccess(
                          context: context,
                          message: "User deleted successfully.",
                          title: 'Success',
                        );
                      } else if (mounted) {
                        CustomFlushbar.showSuccess(
                          context: context,
                          message:
                              deleteProvider.errorMessage ??
                              "Failed to delete user.",
                          title: 'Failed',
                        );
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == true) {
        print("Delete confirmed!");
      } else {
        print("Delete canceled.");
      }
    });
  }
}
