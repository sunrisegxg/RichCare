import 'package:flutter/material.dart';

class NotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double top = 0;
    double notchRadius = 40; // độ sâu & rộng notch

    path.moveTo(0, top);

    // đi ngang tới trước notch
    path.lineTo(size.width * 0.3, top);

    // cong vào bên trái notch
    path.cubicTo(
      size.width * 0.35,
      top,
      size.width * 0.35,
      notchRadius,
      size.width * 0.5,
      notchRadius,
    );

    // cong ra bên phải notch
    path.cubicTo(
      size.width * 0.65,
      notchRadius,
      size.width * 0.65,
      top,
      size.width * 0.7,
      top,
    );

    // đi ngang tiếp
    path.lineTo(size.width, top);

    // phần dưới
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
