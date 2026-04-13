import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BtnText extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final String text;
  const BtnText({
    super.key,
    this.onPressed,
    required this.width,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
