import 'package:flutter/material.dart';

class CustomLabeltext extends StatefulWidget {
  final String label;
  final Color? color;
  final double? fonsize;
  final FontWeight? fontWeight;

  final bool showStar;

  const CustomLabeltext(
    this.label, {
    super.key,
    this.color,
    this.fonsize,
    this.fontWeight,
    this.showStar = true,
  });

  @override
  State<CustomLabeltext> createState() => _CustomLabeltextState();
}

class _CustomLabeltextState extends State<CustomLabeltext> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: TextStyle(
          color: widget.color ?? Colors.black,
          fontSize: widget.fonsize ?? 13,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
        ),
        children: widget.showStar
            ? [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    );
  }
}
