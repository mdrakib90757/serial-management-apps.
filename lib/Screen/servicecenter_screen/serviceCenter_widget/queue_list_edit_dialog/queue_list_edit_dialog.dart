import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/newSerialButton_request/queue_edit_list_request/queue_edit_list_request.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/serialService_model.dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../model/service_type_model.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/queue_edit_list_provider/queue_edit_list_provider.dart';
import '../../../../request_model/serviceCanter_request/newSerialButton_request/newSerialButton_request.dart';
import '../../../../utils/color.dart';
import '../../../../utils/date_formatter/date_formatter.dart';

class QueueListEditDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenterModel;
  final SerialModel serialToEdit;
  const QueueListEditDialog({
    super.key,
    required this.serviceCenterModel,
    required this.serialToEdit,
  });

  @override
  State<QueueListEditDialog> createState() => _QueueListEditDialogState();
}

class _QueueListEditDialogState extends State<QueueListEditDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _serviceCenterController;
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _serviceDateDisplayController;

  serviceTypeModel? _selectedServiceType;
  DateTime _selectedDate = DateTime.now();
  bool _serviceTypeHasError = false;

  @override
  void initState() {
    super.initState();

    final serial = widget.serialToEdit;

    _serviceCenterController = TextEditingController(
      text: widget.serviceCenterModel.name ?? "N/A",
    );
    _nameController = TextEditingController(text: serial.name);
    _contactController = TextEditingController(text: serial.contactNo);

    if (serial.createdTime != null && serial.createdTime is String) {
      _selectedDate =
          DateTime.tryParse(serial.createdTime as String) ?? DateTime.now();
    } else {
      _selectedDate = DateTime.now();
    }
    _serviceDateDisplayController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyId = widget.serviceCenterModel.companyId;
      if (companyId != null && companyId.isNotEmpty) {
        Provider.of<GetAddButtonServiceType_Provider>(
          context,
          listen: false,
        ).fetchGetAddButton_ServiceType(companyId);
      } else {
        print("Error: Company ID is missing, cannot fetch service types.");
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

  Future<void> _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
    );

    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;

        _serviceDateDisplayController.text = DateFormat(
          'yyy-MM-dd',
        ).format(_selectedDate);
      });
    }
  }

  Future<void> _updateQueueSerial() async {
    if (!(_dialogFormKey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
      return;
    }

    if (_selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a service type.")),
      );
      return;
    }

    final serialProvider = Provider.of<NewSerialButtonProvider>(
      context,
      listen: false,
    );
    final queueEditListProvider = Provider.of<QueueListEditProvider>(
      context,
      listen: false,
    );

    final getSerialProvider = Provider.of<GetNewSerialButtonProvider>(
      context,
      listen: false,
    );

    String dateForApiCreate = DateFormatter.formatForApi(_selectedDate);
    String serviceTypeId = _selectedServiceType!.id!;
    String serviceCenterId = widget.serviceCenterModel.id!;
    String serviceId = widget.serialToEdit.id!;

    queueEditListRequest queueEditRequest = queueEditListRequest(
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      serviceDate: dateForApiCreate,
      name: _nameController.text,
      contactNo: _contactController.text,
      forSelf: false,
      isAdmin: true,
    );

    final success = await queueEditListProvider.QueueListEdit(
      queueEditRequest,
      serviceCenterId,
      serviceId,
    );

    if (success) {
      await getSerialProvider.fetchSerialsButton(
        serviceCenterId,
        dateForApiCreate,
      );
      Navigator.of(context);
      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Serial updated successfully",
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: serialProvider.errorMessage ?? "Failed to update serial",
            iconColor: Colors.red.shade400,
            icon: Icons.dangerous_outlined,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAddButton_serviceType_Provider =
        Provider.of<GetAddButtonServiceType_Provider>(context);
    final serialProvider = Provider.of<NewSerialButtonProvider>(context);
    final queueEditListProvider = Provider.of<QueueListEditProvider>(context);
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Container(
          //height: 415,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _dialogFormKey,
            child: SingleChildScrollView(
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
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_sharp),
                      ),
                    ],
                  ),

                  const CustomLabeltext("Service Center"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    enabled: false,
                    fillColor: Colors.red.shade50,
                    filled: true,
                    controller: _serviceCenterController,
                    isPassword: false,
                  ),

                  const SizedBox(height: 10),
                  const CustomLabeltext("Service Type"),
                  const SizedBox(height: 8),
                  Consumer<GetAddButtonServiceType_Provider>(
                    builder: (context, serviceTypeProvider, child) {
                      if (_selectedServiceType == null &&
                          widget.serialToEdit.serviceType != null) {
                        try {
                          _selectedServiceType = serviceTypeProvider
                              .serviceTypeList
                              .firstWhere(
                                (item) =>
                                    item.id ==
                                    widget.serialToEdit.serviceType!.id,
                              );
                        } catch (e) {
                          print(
                            "Default service type not found in the list: $e",
                          );
                          _selectedServiceType = null;
                        }
                      }
                      return CustomDropdown<serviceTypeModel>(
                        hinText: "Select ServiceType",
                        items:
                            getAddButton_serviceType_Provider.serviceTypeList,
                        value: _selectedServiceType,
                        selectedItem: _selectedServiceType,
                        onChanged: (serviceTypeModel? newValue) {
                          setState(() {
                            _selectedServiceType = newValue;
                            // if (newValue != null) {
                            //   _serviceTypeHasError = false;
                            // }
                          });
                          print(newValue?.name);
                        },
                        itemAsString: (serviceTypeModel item) =>
                            item.name ?? "No Name",
                        validator: (value) {
                          if (value == null)
                            return "Please select a Service Type";
                          return null;
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  const CustomLabeltext("Date"),
                  const SizedBox(height: 8),
                  CustomTextField(
                    readOnly: false,
                    onTap: _selectDate,
                    hintText: DateFormatter.formatForApi(_selectedDate),
                    textStyle: TextStyle(color: Colors.grey.shade400),
                    isPassword: false,
                    controller: _serviceDateDisplayController,
                    // readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? newDate = await showDatePicker(
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColor().primariColor,
                                  // Header color
                                  onPrimary: Colors.white,
                                  // Header text color
                                  onSurface: Colors.black, // Body text color
                                ),
                                dialogTheme: DialogThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColor()
                                        .primariColor, // Button text color
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
                      },
                      icon: Icon(
                        Icons.date_range_outlined,
                        color: Colors.grey.shade400,
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
                    controller: _contactController,
                    hintText: "Contact",
                    isPassword: false,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),

                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().primariColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _updateQueueSerial,
                        child: queueEditListProvider.isLoading
                            ? Text(
                                "Please wait",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "save",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
