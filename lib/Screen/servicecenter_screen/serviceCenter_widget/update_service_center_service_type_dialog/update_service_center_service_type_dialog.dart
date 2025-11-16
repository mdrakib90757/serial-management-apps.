import 'package:SerialMan/global_widgets/custom_error_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/service_type_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/update_service_center_service_type_request/update_service_center_service_type_request.dart';
import 'package:SerialMan/utils/color.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/editButtonServiceType_provider/editButtonServiceType_provider.dart';
import '../../../../providers/serviceCenter_provider/editButtonServiceType_provider/getEditButtonServiceType_Provider.dart';
import '../../../../providers/serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';
import '../../../../providers/serviceCenter_provider/update_service_center_service_type_provider/update_service_center_service_type_provider.dart';
import '../../../../request_model/serviceCanter_request/editButtonServiceType_request/editButtonServiceType_reqeust.dart';

class update_servive_center_service_type_dialog extends StatefulWidget {
  final serviceTypeModel serviceType_model;
  final ServiceCenterModel? selectedServiceCenter;

  const update_servive_center_service_type_dialog({
    super.key,
    required this.serviceType_model,
    this.selectedServiceCenter,
  });

  @override
  State<update_servive_center_service_type_dialog> createState() =>
      _update_servive_center_service_type_dialogState();
}

class _update_servive_center_service_type_dialogState
    extends State<update_servive_center_service_type_dialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController timeController = TextEditingController();
  ServiceCenterModel? serviceCenterModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.serviceType_model.name);
    priceController = TextEditingController(
      text: widget.serviceType_model.price.toString(),
    );
    timeController = TextEditingController(
      text: widget.serviceType_model.defaultAllocatedTime.toString(),
    );
    serviceCenterModel = widget.selectedServiceCenter;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    timeController.dispose();
  }

  Future<void> _saveEditServiceType() async {
    if (_dialogFormKey.currentState!.validate()) {
      //error Handel
      final navigator = Navigator.of(context);
      final getAddButton_serviceType_Provider =
          Provider.of<GetAddButtonServiceType_Provider>(context, listen: false);

      final UpdateButton = Provider.of<UpdateServiceCenterServiceTypeProvider>(
        context,
        listen: false,
      );
      final get_addButton =
          Provider.of<get_service_center_service_type_provider>(
            context,
            listen: false,
          );

      final companyId = Provider.of<Getprofileprovider>(
        context,
        listen: false,
      ).profileData?.currentCompany.id;
      if (companyId == null) {
        return;
      }
      final ServiceCenterId = widget.selectedServiceCenter?.id ?? "";

      update_service_center_service_type_request UpdateRequest =
          update_service_center_service_type_request(
            serviceTypeId: widget.serviceType_model.id,
            price: double.parse(priceController.text).round(),
            defaultAllocatedTime: double.parse(timeController.text).round(),
          );

      final success = await UpdateButton.update_service_center_service_typ(
        UpdateRequest,
        ServiceCenterId,
      );
      if (success) {
        navigator.pop();

        await CustomFlushbar.showSuccess(
          context: context,
          title: "Success",
          message: "Edit ServiceType  Update Successful",
        );
        await get_addButton.fetch_service_center_service_type(ServiceCenterId);
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: CustomSnackBarWidget(
        //       title: "Error",
        //       message: "Failed to Edit Service Center Update",
        //       iconColor: Colors.red.shade400,
        //       icon: Icons.dangerous_outlined,
        //     ),
        //     backgroundColor: Colors.transparent,
        //     elevation: 0,
        //     behavior: SnackBarBehavior.floating,
        //     duration: Duration(seconds: 3),
        //   ),
        // );
        showCustomErrorPopup(
          context,
          "Failed to Edit Service Center service Type Update",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UpdateButton = Provider.of<UpdateServiceCenterServiceTypeProvider>(
      context,
    );
    final get_addButton = Provider.of<get_service_center_service_type_provider>(
      context,
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Row(
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
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomLabeltext("Service Type"),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: nameController,
                          hintText: "Service Type",
                          isPassword: false,
                        ),
                        const SizedBox(height: 10),

                        // custom text field for price
                        const CustomLabeltext("Service Price", showStar: false),
                        const SizedBox(height: 8),
                        CustomTextField(
                          hintText: "Price in BDT",
                          controller: priceController,
                          isPassword: false,
                          enableValidation: false,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        // custom text field for time
                        const CustomLabeltext(
                          "Default Allocated Time",
                          showStar: false,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          hintText: "Time in minutes",
                          controller: timeController,
                          isPassword: false,
                          enableValidation: false,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // save button and cancel button
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
                        onPressed: UpdateButton.isLoading
                            ? null
                            : _saveEditServiceType,
                        child: UpdateButton.isLoading
                            ? Text(
                                "Please wait...",
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
