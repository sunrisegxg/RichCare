import 'package:flutter/material.dart';
import 'package:ricecare/resultsscreen.dart';

class AnalyzingScreen extends StatefulWidget {
  final String imagePath;

  const AnalyzingScreen({super.key, required this.imagePath});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    analyzeImage();
  }

  Future<void> analyzeImage() async {
    // ⏳ giả lập call AI (2-3s)
    await Future.delayed(const Duration(seconds: 3));

    // 👉 sau khi phân tích xong → chuyển sang màn result của bạn
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultsScreen(type: ResultType.scan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "AI is analyzing the rice leaf...",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
