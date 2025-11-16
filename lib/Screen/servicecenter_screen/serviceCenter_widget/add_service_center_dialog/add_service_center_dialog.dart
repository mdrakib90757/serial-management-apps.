//
import 'package:SerialMan/global_widgets/custom_clip_path.dart';
//
//
import 'package:SerialMan/global_widgets/custom_refresh_indicator.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/weekly_offdays_dropdown/weekly_offdays_dropdown.dart';
import 'package:SerialMan/global_widgets/My_Appbar.dart';
import 'package:SerialMan/main_layouts/main_layout/main_layout.dart';
import 'package:SerialMan/providers/profile_provider/getprofile_provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addButton_provider/add_Button_serviceCanter_provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/addButton_request/add_Button_request.dart';
import 'package:SerialMan/utils/color.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../add_service_center_tab_button/add_service_center_tab_button.dart';
import '../add_service_center_time_picker/add_service_center_time_picker.dart';

class Add_button_Dialog_serviceCenter_screen extends StatefulWidget {
  const Add_button_Dialog_serviceCenter_screen({super.key});

  @override
  _Add_button_Dialog_serviceCenter_screenState createState() =>
      _Add_button_Dialog_serviceCenter_screenState();
}

class _Add_button_Dialog_serviceCenter_screenState
    extends State<Add_button_Dialog_serviceCenter_screen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hotLineController = TextEditingController();
  final TextEditingController _customFieldTextController =
      TextEditingController();

  final TextEditingController _weekdayController = TextEditingController();
  final TextEditingController _advanceSerialController =
      TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _reservedController = TextEditingController();
  final TextEditingController _dailyQuotaController = TextEditingController();

  late final TabController _tabControllerForDialog;
  String? _selectedPolicy;
  List<String> _selectedOffDays = [];
  final List<String> _availableDays = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  Time? _dialogStartTime;
  Time? _dialogEndTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabControllerForDialog = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabControllerForDialog.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _hotLineController.dispose();
    _customFieldTextController.dispose();
    _dailyQuotaController.dispose();
    super.dispose();
  }

  //save service center
  Future<void> _saveServiceCenter() async {
    if (!_dialogFormKey.currentState!.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final addButtonProvider = Provider.of<AddButtonProvider>(
      context,
      listen: false,
    );
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
      context,
      listen: false,
    );

    if (companyId == null) {
      CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Service Center Added Successful",
      );
      return;
    }
    DateTime? finalStartTime;
    if (_dialogStartTime != null) {
      final now = DateTime.now();
      finalStartTime = DateTime(
        now.year,
        now.month,
        now.day,
        _dialogStartTime!.hour,
        _dialogStartTime!.minute,
      );
    }

    DateTime? finalEndTime;
    if (_dialogEndTime != null) {
      final now = DateTime.now();
      finalEndTime = DateTime(
        now.year,
        now.month,
        now.day,
        _dialogEndTime!.hour,
        _dialogEndTime!.minute,
      );
    }

    AddButtonRequest buttonRequest = AddButtonRequest(
      id: "",
      name: _nameController.text,
      email: _emailController.text,
      hotlineNo: _hotLineController.text,
      companyId: companyId,
      weeklyOffDays: _selectedOffDays,
      daysOfAdvanceSerial: _advanceSerialController.text,
      noOfReservedSerials: _reservedController.text,
      serialNoPolicy: _selectedPolicy,
      dailyQuota: _dailyQuotaController.text,
      workingEndTime: finalEndTime,
      workingStartTime: finalStartTime,
    );

    final success = await addButtonProvider.addButton(buttonRequest, companyId);

    if (success) {
      navigator.pop();
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Service Center Added Successfully",
      );
      await getAddButtonProvider.fetchGetAddButton(companyId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: addButtonProvider.errorMessage ?? "Failed to Add Service",
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
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final addButtonProvider = Provider.of<AddButtonProvider>(context);
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
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // add Service Center
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8),
                          const Text(
                            "Add Service Center",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // custom name text field
                      const CustomLabeltext("Name"),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _nameController,
                        hintText: "Name",
                        isPassword: false,
                      ),
                      const SizedBox(height: 10),

                      // custom email text field
                      const CustomLabeltext("Hotline No."),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _hotLineController,
                        hintText: "HotlineNo",
                        isPassword: false,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),

                      // custom email text field
                      const CustomLabeltext("Email", showStar: false),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        isPassword: false,
                        enableValidation: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),

                      // custom Weekly off-day button
                      const CustomLabeltext("Weekly off-day", showStar: false),
                      const SizedBox(height: 8),
                      //custom weekly off days dropdown
                      WeeklyOff_daysDropdown(
                        availableDays: _availableDays,
                        onSelectionChanged: (selectedDays) {
                          setState(() {
                            _selectedOffDays = selectedDays;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      // custom tab button
                      CustomFieldWithTabs(
                        onEndTimeChanged: (time) {
                          setState(() {
                            _dialogEndTime = time;
                          });
                        },
                        onStartTimeChanged: (time) {
                          setState(() {
                            _dialogStartTime = time;
                          });
                        },
                        tabController: _tabControllerForDialog,
                        textController: _customFieldTextController,
                      ),
                      const SizedBox(height: 10),

                      // custom advance serial text field
                      const CustomLabeltext("Advance Serials", showStar: false),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _advanceSerialController,
                        isPassword: false,
                        enableValidation: false,
                        suffixIcon: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text("Day(s)")),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),

                      // custom serial number policy tab button
                      const CustomLabeltext(
                        "Serial Number Policy",
                        showStar: false,
                      ),
                      const SizedBox(height: 8),
                      //custom policy dropdown
                      CustomTab(
                        onPolicyChanged: (policy) {
                          setState(() {
                            _selectedPolicy = policy;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // custom reserved serial text field
                      const CustomLabeltext(
                        "Reserved Serials",
                        showStar: false,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        cursorColor: Colors.grey.shade400,
                        controller: _reservedController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor().primariColor,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.symmetric(vertical: 12),
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                            child: const Center(
                              child: Text("First", style: TextStyle()),
                            ),
                          ),
                          suffixIcon: Container(
                            margin: EdgeInsets.symmetric(vertical: 12),
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                            child: const Center(child: Text("Serial(s)")),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // custom daily quota text field
                      CustomLabeltext("Daily Quota", showStar: false),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _dailyQuotaController,
                        isPassword: false,
                        keyboardType: TextInputType.number,
                        enableValidation: false,
                        suffixIcon: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(child: Text("Serials")),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // save and cancel button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: AppColor().primariColor,
                            ),
                            onPressed: addButtonProvider.isLoading
                                ? null
                                : _saveServiceCenter,
                            child: addButtonProvider.isLoading
                                ? Text(
                                    "Please Wait",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: AppColor().primariColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
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
