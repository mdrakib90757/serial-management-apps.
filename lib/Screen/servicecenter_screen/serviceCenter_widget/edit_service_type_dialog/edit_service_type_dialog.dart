import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/service_type_model.dart';
import 'package:SerialMan/utils/color.dart';
import '../../../../global_widgets/custom_error_popup.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../providers/serviceCenter_provider/editButtonServiceType_provider/editButtonServiceType_provider.dart';
import '../../../../providers/serviceCenter_provider/editButtonServiceType_provider/getEditButtonServiceType_Provider.dart';
import '../../../../request_model/serviceCanter_request/editButtonServiceType_request/editButtonServiceType_reqeust.dart';

class EditServiceTypeDialog extends StatefulWidget {
  final serviceTypeModel serviceType_model;
  const EditServiceTypeDialog({super.key, required this.serviceType_model});

  @override
  State<EditServiceTypeDialog> createState() => _EditServiceTypeDialogState();
}

class _EditServiceTypeDialogState extends State<EditServiceTypeDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController timeController = TextEditingController();

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
      final editButton = Provider.of<EditButtonServiceTypeProvider>(
        context,
        listen: false,
      );
      final getEditButton = Provider.of<GetEditButtonServiceTypeProvider>(
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

      EditButtonServiceTypeRequest editButtonRequest =
          EditButtonServiceTypeRequest(
            companyId: companyId,
            id: widget.serviceType_model.id,
            name: nameController.text,
            price: priceController.text,
            defaultAllocatedTime: timeController.text,
          );

      final success = await editButton.editButtonServiceType(
        editButtonRequest,
        companyId,
        widget.serviceType_model.id,
      );
      if (success) {
        navigator.pop();

        await CustomFlushbar.showSuccess(
          context: context,
          title: "Success",
          message: "Edit ServiceType  Update Successful",
        );

        if (companyId != null) {
          await getAddButton_serviceType_Provider.fetchGetAddButton_ServiceType(
            companyId,
          );
        }
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
        showCustomErrorPopup(context, "Failed to Edit Service Center Update");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editButton = Provider.of<EditButtonServiceTypeProvider>(context);
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Service Types",
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
                    ),
                    const SizedBox(height: 20),

                    // custom name text field
                    const CustomLabeltext("Name"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: nameController,
                      hintText: "Name",
                      isPassword: false,
                    ),
                    const SizedBox(height: 10),

                    // custom price text field
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

                    // custom time text field
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
                          onPressed: editButton.isLoading
                              ? null
                              : _saveEditServiceType,
                          child: editButton.isLoading
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
