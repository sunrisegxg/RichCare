import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BtnNext extends StatelessWidget {
  final VoidCallback? onPressed;
  const BtnNext({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
