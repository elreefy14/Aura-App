import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  double radiusSize = 20;
  double crvStartHight = 60;
  double cvEndHight = 40;
  final radiusBottom = const Radius.circular(26);
  final radius = const Radius.circular(16);
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.moveTo(radius.x, 0); // Move to top-left corner
    path.arcToPoint(
      Offset(0, radius.y),
      radius: radius,
      clockwise: false,
    );
    path.lineTo(0, size.height - crvStartHight);

    // path.lineTo(radius, size.height - 40);

    path.arcToPoint(
      Offset(20, size.height - cvEndHight),
      radius: radiusBottom,
      clockwise: false,
    );

    path.quadraticBezierTo((size.width - radiusSize) / 2, size.height,
        (size.width - radiusSize), size.height - cvEndHight);
    path.lineTo(size.width - 20, size.height - cvEndHight);
    path.arcToPoint(
      Offset(size.width, size.height - crvStartHight),
      radius: radiusBottom,
      clockwise: false,
    );
    path.lineTo(size.width, size.height - crvStartHight);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, radius.y); // Draw right line
    path.arcToPoint(
      Offset(size.width - radius.x, 0),
      radius: radius,
      clockwise: false,
    );
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
