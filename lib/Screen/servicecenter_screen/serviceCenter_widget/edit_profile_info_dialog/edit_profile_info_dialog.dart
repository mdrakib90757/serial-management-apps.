//
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
//
//
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:SerialMan/global_widgets/custom_shimmer_list/CustomShimmerList%20.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/request_model/update_profile_request.dart';

import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../model/user_model.dart' hide UserType;
import '../../../../providers/auth_provider/auth_providers.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/profile_provider/profile_update_provider.dart';
import '../../../../utils/color.dart';

class edit_profile_info_dialog extends StatefulWidget {
  final User_Model user;
  final User_Model? serviceTaker;
  const edit_profile_info_dialog({
    super.key,
    required this.user,
    this.serviceTaker,
  });

  @override
  State<edit_profile_info_dialog> createState() =>
      _edit_profile_info_dialogState();
}

class _edit_profile_info_dialogState extends State<edit_profile_info_dialog> {
  DateTime? _selectedDate;
  bool isSelect = false;
  String? _selectGenter;
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String> genderList = ["Male", "Female", "Other"];

  final TextEditingController name = TextEditingController();
  final TextEditingController loginName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileNo = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    loginName.dispose();
    email.dispose();
    mobileNo.dispose();
    dateOfBirth.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final getProfileProvider = Provider.of<Getprofileprovider>(
        context,
        listen: false,
      );

      final profileInfo = getProfileProvider.profileData;

