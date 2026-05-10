import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:readmore/readmore.dart';
import 'package:ricecare/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/colors.dart';
import 'models/guidemodel.dart';
import 'models/predictionresultmode.dart';

enum ResultType { scan, history, guide }

class ResultsScreen extends StatefulWidget {
  final ResultType type;
  final GuideModel? guide;
  final PredictionResult? result;

  const ResultsScreen({super.key, required this.type, this.guide, this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  GuideModel? get guide => widget.guide;
  PredictionResult? get result => widget.result;

  bool get isGuide => widget.type == ResultType.guide;
  bool get isScan => widget.type == ResultType.scan;
  bool get isHistory => widget.type == ResultType.history;

  String cleanValue(String? value) {
    if (value == null) return "";
    return value.split("(").first.trim();
  }

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

  @override
  Widget build(BuildContext context) {
    final isVietnamese = context.locale.languageCode == "vi";

    final title = isGuide
        ? (guide?.title ?? "")
        : (isVietnamese
              ? (result?.classVi ?? "Không xác định")
              : (result?.classEn ?? "Unknown Disease"));

    final description = isGuide
        ? (guide?.definition ?? "")
        : "rice_blast_description".tr();

    final symptomsList = isGuide
        ? (guide?.symtomz ?? "")
              .split("\n")
              .where((e) => e.trim().isNotEmpty)
              .toList()
        : ["symptom_lesions".tr(), "symptom_leaves_dry".tr()];

    final cause = isGuide ? (guide?.cause ?? "") : "cause_description".tr();

    final recommendation = isGuide
        ? (guide?.measurement ?? "")
        : "rec_default".tr();

    final severity = isGuide ? cleanValue(guide?.severity) : "Medium";
    final spreadRisk = isGuide ? cleanValue(guide?.speadrisk) : "High";
    final humidity = isGuide ? (guide?.humidity ?? "") : "High";
    final hasReason = (result?.reason?.trim().isNotEmpty ?? false);
    // final isSuccess = result?.success ?? false;
    // if (!isSuccess && isScan) {
    //   return Scaffold(body: Center(child: Text("Analyze failed")));
    // }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          isScan
              ? SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.memory(
                    base64Decode(result!.originalImage!),
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/paddy1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // 🔥 SCAN / HISTORY HEADER (THÊM LẠI)
                      if (isScan || isHistory)
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Color(0xFFE8F5E9),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isHistory
                                  ? "analysis_result".tr()
                                  : "hurray_identified".tr(),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: isHistory
                                ? 1
                                : isScan
                                ? 7
                                : 0,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          if (isScan || isHistory) ...[
                            const SizedBox(width: 10),

                            Expanded(
                              flex: isHistory ? 1 : 3,
                              child: Text(
                                isHistory
                                    ? "${"saved_result_on".tr()} 12/08/2024"
                                    : "scanned_result".tr(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),

                      if (isScan)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: hasReason
                              ? Column(
                                  children: [
                                    Text(
                                      "unable_to_identify".tr(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      result!.reason!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: infoBox(
                                        "confidence".tr(),
                                        "${((result?.confidence ?? 0)).toStringAsFixed(1)}%",
                                        Colors.green,
                                        Icons.verified_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      else ...[
                        sectionTitle("description".tr()),
                        ReadMoreText(
                          description,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'read_more'.tr(),
                          trimExpandedText: 'show_less'.tr(),
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),

                        const SizedBox(height: 16),

                        sectionTitle("symptoms".tr()),
                        Text(symptomsList.join("\n")),

                        const SizedBox(height: 16),

                        sectionTitle("cause".tr()),
                        Text(cause),

                        const SizedBox(height: 16),

                        sectionTitle("recommendation".tr()),
                        Text(recommendation),

                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: infoBox(
                                "severity".tr(),
                                severity,
                                Colors.orange,
                                Icons.local_fire_department,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: infoBox(
                                "spread_risk".tr(),
                                spreadRisk,
                                Colors.red,
                                Icons.warning_amber_rounded,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: infoBox(
                                "humidity".tr(),
                                humidity,
                                Colors.blue,
                                Icons.water_drop_rounded,
                              ),
                            ),
                            if (isScan || isHistory) ...[
                              SizedBox(width: 10),
                              Expanded(
                                child: infoBox(
                                  "confidence".tr(),
                                  "${((result?.confidence ?? 0) * 100).toStringAsFixed(1)}%",
                                  Colors.green,
                                  Icons.verified_rounded,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
                      if (isScan || isHistory)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  isHistory
                                      ? showNotification()
                                      : Navigator.pop(context);
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
                                          : "save_result".tr(),
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

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
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
        const SizedBox(width: 10),
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
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
