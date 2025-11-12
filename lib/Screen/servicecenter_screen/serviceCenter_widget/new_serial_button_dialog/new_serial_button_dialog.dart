import 'package:SerialMan/global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/model/service_type_model.dart';
import 'package:SerialMan/providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';
import 'package:SerialMan/utils/color.dart';
import 'package:SerialMan/utils/date_formatter/date_formatter.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/ServiceTypesDeFaultifNotSet.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../../../providers/serviceCenter_provider/service_types_de_faultif_not_set_provider/service_types_de_faultif_not_set_provider.dart';

class NewSerialButtonDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenterModel;
  final BuildContext rootContext;

  const NewSerialButtonDialog({
    super.key,
    required this.serviceCenterModel,
    required this.rootContext,
  });

  @override
  State<NewSerialButtonDialog> createState() => _NewSerialButtonDialogState();
}

class _NewSerialButtonDialogState extends State<NewSerialButtonDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final _serviceTypeKey = GlobalKey<FormFieldState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _serviceCenterController;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _serviceDateDisplayController;

  serviceTypeModel? _selectedServiceType;
  DateTime _selectedDate = DateTime.now();
  bool _serviceTypeHasError = false;
  ServiceTypesDeFaultifNotSetModel? _selectedServiceTypeDeFault;

  @override
  void initState() {
    super.initState();
    _serviceCenterController = TextEditingController(
      text: widget.serviceCenterModel.name ?? "N/A",
    );
    _nameController = TextEditingController();
    _contactController = TextEditingController(text: "01");
    //
    _serviceDateDisplayController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final companyId = widget.serviceCenterModel.companyId;
    //   if (companyId != null && companyId.isNotEmpty) {
    //     Provider.of<GetAddButtonServiceType_Provider>(
    //       context,
    //       listen: false,
    //     ).fetchGetAddButton_ServiceType(companyId);
    //   } else {
    //     print("Error: Company ID is missing, cannot fetch service types.");
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceCenterId = widget.serviceCenterModel.id;
      if (serviceCenterId != null && serviceCenterId.isNotEmpty) {
        Provider.of<service_types_de_faultif_not_setProvider>(
          context,
          listen: false,
        ).fetchServiceTypes(serviceCenterId);
      } else {
        print(
          "Error: Service Center ID is missing, cannot fetch service types.",
        );
      }
    });
  }

  @override
  void dispose() {
    _serviceCenterController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _serviceDateDisplayController.dispose();
    super.dispose();
  }

  // new serial save function
  Future<void> _saveNewSerial() async {
    if (!(_dialogFormKey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
      return;
    }

    if (_selectedServiceTypeDeFault == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a service type.")),
        );
      }
      return;
    }

    final serialProvider = Provider.of<NewSerialButtonProvider>(
      context,
      listen: false,
    );

    final getSerialProvider = Provider.of<GetNewSerialButtonProvider>(
      context,
      listen: false,
    );

    String dateForApiCreate = DateFormatter.formatForApi(_selectedDate);
    String serviceTypeId = _selectedServiceTypeDeFault!.id!;
    String serviceCenterId = widget.serviceCenterModel.id!;

    NewSerialButtonRequest buttonRequest = NewSerialButtonRequest(
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      serviceDate: dateForApiCreate,
      name: _nameController.text,
      contactNo: _contactController.text,
      forSelf: false,
      isAdmin: true,
    );

    final success = await serialProvider.SerialButton(
      buttonRequest,
      serviceCenterId,
    );
    if (!mounted) return;
    if (success) {
      await getSerialProvider.fetchSerialsButton(
        serviceCenterId,
        dateForApiCreate,
      );
      // Navigator.of(context);
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: " Add NewSerial Successfully",
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(widget.rootContext).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: serialProvider.errorMessage ?? "Failed to Add User",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  //service date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            useMaterial3: false,
            colorScheme: ColorScheme.light(
              primary: AppColor().primariColor,
              onPrimary: Colors.white,
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
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
        _serviceDateDisplayController.text = DateFormat(
          "yyyy-MM-dd",
        ).format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAddButton_serviceType_Provider =
        Provider.of<GetAddButtonServiceType_Provider>(context);
    final serialProvider = Provider.of<NewSerialButtonProvider>(context);
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;

    return Dialog(
      backgroundColor: Colors.grey.shade300,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _dialogFormKey,
            autovalidateMode: _autovalidateMode,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "New Serial",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close_sharp, color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    CustomLabeltext("Service Center"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      enabled: false,
                      fillColor: Colors.red.shade50,
                      filled: true,
                      controller: _serviceCenterController,
                      isPassword: false,
                    ),

                    const SizedBox(height: 10),
                    CustomLabeltext("Service Type"),
                    const SizedBox(height: 8),
                    Consumer<service_types_de_faultif_not_setProvider>(
                      builder: (context, serviceTypeProvider, child) {
                        // if (serviceTypeProvider.state ==
                        //     NotifierState.loading) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }
                        final bool isLoading =
                            serviceTypeProvider.state == NotifierState.loading;
                        if (serviceTypeProvider.state == NotifierState.error) {
                          return Text(
                            'Error: ${serviceTypeProvider.errorMessage}',
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return CustomDropdown<ServiceTypesDeFaultifNotSetModel>(
                          hinText: "Select ServiceType",
                          items: serviceTypeProvider.serviceTypes,
                          value: _selectedServiceTypeDeFault,
                          selectedItem: _selectedServiceTypeDeFault,
                          onChanged: (ServiceTypesDeFaultifNotSetModel? newvalue) {
                            debugPrint(
                              "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                            );
                            setState(() {
                              _selectedServiceTypeDeFault = newvalue;
                            });
                          },
                          itemAsString:
                              (ServiceTypesDeFaultifNotSetModel item) =>
                                  item.name ?? "No Name",
                          validator: (value) {
                            if (value == null)
                              return "Please select a Service Type";
                            return null;
                          },
                          suffixIcon: isLoading
                              ? Container(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CustomLoading(
                                      color: AppColor().primariColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    CustomLabeltext("Date"),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: CustomTextField(
                          //  hintText: todayString,
                          textStyle: TextStyle(color: Colors.black),
                          isPassword: false,
                          readOnly: true,
                          controller: _serviceDateDisplayController,
                          suffixIcon: Icon(
                            Icons.calendar_month_outlined,
                            color: AppColor().primariColor,
                            // color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const CustomLabeltext("Name"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _nameController,
                      hintText: "Name",
                      isPassword: false,
                    ),

                    const SizedBox(height: 10),
                    const CustomLabeltext("Contact No"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: _contactController,
                      hintText: "Contact",
                      isPassword: false,
                    ),
                    const SizedBox(height: 10),

                    //Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor().primariColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _saveNewSerial,
                            child: serialProvider.isLoading
                                ? Text(
                                    "Please wait",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          const SizedBox(width: 10),
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
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
