import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MyTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final String? Function(String?)? validator;
  final String? label, hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconButton? suffixIcon;
  final int? maxLength;
  final bool? enabled;
  final bool? readOnly;
  final double? numBorder;
  final String? errorText;
  final Icon? prefixIcon;
  // final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    super.key,
    required this.obscureText,
    this.onSubmitted,
    this.validator,
    this.label,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    required this.focusNode,
    required this.controller,
    this.suffixIcon,
    this.onChanged,
    this.maxLength,
    this.buildCounter,
    this.enabled,
    this.readOnly,
    this.onTap,
    this.numBorder,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly ?? false,
      enabled: enabled,
      maxLength: maxLength,
      buildCounter: buildCounter,
      onChanged: onChanged,
      focusNode: focusNode,
      cursorColor: AppColors.primaryColor,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      controller: controller,
      onFieldSubmitted: onSubmitted,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      // inputFormatters: inputFormatters,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          );
        }),
        filled: true,
        fillColor: AppColors.tfColor,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(numBorder ?? 12),
        ),
        //default
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(numBorder ?? 12),
          borderSide: BorderSide(color: AppColors.tfColor, width: 1),
        ),
        //border focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(numBorder ?? 12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(numBorder ?? 12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(numBorder ?? 12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
