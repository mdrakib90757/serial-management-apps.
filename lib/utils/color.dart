import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor {
  final Color primariColor = Color(0xFF316984);
  final Color scoenddaryColor = Color(0xFFE17C1F);
  final Color backgroundColor = Color(0xFFF5F5F5);

  static Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'serving':
        return Colors.blue;
      case 'served':
        return Colors.green;
      case 'cancelled':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      case 'booked':
      case 'waiting':
      case 'present':
      default:
        return Colors.black;
    }
  }
}
