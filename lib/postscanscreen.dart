import 'dart:io';
import 'package:flutter/material.dart';

import 'analyzingscreen.dart';

class PostScanScreen extends StatelessWidget {
  final String imagePath;
  final bool isFront;

  const PostScanScreen({
    super.key,
    required this.imagePath,
    required this.isFront,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 📷 IMAGE
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: isFront
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                      child: Image.file(File(imagePath)),
                    )
                  : Image.file(File(imagePath)),
            ),
          ),

          /// 🌑 LIGHT OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.08)),
          ),

          SafeArea(
            child: Stack(
              children: [
                /// 🔙 BACK BUTTON
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 40,
                  right: 20,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AnalyzingScreen(imagePath: imagePath),
                          ),
                        );
                      },
                      child: const Text(
                        "Analyze",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
