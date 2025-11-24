import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/utils/color.dart';

class CustomFlushbar {
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) async {
    await Flushbar(
      title: title,
      titleColor: AppColor().primariColor,
      icon: Icon(Icons.check_circle, color: AppColor().primariColor),
      message: message,
      messageColor: Colors.black,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      borderRadius: BorderRadius.circular(6),
      borderColor: AppColor().primariColor,
      borderWidth: 1.5,
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: true,
      mainButton: TextButton(
        onPressed: () {
          if (onOkPressed != null) onOkPressed();
        },
        child: Text(
          "OK",
          style: TextStyle(
            color: AppColor().primariColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).show(context);
  }
}
