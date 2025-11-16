import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/model/serialService_model.dart';
import 'package:SerialMan/request_model/serviceCanter_request/status_UpdateButtonRequest/status_updateButtonRequest.dart';
import 'package:SerialMan/utils/color.dart';

import '../../../../global_widgets/custom_textfield.dart';
import '../../../../providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../../../../providers/serviceCenter_provider/statusButtonProvider/get_status_updateButtonButton_provider.dart';
import '../../../../providers/serviceCenter_provider/statusButtonProvider/status_UpdateButton_provider.dart';

class ManageSerialDialog extends StatefulWidget {
  final String? date;
  final SerialModel serialDetails;
  final bool isFromNextButton;
  const ManageSerialDialog({
    Key? key,
    this.date,
    required this.serialDetails,
    this.isFromNextButton = false,
  }) : super(key: key);

  @override
  _ManageSerialDialogState createState() => _ManageSerialDialogState();
}

class _ManageSerialDialogState extends State<ManageSerialDialog> {
  final List<String> _statuses = [
    'Booked',
    'Present',
    'Waiting',
    'Serving',
    'Served',
    'Cancelled',
    'Absent',
  ];

  late String _selectedStatus;
  final _commentController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final details = widget.serialDetails;
    final String currentStatus = details.status?.toLowerCase() ?? 'booked';
    // if (currentStatus == 'serving') {
    //   _selectedStatus = 'Served';
    // } else {
    //   _selectedStatus = details.status ?? 'Booked';
    // }
    // _selectedStatus = details.status ?? 'Booked';

    if (widget.isFromNextButton && currentStatus == 'serving') {
      _selectedStatus = 'Served';
    } else {
      _selectedStatus = details.status ?? 'Booked';
    }

    final defaultPrice = details.serviceType?.price?.toString() ?? '0.0';
    _amountController.text = defaultPrice;

    _commentController.text = details.comment ?? '';
  }

  @override
  void dispose() {
    _commentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<GetNewSerialButtonProvider>(
      context,
      listen: false,
    );
    final serialProvider =
        statusProvider.servedSerials + statusProvider.servedSerials;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Serial:- ${widget.serialDetails?.serialNo} - ${widget.serialDetails?.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //overflow: TextOverflow.ellipsis,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 18,
            ),
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' Serial Status',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Wrap(
                spacing: 5.0,
                // runSpacing: 5.0,
                children: _statuses.map((status) {
                  bool isSelected = _selectedStatus == status;
                  return FilterChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColor().primariColor,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedStatus == 'Served') ...[
                const Text("Collected Amount (BDT)"),
                const SizedBox(height: 8),
                CustomTextField(
                  //keyboardType: TextInputType.number,
                  readOnly: false,
                  controller: _amountController,
                  hintText: _amountController.text,
                  textStyle: TextStyle(color: Colors.black),
                  isPassword: false,
                  keyboardType: TextInputType.number,
                  suffixIcon: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text("BDT")),
                  ),
                ),
              ],
              SizedBox(height: 8),
              const Text(
                'Comment',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentController,
                maxLines: 2,
                cursorColor: Colors.grey.shade500,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColor().primariColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      actions: [
        // update button
        ElevatedButton(
          onPressed: _isUpdating
              ? null
              : () async {
                  setState(() {
                    _isUpdating = true;
                  });

                  try {
                    final statusProvider =
                        Provider.of<statusUpdateButton_provder>(
                          context,
                          listen: false,
                        );

                    final getProvider = Provider.of<getStatusUpdate_Provider>(
                      context,
                      listen: false,
                    );

                    final messenger = ScaffoldMessenger.of(context);

                    final status = _selectedStatus;
                    final comment = _commentController.text;
                    double? collectedAmount;
                    if (status == 'Served') {
                      collectedAmount =
                          double.tryParse(_amountController.text) ?? 0.0;
                    }

                    final String serviceId = widget.serialDetails.id!;
                    final String serviceCenterId =
                        widget.serialDetails.serviceCenterId!;

                    final bool isPresent = [
                      'Present',
                      'Serving',
                      'Served',
                    ].contains(status);

                    StatusButtonRequest requestData = StatusButtonRequest(
                      isPresent: isPresent,
                      status: status,
                      comment: comment.isNotEmpty ? comment : null,
                      serviceCenterId: serviceCenterId,
                      serviceId: serviceId,
                      charge: collectedAmount,
                    );

                    final navigator = Navigator.of(context);
                    final success = await statusProvider.updateStatus(
                      requestData,
                      serviceCenterId,
                      serviceId,
                    );

                    if (!mounted) return;

                    if (success) {
                      await getProvider.fetchStatusButton(
                        serviceCenterId,
                        widget.date,
                      );

                      navigator.pop(true);
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isUpdating = false;
                      });
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor().primariColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isUpdating
              ? Text('Please wait...', style: TextStyle(color: Colors.white))
              : Text('Update', style: TextStyle(color: Colors.white)),
        ),

        // cancel button
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(color: Colors.grey.shade400),
            //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Cancel'),
        ),
      ],
      // actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
    );
  }
}
