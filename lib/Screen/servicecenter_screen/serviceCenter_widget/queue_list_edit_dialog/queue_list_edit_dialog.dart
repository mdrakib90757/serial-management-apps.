import 'package:SerialMan/global_widgets/custom_error_popup.dart';
import 'package:SerialMan/model/ServiceTypesDeFaultifNotSet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/newSerialButton_request/queue_edit_list_request/queue_edit_list_request.dart';
import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/serialService_model.dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/queue_edit_list_provider/queue_edit_list_provider.dart';
import '../../../../providers/serviceCenter_provider/service_types_de_faultif_not_set_provider/service_types_de_faultif_not_set_provider.dart';
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

  ServiceTypesDeFaultifNotSetModel? _ServiceTypesDeFaultifNotSetModel;
  //serviceTypeModel? _selectedServiceType;
  DateTime _selectedDate = DateTime.now();
  bool _serviceTypeHasError = false;
  bool _isInitialServiceTypeSet = false;

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
      final serviceCenterId = widget.serviceCenterModel.id;
      print('Fetching service types for Service Center ID: $serviceCenterId');
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

  // selectDate function
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
          'yyy-MM-dd',
        ).format(_selectedDate);
      });
    }
  }

  // updateQueueSerial function
  Future<void> _updateQueueSerial() async {
    if (!(_dialogFormKey.currentState?.validate() ?? false)) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
      return;
    }

    if (_ServiceTypesDeFaultifNotSetModel == null) {
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
    String serviceTypeId = _ServiceTypesDeFaultifNotSetModel!.id!;
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: CustomSnackBarWidget(
      //       title: "Error",
      //       message: serialProvider.errorMessage ?? "Failed to update serial",
      //       iconColor: Colors.red.shade400,
      //       icon: Icons.dangerous_outlined,
      //     ),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
      showCustomErrorPopup(
        context,
        serialProvider.errorMessage ?? "Failed to update serial",
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
      backgroundColor: Colors.grey.shade300,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: AppColor().primariColor),
        borderRadius: BorderRadius.circular(10),
      ),
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
                            icon: Icon(
                              Icons.close_sharp,
                              weight: 5,
                              color: Colors.grey.shade600,
                            ),
                          ),
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
                    Consumer<service_types_de_faultif_not_setProvider>(
                      builder: (context, serviceTypeProvider, child) {
                        if (serviceTypeProvider.serviceTypes.isNotEmpty &&
                            widget.serialToEdit.serviceType != null &&
                            !_isInitialServiceTypeSet) {
                          try {
                            _ServiceTypesDeFaultifNotSetModel =
                                serviceTypeProvider.serviceTypes.firstWhere(
                                  (item) =>
                                      item.id ==
                                      widget.serialToEdit.serviceType!.id,
                                );
                            _isInitialServiceTypeSet = true;
                          } catch (e) {
                            print(
                              "Initial service type not found in the list: $e",
                            );
                            _ServiceTypesDeFaultifNotSetModel = null;
                            _isInitialServiceTypeSet = true;
                          }
                        }
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
                          value: _ServiceTypesDeFaultifNotSetModel,
                          selectedItem: _ServiceTypesDeFaultifNotSetModel,
                          onChanged:
                              (ServiceTypesDeFaultifNotSetModel? newValue) {
                                setState(() {
                                  _ServiceTypesDeFaultifNotSetModel = newValue;
                                  // if (newValue != null) {
                                  //   _serviceTypeHasError = false;
                                  // }
                                });
                                print(newValue?.name);
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

                    const CustomLabeltext("Date"),
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
                          onPressed: queueEditListProvider.isLoading
                              ? null
                              : _updateQueueSerial,
                          child: queueEditListProvider.isLoading
                              ? Text(
                                  "Please wait",
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry? _overlayEntry;
  void showCustomErrorPopup(BuildContext context, String message) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 0,
        right: 0,
        child: CustomErrorPopup(
          message: message,
          onClose: () {
            if (_overlayEntry != null) {
              _overlayEntry!.remove();
              _overlayEntry = null;
            }
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }
}
