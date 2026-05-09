import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ricecare/constants/colors.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F0),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        'change_language'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Vietnamese
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('vi'));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBF8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: context.locale.languageCode == 'vi'
                            ? Border.all(
                                color: AppColors.primaryColor,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              '🇻🇳',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tiếng Việt',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.locale.languageCode == 'vi'
                                        ? AppColors.primaryColor
                                        : Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Vietnamese',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (context.locale.languageCode == 'vi')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // English
                  GestureDetector(
                    onTap: () {
                      context.setLocale(const Locale('en'));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBF8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: context.locale.languageCode == 'en'
                            ? Border.all(
                                color: AppColors.primaryColor,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              '🇺🇸',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.locale.languageCode == 'en'
                                        ? AppColors.primaryColor
                                        : Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (context.locale.languageCode == 'en')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor,
                              size: 28,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
