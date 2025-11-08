import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/providers/profile_provider/getprofile_provider.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_labeltext.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../global_widgets/custom_textfield.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';
import '../../../../utils/color.dart';

class AddServiceTypeDialog extends StatefulWidget {
  const AddServiceTypeDialog({super.key});

  @override
  State<AddServiceTypeDialog> createState() => _AddServiceTypeDialogState();
}

class _AddServiceTypeDialogState extends State<AddServiceTypeDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    timeController.dispose();
  }

  // save serviceType first Option
  Future<void> _saveAddServiceType() async {
    if (!_dialogFormKey.currentState!.validate()) return;
    final getProfileProvider = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    );
    final companyId = getProfileProvider.profileData?.currentCompany.id;
    final getAddButtonServiceType =
        Provider.of<GetAddButtonServiceType_Provider>(context, listen: false);
    final addButtonServiceType = Provider.of<AddButtonServiceTypeProvider>(
      context,
      listen: false,
    );
    final navigator = Navigator.of(context);
    if (companyId == null) {
      // Show error
      return;
    }

    AddButtonServiceTypeRequest serviceTypeRequest =
        AddButtonServiceTypeRequest(
          name: nameController.text,
          price: priceController.text,
          defaultAllocatedTime: timeController.text,
          companyId: companyId,
        );

    final success = await addButtonServiceType.addButtonServiceType(
      serviceTypeRequest,
      companyId,
    );

    if (success) {
      navigator.pop();

      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "ServiceType Added Successful",
      );

      await getAddButtonServiceType.fetchGetAddButton_ServiceType(companyId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message:
                addButtonServiceType.errorMessage ??
                "Failed to Added ServiceType",
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
    final addButtonServiceType = Provider.of<AddButtonServiceTypeProvider>(
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
                          "Add Service Types",
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

                    // service type name text field
                    const CustomLabeltext("Service Types Name"),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: nameController,
                      hintText: "Service Types Name",
                      isPassword: false,
                    ),
                    const SizedBox(height: 10),

                    // service price text field
                    const CustomLabeltext("Service Price", showStar: false),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Price in BDT",
                      controller: priceController,
                      isPassword: false,
                      enableValidation: false,
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

                    // default allocated time text field
                    CustomLabeltext("Default Allocated Time", showStar: false),
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
                          onPressed: _saveAddServiceType,
                          child: addButtonServiceType.isLoading
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
