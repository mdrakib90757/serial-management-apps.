import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/main_layouts/main_layout/main_layout.dart';

import '../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../../providers/auth_provider/auth_providers.dart';
import '../../../providers/profile_provider/getprofile_provider.dart';
import '../../../utils/color.dart';
import '../servicecenter_screen/serviceCenter_widget/edit_profile_info_dialog/edit_profile_info_dialog.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "Not set";
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final getprofileProvider = Provider.of<Getprofileprovider>(context);
    final profile = getprofileProvider.profileData;
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final authProviderr = Provider.of<AuthProvider>(context);
    UserType currentUserLayoutType;
    if (authProviderr.userType?.toLowerCase().trim() == "customer") {
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
      child: (profile == null)
          ? CustomShimmerList(itemCount: 10)
          : Stack(
              children: [
                ClipPath(
                  clipper: ClipPathClipper(),
                  child: Container(
                    color: AppColor().primariColor,
                    height: 250,
                    width: double.maxFinite,
                  ),
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //color: Colors.transparent.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          //
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    // color: Colors.black,
                                    color: AppColor().primariColor,
                                  ),
                                ),
                                Text(
                                  "Basic Information",
                                  style: TextStyle(
                                    // color: Colors.black,
                                    color: AppColor().primariColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 15),

                            // IconButton navigate to edit profile dialog
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        edit_profile_info_dialog(
                                          user: authProvider.userModel!,
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
                              },
                              icon: Icon(
                                Icons.edit_sharp,
                                size: 25,
                                //color: Colors.white,
                                color: AppColor().primariColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // dialog part
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Consumer(
                                  builder: (context, value, child) {
                                    return Text(
                                      profile!.name,
                                      //authProvider.user_model!.user.name??"",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),
                        //
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login Name",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Consumer(
                                  builder: (context, value, child) {
                                    return Text(
                                      //authProvider.user_model!.user.loginName??"",
                                      profile!.loginName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile No",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Consumer(
                                  builder: (context, value, child) {
                                    return Text(
                                      //authProvider.user_model!.user.mobileNo??"",
                                      profile!.mobileNo,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        //SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Consumer(
                                  builder: (context, value, child) {
                                    return Text(
                                      //authProvider.user_model!.user.email??"",
                                      profile!.email,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        //SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  profile?.profileData?.gender ?? "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //SizedBox(height: 5,),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date of birth",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatDate(
                                        profile?.profileData?.dateOfBirth,
                                      ) ??
                                      "No DOB",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
