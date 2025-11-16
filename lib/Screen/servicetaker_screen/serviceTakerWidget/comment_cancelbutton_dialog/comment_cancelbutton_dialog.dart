import 'package:SerialMan/global_widgets/custom_error_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:SerialMan/request_model/seviceTaker_request/commentCancel_request/commentCancel_request.dart';
import '../../../../global_widgets/custom_flushbar.dart';
import '../../../../global_widgets/custom_sanckbar.dart';
import '../../../../model/mybooked_model.dart';
import '../../../../providers/serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../../../../providers/serviceTaker_provider/commentCancelProvider/commentCancelButton_provider.dart';
import '../../../../utils/color.dart';

class CommentCancelButtonDialog extends StatefulWidget {
  final MybookedModel bookingDetails;
  const CommentCancelButtonDialog({super.key, required this.bookingDetails});

  @override
  State<CommentCancelButtonDialog> createState() =>
      _CommentCancelButtonDialogState();
}

class _CommentCancelButtonDialogState extends State<CommentCancelButtonDialog> {
  final TextEditingController _commentController = TextEditingController();
  MybookedModel? mybook_Serial;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mybook_Serial = widget.bookingDetails;
  }

  // Cancel comment button
  Future<void> _CancelComment() async {
    final commentProvider = Provider.of<CommentCancelButtonProvider>(
      context,
      listen: false,
    );
    final String comment = _commentController.text;
    if (comment.isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: CustomSnackBarWidget(
      //       title: "Error",
      //       message: "Please enter a reason to cancel.",
      //     ),
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );
      showCustomErrorPopup(context, "Please enter a reason to cancel.");
      return;
    }

    if (mybook_Serial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomSnackBarWidget(
            title: "Error",
            message: " Booking details not found.",
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String? serviceTypeId = mybook_Serial?.serviceType?.id;
    final String? bookingId = mybook_Serial?.id;
    final String? serviceCenterId = mybook_Serial?.serviceCenter?.id;

    CommentCancelRequest commentCancelRequest = CommentCancelRequest(
      id: bookingId,
      serviceCenterId: serviceCenterId,
      serviceTypeId: serviceTypeId,
      comment: comment,
      status: "Cancelled",
    );

    final success = await commentProvider.commentCancelButton(
      commentCancelRequest,
      bookingId!,
      serviceCenterId!,
    );

    if (success) {
      if (!mounted) return;
      final String serviceDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
      await Provider.of<GetBookSerialProvider>(
        context,
        listen: false,
      ).fetchgetBookSerial(serviceDate);

      Navigator.pop(context);

      await CustomFlushbar.showSuccess(
        context: context,
        title: "Success",
        message: "Serial cancelled  successfully!",
      );
    } else {
      Navigator.pop(context);
      showCustomErrorPopup(
        context,
        commentProvider.errorMessage ?? "Booking Failed",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentCancelButtonProvider>(context);

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cancel Serial",
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
                  const SizedBox(height: 20),

                  //
                  Text(
                    "Please enter the reason or comment",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 3,
                    cursorColor: Colors.grey.shade300,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: AppColor().primariColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Reason or comment",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // save and Cancel button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          backgroundColor: AppColor().primariColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(5),
                          ),
                        ),
                        onPressed: commentProvider.isLoading
                            ? null
                            : () async {
                                await _CancelComment();
                              },
                        child: commentProvider.isLoading
                            ? Text(
                                "Please wait...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                "Cancel Serial",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
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
