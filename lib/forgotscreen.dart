import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ricecare/checkmailscreen.dart';

import 'components/btn_text.dart';
import 'components/textfield_type.dart';
import 'constants/colors.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode1 = FocusNode();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _focusNode1.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
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
                    "Forgot password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  'Enter your email address and we will send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textNormalColor,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email address*",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                MyTextField(
                  obscureText: false,
                  numBorder: 8,
                  focusNode: _focusNode1,
                  controller: _emailController,
                  hintText: "example@gmail.com",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) => FocusScope.of(context).unfocus(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    //  else if (!InputValidation().isEmailValid(value)) {
                    //   return 'Invalid email';
                    // }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                BtnText(
                  width: double.infinity,
                  text: "Send",
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CheckMailScreen()),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Spacer(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Remember your password? ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textNormalColor,
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).pop(),
                        text: "Sign in",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
