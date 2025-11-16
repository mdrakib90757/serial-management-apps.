import 'package:SerialMan/global_widgets/custom_clip_path.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/providers/profile_provider/getprofile_provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:SerialMan/utils/color.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../main_layouts/main_layout/main_layout.dart';
import '../../../../providers/serviceCenter_provider/editButton_serviceCenter_provider/edit_Button_serviceCenter_Provider.dart';
import '../../../../providers/serviceCenter_provider/editButton_serviceCenter_provider/get_EditButton_provider.dart';
import '../../../../request_model/serviceCanter_request/editButton_request_serviceCenter/edit_Button_request.dart';
import '../add_service_center_tab_button/add_service_center_tab_button.dart';
import '../add_service_center_time_picker/add_service_center_time_picker.dart';
import '../weekly_offdays_dropdown/weekly_offdays_dropdown.dart';

class EditServiceCenterDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenter;

  const EditServiceCenterDialog({super.key, required this.serviceCenter});

  @override
  State<EditServiceCenterDialog> createState() =>
      _EditServiceCenterDialogState();
}

class _EditServiceCenterDialogState extends State<EditServiceCenterDialog>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController hotlinenoController;
  late TextEditingController emailController;
  late TabController _tabControllerForDialog;
  late TextEditingController _customFieldTextController;
  late TextEditingController _advanceSerialController;
  late TextEditingController _reservedController;
  late TextEditingController _dailyQuotaController;

  Time? _dialogStartTime;
  Time? _dialogEndTime;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabControllerForDialog = TabController(length: 2, vsync: this);

    final serviceCenter = widget.serviceCenter;

    nameController = TextEditingController(text: serviceCenter.name ?? '');
    hotlinenoController = TextEditingController(
      text: serviceCenter.hotlineNo ?? '',
    );
    emailController = TextEditingController(text: serviceCenter.email ?? '');
    _advanceSerialController = TextEditingController(
      text: serviceCenter.daysOfAdvanceSerial?.toString() ?? '0',
    );
    _reservedController = TextEditingController(
      text: serviceCenter.noOfReservedSerials?.toString() ?? '0',
    );
    _dailyQuotaController = TextEditingController(
      text: serviceCenter.dailyQuota?.toString() ?? "0",
    );
    _selectedPolicy = serviceCenter.serialNoPolicy;

    _customFieldTextController = TextEditingController(
      text: serviceCenter.serialNoPolicy,
    );

    _selectedOffDays = List<String>.from(serviceCenter.weeklyOffDays ?? []);

    if (serviceCenter.workingStartTime != null) {
      final startTime = serviceCenter.workingStartTime!;
      _dialogStartTime = Time(hour: startTime.hour, minute: startTime.minute);
    } else {
      _dialogStartTime = null;
    }

    if (serviceCenter.workingEndTime != null) {
      final endTime = serviceCenter.workingEndTime!;
      _dialogEndTime = Time(hour: endTime.hour, minute: endTime.minute);
    } else {
      _dialogEndTime = null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    hotlinenoController.dispose();
    emailController.dispose();
    _tabControllerForDialog.dispose();
    _customFieldTextController.dispose();
    _advanceSerialController.dispose();
    _reservedController.dispose();
    _dailyQuotaController.dispose();
    _dialogStartTime = null;
    _dialogEndTime = null;
    _selectedPolicy = null;
    _selectedOffDays = [];
    super.dispose();
  }

  Future<void> _UpdateServiceCenter() async {
    if (_dialogFormKey.currentState!.validate()) {
      final serviceCenter = widget.serviceCenter;

      final editButtonProvider = Provider.of<EditButtonProvider>(
        context,
        listen: false,
      );
      final getEditButtonProvider = Provider.of<GetEditButtonProvider>(
        context,
        listen: false,
      ).selectedServiceCenterId;
      final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
        context,
        listen: false,
      );
      final navigator = Navigator.of(context);
      final companyId = Provider.of<Getprofileprovider>(
        context,
        listen: false,
      ).profileData?.currentCompany.id;

      if (companyId == null) {
        return;
      }

      String? formatTimeForApi(Time? time) {
        if (time == null) return null;
        final now = DateTime.now();
        final dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
      }

      EditButtonRequest editRequest = EditButtonRequest(
        id: widget.serviceCenter.id,
        name: nameController.text,
        hotlineNo: hotlinenoController.text,
        email: emailController.text,
        companyId: companyId,
        customTextForSerialNo: serviceCenter.serialNoPolicy,
        dailyQuota: int.tryParse(_dailyQuotaController.text) ?? 0,
        daysOfAdvanceSerial: int.tryParse(_advanceSerialController.text) ?? 0,
        noOfReservedSerials: int.tryParse(_reservedController.text) ?? 0,
        serialNoPolicy: _selectedPolicy,
        weeklyOffDays: _selectedOffDays,
        workingEndTime: formatTimeForApi(_dialogEndTime),
        workingStartTime: formatTimeForApi(_dialogStartTime),
      );
      final success = await editButtonProvider.editButton(
        editRequest,
        companyId,
        widget.serviceCenter.id,
      );
      if (success) {
        navigator.pop();
        await CustomFlushbar.showSuccess(
          context: context,
          title: "Success",
          message: "Edit Service Center Update Successful",
        );
        if (companyId != null && companyId.isNotEmpty) {
          await getAddButtonProvider.fetchGetAddButton(companyId);
        }
      } else {
        navigator.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackBarWidget(
              title: "Error",
              message:
                  editButtonProvider.errorMessage ??
                  "Failed to Edit Service Center Update",
              iconColor: Colors.red.shade400,
              icon: Icons.dangerous_outlined,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh() async {
    final getAddButtonProvider = context.read<GetAddButtonProvider>();
    final companyId = context
        .read<Getprofileprovider>()
        .profileData
        ?.currentCompany
        .id;

    if (companyId == null) {
      return;
    }

    await getAddButtonProvider.fetchGetAddButton(companyId);
  }

  @override
  Widget build(BuildContext context) {
    final editButtonProvider = Provider.of<EditButtonProvider>(context);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Edit Service Center",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),

                      // Service Center Name text field
                      const CustomLabeltext("ServiceCenter Name"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: nameController,
                        hintText: "Name",
                        isPassword: false,
                      ),
                      const SizedBox(height: 13),

                      // custom hotline text filed
                      const CustomLabeltext("Hotline No."),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: hotlinenoController,
                        hintText: "Hotline No",
                        isPassword: false,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),

                      // custom email text field
                      const CustomLabeltext("Email", showStar: false),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        isPassword: false,
                        enableValidation: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),

                      // custom weekly day off filed
                      const CustomLabeltext("Weekly off-day", showStar: false),
                      const SizedBox(height: 8),
                      WeeklyOff_daysDropdown(
                        initialSelectedDays: _selectedOffDays,
                        availableDays: _availableDays,
                        onSelectionChanged: (selectedDays) {
                          setState(() {
                            _selectedOffDays = selectedDays;
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // custom tab
                      CustomFieldWithTabs(
                        initialEndTime: _dialogEndTime,
                        initialStartTime: _dialogStartTime,
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
                        keyboardType: TextInputType.number,
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
                      ),
                      const SizedBox(height: 10),

                      // custom serial number policy
                      const CustomLabeltext(
                        "Serial Number Policy",
                        showStar: false,
                      ),
                      const SizedBox(height: 8),
                      CustomTab(
                        initialPolicy: _selectedPolicy,
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
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                            child: const Center(child: Text("First")),
                          ),
                          suffixIcon: Container(
                            width: 80,
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
                      SizedBox(height: 10),

                      // custom daily quota text field
                      const CustomLabeltext("Daily Quota", showStar: false),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _dailyQuotaController,
                        isPassword: false,
                        enableValidation: false,
                        keyboardType: TextInputType.number,
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
                      ),
                      const SizedBox(height: 10),

                      //Button Logic
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
                            onPressed: editButtonProvider.isLoading
                                ? null
                                : _UpdateServiceCenter,
                            child: editButtonProvider.isLoading
                                ? Text(
                                    "Please wait...",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),

                          SizedBox(width: 10),

                          //cancel Button
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
                              style: TextStyle(color: AppColor().primariColor),
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
