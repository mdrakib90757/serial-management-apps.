import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/providers/profile_provider/getprofile_provider.dart';
import 'package:SerialMan/request_model/serviceCanter_request/add_service_center_service_type_request/service_center_service_type_request.dart';

import '../../../../global_widgets/custom_circle_progress_indicator/custom_circle_progress_indicator.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/service_type_model.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/add_service_center_serviceType_provider/add_service_center_service_type_provider.dart';
import '../../../../providers/serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';
import '../../../../request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';
import '../../../../utils/color.dart';

class add_service_center_service_type_dialog extends StatefulWidget {
  final ServiceCenterModel? selectedServiceCenter;
  const add_service_center_service_type_dialog({
    super.key,
    this.selectedServiceCenter,
  });

  @override
  State<add_service_center_service_type_dialog> createState() =>
      _add_service_center_service_type_dialogState();
}

class _add_service_center_service_type_dialogState
    extends State<add_service_center_service_type_dialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController ServiceTypeController = TextEditingController();
  final TextEditingController ServicePriceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  ServiceCenterModel? serviceCenterModel;
  serviceTypeModel? _selectedServiceType;
  @override
  void dispose() {
    // TODO: implement dispose

    ServiceTypeController.dispose();
    ServicePriceController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    serviceCenterModel = widget.selectedServiceCenter;
  }

  // save serviceCenter ServiceType second Option
  Future<void> _saveAddSecondServiceType() async {
    if (!_dialogFormKey.currentState!.validate()) {
      debugPrint("Form is invalid!");
      return;
    }
    debugPrint("Form is valid, proceeding to save...");

    final secondGetServiceType =
        Provider.of<get_service_center_service_type_provider>(
          context,
          listen: false,
        );
    final navigator = Navigator.of(context);

    final secondServiceType =
        Provider.of<add_service_center_service_type_provider>(
          context,
          listen: false,
        );

    final ServiceCenterId = widget.selectedServiceCenter?.id ?? "";
    final ServiceTypeId = _selectedServiceType?.id ?? "";
    final price =
        int.tryParse(ServicePriceController.text) ??
        double.tryParse(ServicePriceController.text)?.toInt() ??
        0;

    final time =
        int.tryParse(timeController.text) ??
        double.tryParse(timeController.text)?.toInt() ??
        0;

    add_service_center_service_type_request serviceTypeRequest =
        add_service_center_service_type_request(
          id: ServiceTypeId,
          price: price,
          defaultAllocatedTime: time,
        );

    final success = await secondServiceType.postServiceType(
      ServiceCenterId,
      serviceTypeRequest,
    );

    if (success) {
      navigator.pop();

      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "ServiceType Added Successful",
      );

      // await getAddButtonServiceType.fetchGetAddButton_ServiceType(companyId);
      await secondGetServiceType.fetch_service_center_service_type(
        ServiceCenterId,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message:
                secondServiceType.errorMessage ?? "Failed to Added ServiceType",
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

  @override
  Widget build(BuildContext context) {
    final getAddButton_serviceType_Provider =
        Provider.of<GetAddButtonServiceType_Provider>(context);
    final secondServiceType =
        Provider.of<add_service_center_service_type_provider>(context);
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
          child: SingleChildScrollView(
            child: Form(
              key: _dialogFormKey,
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
                          widget.selectedServiceCenter?.name != null
                              ? " ${widget.selectedServiceCenter!.name}"
                              : "Add Service Types",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
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
                    const SizedBox(height: 10),

                    // custom dropdown for service center
                    const CustomLabeltext("Service Type"),
                    const SizedBox(height: 8),
                    Consumer<GetAddButtonServiceType_Provider>(
                      builder: (context, serviceTypeProvider, child) {
                        return CustomDropdown<serviceTypeModel>(
                          hinText: "Select ServiceType",
                          items:
                              getAddButton_serviceType_Provider.serviceTypeList,
                          value: _selectedServiceType,
                          selectedItem: _selectedServiceType,
                          onChanged: (serviceTypeModel? newvalue) {
                            debugPrint(
                              "DROPDOWN CHANGED: User selected Service Center ID: ${newvalue?.id}",
                            );
                            setState(() {
                              _selectedServiceType = newvalue;
                              if (newvalue != null) {
                                ServicePriceController.text =
                                    newvalue.price?.toString() ?? '';
                                timeController.text =
                                    newvalue.defaultAllocatedTime?.toString() ??
                                    '';
                              } else {
                                ServicePriceController.clear();
                                timeController.clear();
                              }
                            });
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

                    // custom text field for service price
                    const CustomLabeltext("Service Price", showStar: false),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Price in BDT",
                      controller: ServicePriceController,
                      isPassword: false,
                      enableValidation: true,
                      keyboardType: TextInputType.number,
                      suffixIcon: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text("BDT")),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // custom text field for default allocated time
                    const CustomLabeltext(
                      "Default Allocated Time",
                      showStar: false,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Time in minutes",
                      controller: timeController,
                      isPassword: false,
                      enableValidation: false,
                      suffixIcon: Container(
                        width: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text("Minutes")),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // save and cancel button
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
                          onPressed: _saveAddSecondServiceType,
                          child: secondServiceType.isLoading
                              ? Text(
                                  "Please Wait",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        SizedBox(width: 10),
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
}
