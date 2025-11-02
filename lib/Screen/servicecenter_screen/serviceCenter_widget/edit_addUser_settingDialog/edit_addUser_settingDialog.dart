//
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
//
//
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/AddUser_serviceCenterModel.dart';
import 'package:SerialMan/model/roles_model.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addUser_serviceCenter_provider/update_addUser_serviceCenter/update_addUser_serviceCenter.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addUser_serviceCenterRequest/editUserRequest/editUserRequest.dart';
import 'package:SerialMan/utils/color.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../../../providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import '../../../../providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import '../AssignedServiceCenter/AssignedServiceCenter.dart';

class EditAdduserSettingDialog extends StatefulWidget {
  final AddUserModel? userModel;
  final List<ServiceCenterModel> availableServiceCenters;
  final List<Data> availableRoles;
  const EditAdduserSettingDialog({
    super.key,
    this.userModel,
    required this.availableServiceCenters,
    required this.availableRoles,
  });

  @override
  State<EditAdduserSettingDialog> createState() =>
      _EditAdduserSettingDialogState();
}

class _EditAdduserSettingDialogState extends State<EditAdduserSettingDialog> {
  final _fromKey = GlobalKey<FormState>();
  Data? _selectedRole;
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> _selectedServiceCenters = [];
  List<ServiceCenterModel> _selectedServiceCentersForUser = [];
  bool _isActive = true;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  late TextEditingController _nameController;
  late TextEditingController _loginNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final currentUser = widget.userModel;
    if (currentUser != null) {
      _nameController = TextEditingController(text: currentUser.name);
      _loginNameController = TextEditingController(text: currentUser.loginName);
      _emailController = TextEditingController(text: currentUser.email);
      _phoneController = TextEditingController(text: currentUser.mobileNo);
      _isActive = currentUser.isActive ?? true;

      final String? userRoleId = currentUser.roleId;
      if (userRoleId != null && widget.availableRoles.isNotEmpty) {
        try {
          _selectedRole = widget.availableRoles.firstWhere(
            (role) => role.id == userRoleId,
          );
        } catch (e) {
          debugPrint("Role with ID $userRoleId not found in available roles.");
          _selectedRole = null;
        }
      }

      final List<String> assignedIds = currentUser.serviceCenterIds;
      if (widget.availableServiceCenters.isNotEmpty && assignedIds.isNotEmpty) {
        _selectedServiceCentersForUser = widget.availableServiceCenters
            .where((center) => assignedIds.contains(center.id))
            .toList();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loginNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _UpdateAddUserInfo() async {
    if (!(_fromKey.currentState?.validate() ?? false)) {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final updateAddUserProvider = Provider.of<UpdateAddUserProvider>(
      context,
      listen: false,
    );
    final getAddUserButton = Provider.of<GetAdduserServiceCenterProvider>(
      context,
      listen: false,
    );
    final String? userId = widget.userModel?.id;
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;

    final navigator = Navigator.of(context);
    if (companyId == null) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "  User Update Successful",
      );
      return;
    }
    EditUserRequest userRequest = EditUserRequest(
      name: _nameController.text,
      loginName: _loginNameController.text,
      email: _emailController.text,
      mobileNo: _phoneController.text,
      roleId: _selectedRole!.id!,
      serviceCenterIds: _selectedServiceCentersForUser
          .map((sc) => sc.id!)
          .toList(),
      isActive: _isActive,
    );
    final success = await updateAddUserProvider.UpdateAddUserButton(
      userRequest,
      companyId,
      userId!,
    );
    if (success) {
      await getAddUserButton.fetchUsers(companyId);
      navigator.pop();
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "  User Update Successfully",
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: updateAddUserProvider.errorMessage ?? "Failed to Add User",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  Future<void> _handleRefresh() async {
    final profileProvider = context.read<Getprofileprovider>();
    final companyId = profileProvider.profileData?.currentCompany.id;
    if (companyId != null) {
      await Future.wait([
        context.read<RolesProvider>().fetchRoles(),
        context.read<GetAddButtonProvider>().fetchGetAddButton(companyId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateProvider = Provider.of<UpdateAddUserProvider>(context);
    final serviceCenterProvider = Provider.of<GetAddButtonProvider>(context);
    final rolesProvider = Provider.of<RolesProvider>(context);

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
        child: (rolesProvider.isLoading && rolesProvider.roles.isEmpty)
            ? CustomShimmerList(itemCount: 10)
            //
            : Form(
                key: _fromKey,
                autovalidateMode: _autoValidateMode,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Edit Service Man",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // custom name text field
                            const CustomLabeltext("Name", color: Colors.white),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _nameController,
                              isPassword: false,
                              hintText: "Name",
                              //  prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 10),

                            // custom login name text field
                            const CustomLabeltext(
                              "Login Name",
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _loginNameController,
                              hintText: "Login Name",
                              isPassword: false,
                              //controller: phone
                            ),

                            // custom email text field
                            const SizedBox(height: 10),
                            const CustomLabeltext(
                              "Email Address",
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _emailController,
                              hintText: "Email address",
                              isPassword: false,
                              // prefixIcon: Icons.email_outlined,
                              //controller: phone
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),

                            // custom mobile number text field
                            const CustomLabeltext("Mobile Number"),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _phoneController,
                              hintText: "Mobile Number",
                              isPassword: false,
                              //controller: phone,
                              // prefixIcon: Icons.call,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),

                            // custom role dropdown
                            const CustomLabeltext("Role"),
                            const SizedBox(height: 10),
                            CustomDropdown<Data>(
                              items: widget.availableRoles,
                              value: _selectedRole,
                              selectedItem: _selectedRole,
                              onChanged: (Data? newValue) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                              },
                              itemAsString: (Data? item) =>
                                  item?.name ?? "No name",
                              hinText: "Select Role",
                            ),
                            SizedBox(height: 10),

                            // custom service center dropdown
                            CustomLabeltext(
                              "Assigned Service Center",
                              showStar: false,
                            ),
                            const SizedBox(height: 10),
                            AssignedServiceCentersDropdown(
                              availableServiceCenters:
                                  widget.availableServiceCenters,
                              initialSelectedCenters:
                                  _selectedServiceCentersForUser,
                              onSelectionChanged: (selectedList) {
                                setState(() {
                                  _selectedServiceCentersForUser = selectedList;
                                });
                              },
                            ),
                            SizedBox(height: 13),

                            // custom active switch
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _isActive == true ? "Active" : "Inactive",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 1,
                                  child: Switch(
                                    padding: EdgeInsets.all(5),
                                    value: _isActive,
                                    onChanged: (bool newValue) {
                                      setState(() {
                                        _isActive = newValue;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: AppColor().primariColor,
                                    inactiveTrackColor: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),

                            // custom save and cancel button
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
                                  onPressed: _UpdateAddUserInfo,
                                  child: updateProvider.isLoading
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
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                    //
                    //           child  : Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                   horizontal: 15,
                    //                   // vertical: 10,
                    //                 ),
                    //                 child: Form(
                    //                   key: _fromKey,
                    //                   autovalidateMode: _autoValidateMode,
                    //                   child: SingleChildScrollView(
                    //                     child: Column(
                    //                       mainAxisAlignment: MainAxisAlignment.start,
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Row(
                    //                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                           children: [
                    //                             IconButton(
                    //                               onPressed: () {
                    //                                 Navigator.pop(context);
                    //                               },
                    //                               icon: Icon(Icons.arrow_back, color: Colors.black),
                    //                             ),
                    //                             Text(
                    //                               "Edit Service Man",
                    //                               style: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 18,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         const SizedBox(height: 10),
                    //
                    //                         // custom name text field
                    //                         const CustomLabeltext("Name"),
                    //                         const SizedBox(height: 8),
                    //                         CustomTextField(
                    //                           controller: _nameController,
                    //                           isPassword: false,
                    //                           hintText: "Name",
                    //                           //  prefixIcon: Icons.person,
                    //                         ),
                    //                         const SizedBox(height: 10),
                    //
                    //                         // custom login name text field
                    //                         const CustomLabeltext("Login Name"),
                    //                         const SizedBox(height: 8),
                    //                         CustomTextField(
                    //                           controller: _loginNameController,
                    //                           hintText: "Login Name",
                    //                           isPassword: false,
                    //                           //controller: phone
                    //                         ),
                    //
                    //                         // custom email text field
                    //                         const SizedBox(height: 10),
                    //                         const CustomLabeltext("Email Address"),
                    //                         const SizedBox(height: 8),
                    //                         CustomTextField(
                    //                           controller: _emailController,
                    //                           hintText: "Email address",
                    //                           isPassword: false,
                    //                           // prefixIcon: Icons.email_outlined,
                    //                           //controller: phone
                    //                           keyboardType: TextInputType.emailAddress,
                    //                         ),
                    //                         const SizedBox(height: 10),
                    //
                    //                         // custom mobile number text field
                    //                         const CustomLabeltext("Mobile Number"),
                    //                         const SizedBox(height: 8),
                    //                         CustomTextField(
                    //                           controller: _phoneController,
                    //                           hintText: "Mobile Number",
                    //                           isPassword: false,
                    //                           //controller: phone,
                    //                           // prefixIcon: Icons.call,
                    //                           keyboardType: TextInputType.number,
                    //                         ),
                    //                         const SizedBox(height: 10),
                    //
                    //                         // custom role dropdown
                    //                         const CustomLabeltext("Role"),
                    //                         const SizedBox(height: 10),
                    //                         CustomDropdown<Data>(
                    //                           items: widget.availableRoles,
                    //                           value: _selectedRole,
                    //                           selectedItem: _selectedRole,
                    //                           onChanged: (Data? newValue) {
                    //                             setState(() {
                    //                               _selectedRole = newValue;
                    //                             });
                    //                           },
                    //                           itemAsString: (Data? item) => item?.name ?? "No name",
                    //                           hinText: "Select Role",
                    //                         ),
                    //                         SizedBox(height: 10),
                    //
                    //                         // custom service center dropdown
                    //                         CustomLabeltext(
                    //                           "Assigned Service Center",
                    //                           showStar: false,
                    //                         ),
                    //                         const SizedBox(height: 10),
                    //                         AssignedServiceCentersDropdown(
                    //                           availableServiceCenters:
                    //                               widget.availableServiceCenters,
                    //                           initialSelectedCenters:
                    //                               _selectedServiceCentersForUser,
                    //                           onSelectionChanged: (selectedList) {
                    //                             setState(() {
                    //                               _selectedServiceCentersForUser = selectedList;
                    //                             });
                    //                           },
                    //                         ),
                    //                         SizedBox(height: 13),
                    //
                    //                         // custom active switch
                    //                         Row(
                    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                           children: [
                    //                             Text(
                    //                               _isActive == true ? "Active" : "Inactive",
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                             Transform.scale(
                    //                               scale: 1,
                    //                               child: Switch(
                    //                                 padding: EdgeInsets.all(5),
                    //                                 value: _isActive,
                    //                                 onChanged: (bool newValue) {
                    //                                   setState(() {
                    //                                     _isActive = newValue;
                    //                                   });
                    //                                 },
                    //                                 activeColor: Colors.white,
                    //                                 activeTrackColor: AppColor().primariColor,
                    //                                 inactiveTrackColor: Colors.grey.shade200,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //
                    //                         // custom save and cancel button
                    //                         Row(
                    //                           mainAxisAlignment: MainAxisAlignment.center,
                    //                           children: [
                    //                             ElevatedButton(
                    //                               style: ElevatedButton.styleFrom(
                    //                                 shape: RoundedRectangleBorder(
                    //                                   borderRadius: BorderRadiusGeometry.circular(
                    //                                     5,
                    //                                   ),
                    //                                 ),
                    //                                 backgroundColor: AppColor().primariColor,
                    //                               ),
                    //                               onPressed: _UpdateAddUserInfo,
                    //                               child: updateProvider.isLoading
                    //                                   ? Text(
                    //                                       "please wait...",
                    //                                       style: TextStyle(color: Colors.white),
                    //                                     )
                    //                                   : Text(
                    //                                       "Save",
                    //                                       style: TextStyle(color: Colors.white),
                    //                                     ),
                    //                             ),
                    //                             SizedBox(width: 8),
                    //                             ElevatedButton(
                    //                               style: ElevatedButton.styleFrom(
                    //                                 shape: RoundedRectangleBorder(
                    //                                   borderRadius: BorderRadiusGeometry.circular(
                    //                                     5,
                    //                                   ),
                    //                                 ),
                    //                                 backgroundColor: Colors.white,
                    //                               ),
                    //                               onPressed: () {
                    //                                 Navigator.pop(context);
                    //                               },
                    //                               child: Text(
                    //                                 "cancel",
                    //                                 style: TextStyle(
                    //                                   color: AppColor().primariColor,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         SizedBox(height: 30),
                    //                       ],
                    //                     ),
                    // //
                    //                   ),
                    //                 ),
                    //               ),
                  ),
                ),
              ),
      ),
    );
  }
}
