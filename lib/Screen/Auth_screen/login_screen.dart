import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/Auth_screen/registration_screen.dart';
import 'package:SerialMan/global_widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'package:SerialMan/global_widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import 'package:SerialMan/global_widgets/custom_sanckbar.dart';
import '../../global_widgets/custom_textfield.dart';
import '../../main_layouts/service_center_layout/service_center_layout.dart';
import '../../main_layouts/service_taker_layout/service_taker_layout.dart';
import '../../providers/auth_provider/auth_providers.dart';
import '../../request_model/auth_request/login_request.dart';

import '../../utils/color.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMod = AutovalidateMode.disabled;

  bool obscureIndex = true;
  bool isLoading = false;
  String? _errorMessage;
  TextEditingController loginName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginName.dispose();
    password.dispose();
  }

  //login handle logic
  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.clearError();

    if (!_formkey.currentState!.validate()) {
      setState(() {
        autovalidateMod = AutovalidateMode.always;
      });
      return;
    }

    final request = LoginRequest(
      loginName: loginName.text.trim(),
      password: password.text,
    );
    bool success = await authProvider.login(request: request);

    if (success) {
      String userType = authProvider.userType?.toLowerCase().trim() ?? "";

      if (userType == "company") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceCenterLayout()),
        );
      } else if (userType == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ServiceTakerLayout()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown User Type${userType}'),
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          content: CustomSnackBarWidget(
            title: "Error",
            message: authProvider.errorMessage ?? "Login Failed",
          ),
        ),
      );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formkey,
      autovalidateMode: autovalidateMod,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/serialman (2).png",
                    height: 200,
                    width: 250,
                  ),
                  CustomTextField(
                    hintText: "Login name",
                    isPassword: false,
                    controller: loginName,
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Password",
                    isPassword: true,
                    controller: password,
                    prefixIcon: Icons.lock,
                  ),

                  SizedBox(height: 8),

                  //Forget screen navigate text
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot password",
                        style: TextStyle(
                          color: AppColor().primariColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),

                  //error text
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  SizedBox(height: 10),

                  //Login Button
                  GestureDetector(
                    onTap: authProvider.isLoading ? null : _handleLogin,
                    child: Container(
                      height: 43,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: authProvider.isLoading
                          ? Center(
                              child: Text(
                                "Please Wait..",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //Text
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "don`t have an account?",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  //Register screen Navigate Text
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColor().primariColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
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
