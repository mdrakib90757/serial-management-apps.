import 'package:SerialMan/model/serviceCenter_model.dart';
import 'package:SerialMan/providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';

import 'package:SerialMan/utils/color.dart';
import 'package:SerialMan/utils/date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../global_widgets/custom_shimmer_list/CustomShimmerList .dart';

class ServiceTakerQueueServedDialog extends StatefulWidget {
  final String serviceCenterId;
  final String serviceCenterName;
  const ServiceTakerQueueServedDialog({
    super.key,
    required this.serviceCenterId,
    required this.serviceCenterName,
  });

  @override
  State<ServiceTakerQueueServedDialog> createState() =>
      _ServiceTakerQueueServedDialogState();
}

class _ServiceTakerQueueServedDialogState
    extends State<ServiceTakerQueueServedDialog>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  //TabBar List
  final List<String> tabList = ["Queue", "Served "];
  DateTime _selectedDate = DateTime.now();
  ServiceCenterModel? _selectedServiceCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serialProvider = context.read<GetNewSerialButtonProvider>();
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      serialProvider.fetchSerialsButton(widget.serviceCenterId, today);
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serialProvider = context.watch<GetNewSerialButtonProvider>();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.serviceCenterName,
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

                  // queue abd served tab bar
                  TabBar(
                    controller: tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelColor: AppColor().primariColor,
                    labelStyle: TextStyle(fontWeight: FontWeight.w500),
                    indicatorColor: AppColor().primariColor,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((
                      Set<MaterialState> states,
                    ) {
                      return Colors.transparent;
                    }),
                    tabs: [
                      Tab(
                        child: Text(
                          "Queue${serialProvider.totalQueueCount > 0 ? '(${serialProvider.totalQueueCount})' : ''}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),

                        //text: "Queue(${serialProvider.totalQueueCount})"
                      ),
                      Tab(
                        child: Text(
                          "Served${serialProvider.totalServedCount > 0 ? '(${serialProvider.totalServedCount})' : ''}",
                          //"Served(${serialProvider.totalServedCount})",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),

                        //text: "Served(${serialProvider.totalServedCount})"
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      controller: tabController,
                      children: [_buildQueueList(), _buildServedList()],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ok button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppColor().primariColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Ok"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //queue build Widget
  Widget _buildQueueList() {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;

    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return CustomShimmerList(itemCount: 10);
        }
        final queueList = serialProvider.queueSerials;
        if (queueList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12),
                Text(
                  'No items in the queue',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: queueList.length,
          itemBuilder: (context, index) {
            final serial = queueList[index];

            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            final bool canBeEdited = serial.status?.toLowerCase() != 'serving';
            return Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  serial.name ?? "N/A",
                                  style: TextStyle(
                                    color: AppColor().primariColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // if (isToday && canBeEdited) ...[
                                //   GestureDetector(
                                //     onTap: () {
                                //       showDialog(
                                //         context: context,
                                //         builder: (context) {
                                //           return QueueListEditDialog(
                                //             serviceCenterModel:
                                //                 _selectedServiceCenter!,
                                //             serialToEdit: serial,
                                //           );
                                //         },
                                //       );
                                //     },
                                //     child: Icon(
                                //       Icons.edit,
                                //       size: 18,
                                //       color: AppColor().primariColor,
                                //     ),
                                //   ),
                                // ],
                              ],
                            ),
                            GestureDetector(
                              onTap: isToday
                                  ? () async {
                                      //_showDialogBoxManage(serial);
                                    }
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(statusTime, style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Text(serial.serviceType!.name.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // served build widget
  Widget _buildServedList() {
    final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String selectedDateString = DateFormat(
      'yyyy-MM-dd',
    ).format(_selectedDate);
    final bool isToday = todayString == selectedDateString;
    return Consumer<GetNewSerialButtonProvider>(
      builder: (context, serialProvider, child) {
        if (serialProvider.isLoading) {
          return Center(child: CustomShimmerList(itemCount: 10));
        }
        final servedList = serialProvider.servedSerials;

        if (servedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  'No items have been served yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: servedList.length + 1,
          itemBuilder: (context, index) {
            if (index == servedList.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ${serialProvider.totalServedCount} Person(s)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " ${serialProvider.totalServedAmount.toStringAsFixed(2)}BDT",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }
            final serial = servedList[index];
            // S/L Time
            final String slTime = DateFormatter.formatForStatusTime(
              serial.createdTime,
            );
            // Status Time
            final String statusTime = DateFormatter.formatForStatusTime(
              serial.statusTime,
            );

            return Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "${serial.serialNo}.",
                      style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade500,
                    radius: 22,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              serial.name ?? "N/A",
                              style: TextStyle(
                                color: AppColor().primariColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: isToday
                                  ? () async {
                                      // _showDialogBoxManage(serial);
                                    }
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    serial.status.toString(),
                                    style: TextStyle(
                                      color: AppColor.getStatusColor(
                                        serial.status,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(slTime),
                            Text(
                              statusTime,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(serial.serviceType!.name.toString()),
                            Text("${serial.charge!.toString()} BDT"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
