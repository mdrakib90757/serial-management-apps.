import 'package:flutter/cupertino.dart';

class ClipPathClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    path.lineTo(0, height - 50); // Start the curve slightly higher
    path.quadraticBezierTo(
      width * 0.5,
      height, // Control point to make the curve dip down
      width,
      height - 50, // End the curve slightly higher
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
