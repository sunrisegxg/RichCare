import 'package:flutter/material.dart';
import 'package:ricecare/authswitcherscreen.dart';

import 'components/btn_text.dart';
import 'constants/colors.dart';

class CheckMailScreen extends StatefulWidget {
  const CheckMailScreen({super.key});

  @override
  State<CheckMailScreen> createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Image.asset(
                'assets/images/logo.jpg',
                height: 80,
                fit: BoxFit.cover,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Check your email",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text(
                'We have sent a password recovery instruction to your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textNormalColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              BtnText(
                width: double.infinity,
                text: "Back to Login",
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AuthSwitcherScreen()),
                  (route) => false,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
