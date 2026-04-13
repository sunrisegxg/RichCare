import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ricecare/test.dart';
import 'loginscreen.dart';

import 'onboardingscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    // thanh trang thai
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // nen trong suot
      statusBarIconBrightness: Brightness.dark, // icon toi
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
