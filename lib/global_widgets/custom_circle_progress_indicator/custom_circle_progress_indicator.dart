import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final double size; // Loader size
  final double strokeWidth; // Loader thickness
  final Color? color; // Loader color

  const CustomLoading({
    Key? key,
    this.size = 40,
    this.strokeWidth = 4,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).primaryColor;

    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
      ),
    );
  }
}
