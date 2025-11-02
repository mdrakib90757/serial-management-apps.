import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/main.dart';

import '../../../global_widgets/custom_flushbar.dart';
import '../../../global_widgets/custom_labeltext.dart';
import '../../../global_widgets/custom_sanckbar.dart';
import '../../../global_widgets/custom_textfield.dart';
import '../../../main_layouts/main_layout/main_layout.dart';
import '../../../providers/auth_provider/password_upadate_provider.dart';
import '../../../request_model/auth_request/update_password_request.dart';
import '../../../utils/color.dart';
import '../../providers/auth_provider/auth_providers.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController password_controller = TextEditingController();
  final TextEditingController Newpassword_controller = TextEditingController();
  final TextEditingController Confirmpassword_controller =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    password_controller.dispose();
    Newpassword_controller.dispose();
    Confirmpassword_controller.dispose();
  }

  Future<void> _handleChangePassword() async {
    final changePasswordProvider = Provider.of<PasswordUpdateProvider>(
      context,
      listen: false,
    );

    if (!_formkey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    UpdatePasswordRequest passwordRequest = UpdatePasswordRequest(
      currentPassword: password_controller.text,
      newPassword: Newpassword_controller.text,
    );

    final success = await changePasswordProvider.fetchUpdatePassword(
      passwordRequest,
    );

    if (!mounted) return;

    if (success) {
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Password updated successfully",
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message:
                changePasswordProvider.errorMessage ??
                "Password update failed.",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final changePassword = Provider.of<PasswordUpdateProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    UserType currentUserLayoutType;
    if (authProvider.userType?.toLowerCase().trim() == "customer") {
      currentUserLayoutType = UserType.customer;
    } else {
      currentUserLayoutType = UserType.company;
    }
    return MainLayout(
      currentIndex: 0,
      onTap: (p0) {},
      color: Colors.white,
      userType: currentUserLayoutType,
      // userType: UserType.company,
      isExtraScreen: true,
      child: Form(
        key: _formkey,
        //
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: ClipPathClipper(),
                child: Container(
                  color: AppColor().primariColor,
                  height: 250,
                  width: double.maxFinite,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            // color: AppColor().primariColor,
                          ),
                        ),
                        Text(
                          "Account Password",
                          style: TextStyle(
                            color: Colors.white,
                            //color: AppColor().primariColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // current password text filed
                    const CustomLabeltext(
                      "Current Password",
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: password_controller,
                      hintText: "Current Password",
                      isPassword: true,
                      //prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 20),

                    // new password text filed
                    const CustomLabeltext("New Password", color: Colors.white),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: Newpassword_controller,
                      hintText: "New Password",
                      isPassword: true,
                      //prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 20),

                    // confirm password text filed
                    const CustomLabeltext("Confirm Password"),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: Confirmpassword_controller,
                      hintText: "Confirm Password",
                      isPassword: true,
                      //prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 20),

                    // change password button
                    GestureDetector(
                      onTap: changePassword.isLoading
                          ? null
                          : _handleChangePassword,
                      child: Container(
                        height: 43,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor().primariColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            changePassword.isLoading
                                ? "Please Wait..."
                                : "Change Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //
                          // child: Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: SingleChildScrollView(
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             IconButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               icon: Icon(
                          //                 Icons.arrow_back,
                          //                 color: AppColor().primariColor,
                          //               ),
                          //             ),
                          //             Text(
                          //               "Account Password",
                          //               style: TextStyle(
                          //                 color: AppColor().primariColor,
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         const SizedBox(height: 20),
                          //
                          //         // current password text filed
                          //         const CustomLabeltext("Current Password"),
                          //         const SizedBox(height: 12),
                          //         CustomTextField(
                          //           controller: password_controller,
                          //           hintText: "Current Password",
                          //           isPassword: true,
                          //           //prefixIcon: Icons.lock_outline,
                          //         ),
                          //         const SizedBox(height: 20),
                          //
                          //         // new password text filed
                          //         const CustomLabeltext("New Password"),
                          //         const SizedBox(height: 12),
                          //         CustomTextField(
                          //           controller: Newpassword_controller,
                          //           hintText: "New Password",
                          //           isPassword: true,
                          //           //prefixIcon: Icons.lock_outline,
                          //         ),
                          //         const SizedBox(height: 20),
                          //
                          //         // confirm password text filed
                          //         const CustomLabeltext("Confirm Password"),
                          //         const SizedBox(height: 12),
                          //         CustomTextField(
                          //           controller: Confirmpassword_controller,
                          //           hintText: "Confirm Password",
                          //           isPassword: true,
                          //           //prefixIcon: Icons.lock_outline,
                          //         ),
                          //         const SizedBox(height: 20),
                          //
                          //         // change password button
                          //         GestureDetector(
                          //           onTap: changePassword.isLoading
                          //               ? null
                          //               : _handleChangePassword,
                          //           child: Container(
                          //             height: 43,
                          //             width: double.infinity,
                          //             decoration: BoxDecoration(
                          //               color: AppColor().primariColor,
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //             child: Center(
                          //               child: Text(
                          //                 changePassword.isLoading
                          //                     ? "Please Wait..."
                          //                     : "Change Password",
                          //                 style: TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 18,
                          //                   fontWeight: FontWeight.w600,
                          //                   //
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
