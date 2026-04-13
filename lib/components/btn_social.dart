import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BtnSocial extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onPressed;
  const BtnSocial({
    super.key,
    required this.text,
    required this.imagePath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: AppColors.primaryBtnColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24, width: 24),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
