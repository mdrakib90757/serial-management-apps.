import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:SerialMan/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/profile_screen/password_screen.dart';
import 'package:SerialMan/Screen/profile_screen/profile_edit%20screen.dart';
import '../../../main_layouts/main_layout/main_layout.dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';

class profile_screen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const profile_screen({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<profile_screen> createState() => _profile_screenState();
}

class _profile_screenState extends State<profile_screen> {
  @override
  Widget build(BuildContext context) {
    final getupdateprofile = Provider.of<Getprofileprovider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    UserType currentUserLayoutType;
    if (authProvider.userType?.toLowerCase().trim() == "customer") {
      currentUserLayoutType = UserType.customer;
    } else {
      currentUserLayoutType = UserType.company;
    }
    bool isCompanyUser =
        authProvider.userType?.toLowerCase().trim() == "company";

    // Define the core content of the profile screen
    Widget profileContent = Scaffold(
      backgroundColor: Colors.white,
      body:
          // MainLayout(
          //   currentIndex: 0,
          //   onTap: (p0) {},
          //   color: Colors.white,
          //   userType: currentUserLayoutType,
          //   // userType: UserType.company,
          //   isExtraScreen: true,
          //   child:
          // ui
          // Widget profileContent = Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //
          Stack(
            children: [
              ClipPath(
                clipper: ClipPathClipper(),
                child: Container(
                  color: AppColor().primariColor,
                  height: 250,
                  width: double.maxFinite,
                ),
              ), // Adjust vertical padding as needed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade400,
                        child: Icon(
                          CupertinoIcons.person,
                          size: 60,
                          color: AppColor().primariColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 3),
                      const SizedBox(height: 10),

                      // navigate to Profile Edit screen
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => ProfileEditScreen(),
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: child,
                                );
                              },
                              fullscreenDialog: true,
                            ),
                          );
                          Future.microtask(() {
                            getupdateprofile.fetchProfileData();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Profile information",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 18,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // navigate to Service Taker Password screen
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => PasswordScreen(),
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
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Change Password",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 18,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    //
                  ),

                  ///
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: SingleChildScrollView(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       //crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         CircleAvatar(
                  //           radius: 70,
                  //           backgroundColor: Colors.grey.shade400,
                  //           child: Icon(
                  //             CupertinoIcons.person,
                  //             size: 60,
                  //             color: AppColor().primariColor,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 20),
                  //         Divider(height: 3),
                  //         const SizedBox(height: 10),
                  //
                  //         // navigate to Profile Edit screen
                  //         GestureDetector(
                  //           onTap: () async {
                  //             Navigator.push(
                  //               context,
                  //               PageRouteBuilder(
                  //                 pageBuilder: (_, __, ___) => ProfileEditScreen(),
                  //                 transitionsBuilder: (_, anim, __, child) {
                  //                   return FadeTransition(opacity: anim, child: child);
                  //                 },
                  //                 fullscreenDialog: true,
                  //               ),
                  //             );
                  //             Future.microtask(() {
                  //               getupdateprofile.fetchProfileData();
                  //             });
                  //           },
                  //           child: Container(
                  //             height: 50,
                  //             width: double.infinity,
                  //             decoration: BoxDecoration(
                  //               border: Border.all(color: Colors.grey.shade400),
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 15),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     "Profile information",
                  //                     style: TextStyle(
                  //                       color: Colors.black.withOpacity(0.9),
                  //                       fontSize: 18,
                  //                     ),
                  //                   ),
                  //                   Icon(Icons.arrow_forward_ios, size: 20),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(height: 10),
                  //
                  //         // navigate to Service Taker Password screen
                  //         GestureDetector(
                  //           onTap: () async {
                  //             Navigator.push(
                  //               context,
                  //               PageRouteBuilder(
                  //                 pageBuilder: (_, __, ___) => PasswordScreen(),
                  //                 transitionsBuilder: (_, anim, __, child) {
                  //                   return FadeTransition(opacity: anim, child: child);
                  //                 },
                  //                 fullscreenDialog: true,
                  //               ),
                  //             );
                  //           },
                  //           child: Container(
                  //             height: 50,
                  //             width: double.infinity,
                  //             decoration: BoxDecoration(
                  //               border: Border.all(color: Colors.grey.shade400),
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 15),
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     "Change Password",
                  //                     style: TextStyle(
                  //                       color: Colors.black.withOpacity(0.9),
                  //                       fontSize: 18,
                  //                     ),
                  //                   ),
                  //                   Icon(Icons.arrow_forward_ios, size: 20),
                  //                 ],
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
            ],
          ),
    );
    // );

    // Conditionally wrap with MainLayout
    if (isCompanyUser) {
      UserType currentUserLayoutType = UserType.company;

      return MainLayout(
        userType: currentUserLayoutType,
        color: Colors.white,
        currentIndex: null,
        onTap: widget.onTap,
        child: profileContent,
        isExtraScreen: true,
      );
    } else {
      return profileContent;
    }
  }
}
