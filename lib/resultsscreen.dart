import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:readmore/readmore.dart';
import 'package:ricecare/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

enum ResultType { scan, history, guide }

class ResultsScreen extends StatefulWidget {
  final ResultType type;
  const ResultsScreen({super.key, required this.type});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isScan = widget.type == ResultType.scan;
    bool isHistory = widget.type == ResultType.history;
    bool isGuide = widget.type == ResultType.guide;
    Future<void> showNotification() async {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('notification_enabled') ?? false;

      if (!enabled) {
        print("Notification đang bị tắt");
        return; // ❌ không gửi
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'channel_id',
            'Reminder',
            importance: Importance.max,
            priority: Priority.high,
          );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id: 0,
        title: 'Xin chào 👋',
        body: 'Đây là Local Notification đầu tiên của bạn!',
        notificationDetails: details,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 🔹 Image top
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset("assets/images/paddy1.jpg", fit: BoxFit.cover),
          ),

          // 🔹 Close button
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          // 🔹 Content
          DraggableScrollableSheet(
            initialChildSize: 0.65, // 👈 lúc đầu
            minChildSize: 0.65, // 👈 kéo xuống
            maxChildSize: 1, // 👈 kéo lên full
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController, // 👈 QUAN TRỌNG
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 drag indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // content giữ nguyên
                      if (isScan || isHistory)
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.tfColor,
                              minRadius: 12,
                              child: Icon(
                                Icons.check,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              isHistory
                                  ? "analysis_result".tr()
                                  : "hurray_identified".tr(),
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rice Blast",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isGuide || isHistory)
                            Text(
                              isGuide
                                  ? "15 Jun 2026"
                                  : "Scanned on 15 Jun 2026",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        children: [
                          chip("rice_disease".tr()),
                          chip("fungal_infection".tr()),
                          chip("common_disease".tr()),
                        ],
                      ),

                      SizedBox(height: 16),

                      sectionTitle("description".tr()),
                      ReadMoreText(
                        "rice_blast_description".tr(),
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'read_more'.tr(),
                        trimExpandedText: 'show_less'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        moreStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        lessStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 16),

                      sectionTitle("symptoms".tr()),
                      bullet("symptom_lesions".tr()),
                      bullet("symptom_leaves_dry".tr()),

                      SizedBox(height: 16),

                      sectionTitle("cause".tr()),
                      Text("cause_description".tr()),

                      SizedBox(height: 16),

                      sectionTitle("recommendation".tr()),
                      bullet("rec_reduce_density".tr()),
                      bullet("rec_use_fungicide".tr()),
                      bullet("rec_improve_drainage".tr()),

                      SizedBox(height: 20),

                      Divider(),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: infoBox(
                              "severity".tr(),
                              "Medium",
                              Colors.orange,
                              Icons.local_fire_department,
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: infoBox(
                              "spread_risk".tr(),
                              "High",
                              Colors.red,
                              Icons.warning_amber_rounded,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: infoBox(
                              "confidence".tr(),
                              "92%",
                              Colors.green,
                              Icons.verified_rounded,
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: infoBox(
                              "humidity".tr(),
                              "High",
                              Colors.blue,
                              Icons.water_drop_rounded,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      if (isScan || isHistory)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  showNotification();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isHistory
                                      ? Colors.red
                                      : AppColors.primaryColor,
                                  side: BorderSide(
                                    color: isHistory
                                        ? Colors.red
                                        : AppColors.primaryColor,
                                    width: 2,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  isHistory ? "delete".tr() : "re_scan".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.btnbgrColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isHistory
                                          ? Icons.share_outlined
                                          : Icons.bookmark_add_outlined,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      isHistory
                                          ? "share_result".tr()
                                          : "save_this_plant".tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 reusable widgets

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textChoiceColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text("• $text"),
    );
  }

  Widget infoBox(String title, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
