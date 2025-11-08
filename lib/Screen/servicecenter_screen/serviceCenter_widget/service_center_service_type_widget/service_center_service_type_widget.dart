import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/add_service_center_service_type_dialog/add_service_center_service_type_dialog.dart';
import 'package:SerialMan/Screen/servicecenter_screen/serviceCenter_widget/update_service_center_service_type_dialog/update_service_center_service_type_dialog.dart';
import '../../../../global_widgets/custom_dropdown/custom_dropdown.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';
import '../../../../model/serviceCenter_model.dart';
import '../../../../model/service_type_model.dart';
import '../../../../providers/profile_provider/getprofile_provider.dart';
import '../../../../providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../../../../providers/serviceCenter_provider/delete_device_type_service_typeProvider/delete_service_type_service_type_provider.dart';
import '../../../../providers/serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';
import '../../../../utils/color.dart';

class service_center_service_type_widget extends StatefulWidget {
  const service_center_service_type_widget({super.key});

  @override
  State<service_center_service_type_widget> createState() =>
      _service_center_service_type_widgetState();
}

class _service_center_service_type_widgetState
    extends State<service_center_service_type_widget> {
  serviceTypeModel? _selectedServiceType;
  ServiceCenterModel? _selectedServiceCenter;
  List<ServiceCenterModel> serviceCenterList = [];

  @override
  void initState() {
    super.initState();
    final getProfileProvider = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    );
    final companyId = getProfileProvider.profileData?.currentCompany.id;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final getAddButtonProvider = Provider.of<GetAddButtonProvider>(
        context,
        listen: false,
      );
      await getAddButtonProvider.fetchGetAddButton(companyId!);

      if (!mounted) return;
      if (getAddButtonProvider.serviceCenterList.isNotEmpty) {
        setState(() {
          _selectedServiceCenter = getAddButtonProvider.serviceCenterList.first;
          Provider.of<get_service_center_service_type_provider>(
            context,
            listen: false,
          ).fetch_service_center_service_type(_selectedServiceCenter!.id!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceCenterProvider = Provider.of<GetAddButtonProvider>(context);
    final String? serviceTypeId = _selectedServiceType?.id;
    final secondGetServiceType =
        Provider.of<get_service_center_service_type_provider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Center`s Service Type",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              // dropdown for service center
              Expanded(
                child: Container(
                  height: 40,
                  child: CustomDropdown(
                    hinText: "Please Wait...",
                    selectedItem: _selectedServiceCenter,
                    items: serviceCenterProvider.serviceCenterList,
                    onChanged: (ServiceCenterModel? newValue) {
                      setState(() {
                        _selectedServiceCenter = newValue;
                        if (_selectedServiceCenter != null) {
                          Provider.of<get_service_center_service_type_provider>(
                            context,
                            listen: false,
                          ).fetch_service_center_service_type(
                            _selectedServiceCenter!.id!,
                          );
                        } else {
                          Provider.of<get_service_center_service_type_provider>(
                            context,
                            listen: false,
                          ).clearData();
                        }
                      });
                    },
                    itemAsString: (ServiceCenterModel item) => item.name ?? "",
                  ),
                ),
              ),
              SizedBox(width: 5),

              // Add Button
              GestureDetector(
                onTap: () {
                  // Second ServiceType add Button
                  _SecondShowDialogBox(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor().primariColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 15),
                      SizedBox(width: 5),
                      Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // service type list
          Center(
            child: secondGetServiceType.isLoading
                ? CustomShimmerList(itemCount: 10)
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: secondGetServiceType
                        .serviceTypesOfSelectedCenter
                        .length,
                    itemBuilder: (context, index) {
                      final serviceType = secondGetServiceType
                          .serviceTypesOfSelectedCenter[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${serviceType.name}",
                                style: TextStyle(
                                  color: AppColor().primariColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${serviceType.price} BDT",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showDialogBoxEDIT(
                                            context,
                                            serviceType,
                                          );
                                        },
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: AppColor().scoenddaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              _showDeleteConfirmationMenu(
                                                context,
                                                serviceType,
                                                _selectedServiceCenter!,
                                              );
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color:
                                                    AppColor().scoenddaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "${serviceType.defaultAllocatedTime} Minutes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  //service type add_dialog box
  void _SecondShowDialogBox(BuildContext context) {
    if (_selectedServiceCenter != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return add_service_center_service_type_dialog(
            selectedServiceCenter: _selectedServiceCenter,
          );
        },
      );
    } else {
      // Optionally show a message if no service center is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a Service Center first.")),
      );
    }
  }

  //service type Edit dialogBox
  void _showDialogBoxEDIT(
    BuildContext context,
    serviceTypeModel serviceTypeModel,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return update_servive_center_service_type_dialog(
          serviceType_model: serviceTypeModel,
          selectedServiceCenter: _selectedServiceCenter,
        );
      },
    );
  }

  // service type delete confirmation
  void _showDeleteConfirmationMenu(
    BuildContext menuContext,
    serviceTypeModel typeModel,
    ServiceCenterModel serviceCenterModel,
  ) {
    // menuContext
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final companyId = Provider.of<Getprofileprovider>(
      context,
      listen: false,
    ).profileData?.currentCompany.id;
    final deleteProvider = Provider.of<DeleteServiceTypeServiceTypeProvider>(
      context,
      listen: false,
    );

    final get_addButton = Provider.of<get_service_center_service_type_provider>(
      context,
      listen: false,
    );

    final String ServiceTypeId = typeModel.id;
    final String ServiceCenterId = serviceCenterModel.id;

    showMenu<bool>(
      context: menuContext,
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height * -5, // Top
        offset.dx + size.width, // Right
        offset.dy + size.height, // Bottom
      ),
      items: [
        PopupMenuItem(
          // value: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Confirmation",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Are you sure to delete?",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(menuContext).pop(false);
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(menuContext).pop(true);

                      final success = await deleteProvider
                          .delete_ServiceCenter_serviceType(
                            ServiceCenterId,
                            ServiceTypeId,
                          );
                      if (mounted && success) {
                        await get_addButton.fetch_service_center_service_type(
                          ServiceCenterId,
                        );
                        CustomFlushbar.showSuccess(
                          context: context,
                          message: "User deleted successfully.",
                          title: 'Success',
                        );
                      } else if (mounted) {
                        CustomFlushbar.showSuccess(
                          context: context,
                          message:
                              deleteProvider.errorMessage ??
                              "Failed to delete user.",
                          title: 'Failed',
                        );
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == true) {
        print("Delete confirmed!");
      } else {
        print("Delete canceled.");
      }
    });
  }
}