      if (profileInfo != null) {
        name.text = profileInfo.name ?? "";
        loginName.text = profileInfo.loginName ?? "";
        email.text = profileInfo.email ?? "";
        mobileNo.text = profileInfo.mobileNo ?? "";

        final profileData = profileInfo.profileData;

        if (profileData != null) {
          if (profileData.gender != null && profileData.gender!.isNotEmpty) {
            String apiGender = profileData.gender!.trim().toLowerCase();
            for (var genderInList in genderList) {
              if (genderInList.toLowerCase() == apiGender) {
                if (mounted) {
                  setState(() {
                    _selectGenter = genderInList;
                  });
                }
                break;
              }
            }
          }

          if (profileData.dateOfBirth != null &&
              profileData.dateOfBirth!.isNotEmpty) {
            String dateStringFromApi = profileData.dateOfBirth!;
            try {
              DateTime parsedDate = DateTime.parse(dateStringFromApi);
              _selectedDate = parsedDate;
              dateOfBirth.text = DateFormat('yyyy-MM-dd').format(parsedDate);
              if (mounted) {
                setState(() {});
              }
            } catch (e) {
              print("Error parsing date: $e");
            }
          }
        }
      } else {
        final user = widget.user.user;
        name.text = user.name ?? "";
        loginName.text = user.loginName ?? "";
        email.text = user.email ?? "";
        mobileNo.text = user.mobileNo ?? "";
        print(
          "Fallback: Using user data from widget constructor because provider data is null.",
        );
      }
    });
  }

  // date function
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (newDate != null && newDate != _selectedDate) {
      setState(() {
        _selectedDate = newDate;
        dateOfBirth.text = DateFormat('yyyy-MM-dd').format(newDate);
      });
    }
  }

  Future<void> _handleRefresh() async {
    await context.read<Getprofileprovider>().fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final UpdateProfile = Provider.of<ProfileProvider>(context, listen: false);
    final getProfileProvider = Provider.of<Getprofileprovider>(context);
    final profile = getProfileProvider.profileData;

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
      isExtraScreen: true,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: Colors.white,
        color: AppColor().primariColor,
        child: (profile == null)
            ? CustomShimmerList(itemCount: 10)
            //
            : Container(
                //height: 760,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
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
                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  "Edit Profile Information",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // custom name field
                            CustomLabeltext(
                              "Name",
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: name,
                              hintText: "name",
                              isPassword: false,
                            ),
                            const SizedBox(height: 10),

                            // custom login field
                            const CustomLabeltext(
                              "Login Name",
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              enabled: false,
                              filled: true,
                              fillColor: Colors.red.shade50,
                              controller: loginName,
                              hintText: "Login name",
                              isPassword: false,
                            ),
                            const SizedBox(height: 10),

                            // custom mobile no field
                            const CustomLabeltext("Mobile No"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: mobileNo,
                              hintText: "mobile no",
                              isPassword: false,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),

                            // custom email field
                            const CustomLabeltext("Email"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: email,
                              hintText: "email",
                              isPassword: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),

                            // custom gender field
                            const CustomLabeltext("Gender"),
                            const SizedBox(height: 12),
                            CustomDropdown<String>(
                              hinText: "Select Gender",
                              items: genderList,
                              value: _selectGenter,
                              itemAsString: (item) => item,
                              // validator: (value) {
                              //   if (value == null)
                              //     return "Please select a Gender";
                              //   return null;
                              // },
                              onChanged: (newValue) {
                                setState(() {
                                  _selectGenter = newValue;
                                });
                              },
                              selectedItem: _selectGenter,
                            ),
                            const SizedBox(height: 10),

                            // custom date of birth field
                            const CustomLabeltext("Date of Birth"),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                _SelectDate(context);
                              },
                              child: AbsorbPointer(
                                child: CustomTextField(
                                  readOnly: true,
                                  controller: dateOfBirth,
                                  hintText: "Select Date of Birth",
                                  textStyle: TextStyle(color: Colors.black),
                                  isPassword: false,
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // save update button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<ProfileProvider>(
                                  builder: (context, value, child) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColor().primariColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: UpdateProfile.isLoading
                                          ? null
                                          : () async {
                                              UpdateProfileRequest
                                              request = UpdateProfileRequest(
                                                //                                               UpdateProfileRequest(
                                                //
                                                name: name.text,
                                                mobileNo: mobileNo.text,
                                                email: email.text,
                                                gender: _selectGenter,
                                                dateOfBirth:
                                                    dateOfBirth.text.isNotEmpty
                                                    ? dateOfBirth.text
                                                    : null,
                                              );

                                              //
                                              //             : Padding(
                                              //                 padding: const EdgeInsets.symmetric(
                                              //                   horizontal: 20,
                                              //                   //vertical: 15
                                              //                 ),
                                              //                 child: Container(
                                              //                   //height: 760,
                                              //                   width: double.infinity,
                                              //                   decoration: BoxDecoration(color: Colors.white),
                                              //                   child: SingleChildScrollView(
                                              //                     child: Column(
                                              //                       crossAxisAlignment: CrossAxisAlignment.start,
                                              //                       mainAxisAlignment: MainAxisAlignment.start,
                                              //                       children: [
                                              //                         Row(
                                              //                           //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //                           children: [
                                              //                             IconButton(
                                              //                               onPressed: () {
                                              //                                 Navigator.pop(context);
                                              //                               },
                                              //                               icon: Icon(Icons.arrow_back, color: Colors.black),
                                              //                             ),
                                              //
                                              //                             Text(
                                              //                               "Edit Profile Information",
                                              //                               style: TextStyle(
                                              //                                 color: Colors.black,
                                              //                                 fontSize: 20,
                                              //                                 fontWeight: FontWeight.bold,
                                              //                               ),
                                              //                             ),
                                              //                           ],
                                              //                         ),
                                              //                         const SizedBox(height: 20),
                                              //
                                              //                         // custom name field
                                              //                         CustomLabeltext(
                                              //                           "Name",
                                              //                           color: Colors.black,
                                              //                           fontWeight: FontWeight.w500,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //                         CustomTextField(
                                              //                           controller: name,
                                              //                           hintText: "name",
                                              //                           isPassword: false,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //
                                              //                         // custom login field
                                              //                         const CustomLabeltext("Login Name"),
                                              //                         const SizedBox(height: 10),
                                              //                         CustomTextField(
                                              //                           enabled: false,
                                              //                           filled: true,
                                              //                           //fillColor: Colors.orange.shade400,
                                              //                           controller: loginName,
                                              //                           hintText: "Login name",
                                              //                           isPassword: false,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //
                                              //                         // custom mobile no field
                                              //                         const CustomLabeltext("Mobile No"),
                                              //                         const SizedBox(height: 10),
                                              //                         CustomTextField(
                                              //                           controller: mobileNo,
                                              //                           hintText: "mobile no",
                                              //                           isPassword: false,
                                              //                           keyboardType: TextInputType.number,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //
                                              //                         // custom email field
                                              //                         const CustomLabeltext("Email"),
                                              //                         const SizedBox(height: 10),
                                              //                         CustomTextField(
                                              //                           controller: email,
                                              //                           hintText: "email",
                                              //                           isPassword: false,
                                              //                           keyboardType: TextInputType.emailAddress,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //
                                              //                         // custom gender field
                                              //                         const CustomLabeltext("Gender"),
                                              //                         const SizedBox(height: 12),
                                              //                         CustomDropdown<String>(
                                              //                           hinText: "Select Gender",
                                              //                           items: genderList,
                                              //                           value: _selectGenter,
                                              //                           itemAsString: (item) => item,
                                              //                           // validator: (value) {
                                              //                           //   if (value == null)
                                              //                           //     return "Please select a Gender";
                                              //                           //   return null;
                                              //                           // },
                                              //                           onChanged: (newValue) {
                                              //                             setState(() {
                                              //                               _selectGenter = newValue;
                                              //                             });
                                              //                           },
                                              //                           selectedItem: _selectGenter,
                                              //                         ),
                                              //                         const SizedBox(height: 10),
                                              //
                                              //                         // custom date of birth field
                                              //                         const CustomLabeltext("Date of Birth"),
                                              //                         const SizedBox(height: 10),
                                              //                         GestureDetector(
                                              //                           onTap: () {
                                              //                             _SelectDate(context);
                                              //                           },
                                              //                           child: AbsorbPointer(
                                              //                             child: CustomTextField(
                                              //                               readOnly: true,
                                              //                               controller: dateOfBirth,
                                              //                               hintText: "Select Date of Birth",
                                              //                               textStyle: TextStyle(color: Colors.black),
                                              //                               isPassword: false,
                                              //                               suffixIcon: Icon(
                                              //                                 Icons.calendar_month,
                                              //                                 color: Colors.grey.shade400,
                                              //                               ),
                                              //                             ),
                                              //                           ),
                                              //                         ),
                                              //                         const SizedBox(height: 20),
                                              //
                                              //                         // save update button
                                              //                         Row(
                                              //                           mainAxisAlignment: MainAxisAlignment.center,
                                              //                           children: [
                                              //                             Consumer<ProfileProvider>(
                                              //                               builder: (context, value, child) {
                                              //                                 return ElevatedButton(
                                              //                                   style: ElevatedButton.styleFrom(
                                              //                                     backgroundColor: AppColor().primariColor,
                                              //                                     shape: RoundedRectangleBorder(
                                              //                                       borderRadius: BorderRadius.circular(5),
                                              //                                     ),
                                              //                                   ),
                                              //                                   onPressed: UpdateProfile.isLoading
                                              //                                       ? null
                                              //                                       : () async {
                                              //                                           UpdateProfileRequest request =
                                              //                                               UpdateProfileRequest(
                                              // //
                                              //                                                 name: name.text,
                                              //                                                 mobileNo: mobileNo.text,
                                              //                                                 email: email.text,
                                              //                                                 gender: _selectGenter,
                                              //                                                 dateOfBirth:
                                              //                                                     dateOfBirth.text.isNotEmpty
                                              //                                                     ? dateOfBirth.text
                                              //                                                     : null,
                                              //                                               );
                                              //
                                              // //
                                              //                                               final success =
                                              //                                                   await UpdateProfile.updateUserProfile(
                                              //                                                     request,
                                              //                                                   );
                                              //
                                              //                                               if (success) {
                                              //                                                 await Provider.of<
                                              //                                                       Getprofileprovider
                                              //                                                     >(context, listen: false)
                                              //                                                     .fetchProfileData();
                                              //                                                 await CustomFlushbar.showSuccess(
                                              //                                                   context: context,
                                              //                                                   title: "Success",
                                              //                                                   message:
                                              //                                                       "Profile update Successful",
                                              //                                                 );
                                              //                                                 Navigator.pop(context);
                                              //                                               } else {
                                              //                                                 ScaffoldMessenger.of(
                                              //                                                   context,
                                              //                                                 ).showSnackBar(
                                              //                                                   SnackBar(
                                              //                                                     content: CustomSnackBarWidget(
                                              //                                                       title: "Error",
                                              //                                                       message:
                                              //                                                           UpdateProfile
                                              //                                                               .errorMessage ??
                                              //                                                           "Profile Update Failed",
                                              //                                                       iconColor:
                                              //                                                           Colors.red.shade400,
                                              //                                                       icon: Icons
                                              //                                                           .dangerous_outlined,
                                              //                                                     ),
                                              //                                                     backgroundColor:
                                              //                                                         Colors.transparent,
                                              //                                                     elevation: 0,
                                              //                                                     behavior: SnackBarBehavior
                                              //                                                         .floating,
                                              //                                                     duration: Duration(
                                              //                                                       seconds: 3,
                                              //                                                     ),
                                              //                                                   ),
                                              //                                                 );
                                              //                                               }
                                              //                                             },
                                              //                                       child: Center(
                                              //                                         child: UpdateProfile.isLoading
                                              //                                             ? Text(
                                              //                                                 "Please Wait..",
                                              //                                                 style: TextStyle(
                                              //                                                   color: Colors.white,
                                              //                                                   fontSize: 15,
                                              //                                                   fontWeight: FontWeight.w500,
                                              //                                                 ),
                                              //                                               )
                                              //                                             : Text(
                                              //                                                 "Update",
                                              //                                                 style: TextStyle(
                                              //                                                   color: Colors.white,
                                              //                                                   fontSize: 15,
                                              //                                                   fontWeight: FontWeight.w500,
                                              //                                                 ),
                                              //                                               ),
                                              //                                       ),
                                              //                                     );
                                              //                                   },
                                              //                                 ),
                                              //                                 const SizedBox(width: 10),
                                              //                                 ElevatedButton(
                                              //                                   style: ElevatedButton.styleFrom(
                                              //                                     backgroundColor: Colors.white,
                                              //                                     shape: RoundedRectangleBorder(
                                              //                                       borderRadius: BorderRadius.circular(5),
                                              //                                     ),
                                              //                                   ),
                                              //                                   onPressed: () {
                                              //                                     Navigator.pop(context);
                                              //                                   },
                                              //                                   child: Text(
                                              //                                     "Cancel",
                                              //                                     style: TextStyle(
                                              //                                       color: AppColor().primariColor,
                                              //                                     ),
                                              //                                   ),
                                              //                                 ),
                                              //                               ],
                                              //                             ),
                                              //                             SizedBox(),
                                              //                           ],
                                              //                         ),
                                              //                       ),
                                              //                     ],
                                              //
                                              final success =
                                                  await UpdateProfile.updateUserProfile(
                                                    request,
                                                  );

                                              if (success) {
                                                await Provider.of<
                                                      Getprofileprovider
                                                    >(context, listen: false)
                                                    .fetchProfileData();
                                                await CustomFlushbar.showSuccess(
                                                  context: context,
                                                  title: "Success",
                                                  message:
                                                      "Profile update Successful",
                                                );
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: CustomSnackBarWidget(
                                                      title: "Error",
                                                      message:
                                                          UpdateProfile
                                                              .errorMessage ??
                                                          "Profile Update Failed",
                                                      iconColor:
                                                          Colors.red.shade400,
                                                      icon: Icons
                                                          .dangerous_outlined,
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                      child: Center(
                                        child: UpdateProfile.isLoading
                                            ? Text(
                                                "Please Wait..",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : Text(
                                                "Update",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
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
                            SizedBox(),
                          ],
                        ),
                        //
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
