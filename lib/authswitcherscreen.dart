import 'package:flutter/material.dart';
import 'package:ricecare/loginscreen.dart';

import 'registerscreen.dart';

class AuthSwitcherScreen extends StatefulWidget {
  const AuthSwitcherScreen({super.key});

  @override
  State<AuthSwitcherScreen> createState() => _AuthSwitcherScreenState();
}

class _AuthSwitcherScreenState extends State<AuthSwitcherScreen> {
  bool isLoginScreen = true;
  void toggleScreen() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoginScreen
        ? LoginScreen(showRegisterPage: toggleScreen)
        : RegisterScreen(showLoginPage: toggleScreen);
  }
}
