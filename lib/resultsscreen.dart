import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:readmore/readmore.dart';
import 'package:ricecare/constants/colors.dart';

import 'models/guidemodel.dart';

enum ResultType { scan, history, guide }

class ResultsScreen extends StatefulWidget {
  final ResultType type;
  final GuideModel? guide;

  const ResultsScreen({super.key, required this.type, this.guide});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  GuideModel? get guide => widget.guide;

  bool get isGuide => widget.type == ResultType.guide;
  bool get isScan => widget.type == ResultType.scan;
  bool get isHistory => widget.type == ResultType.history;

  String cleanValue(String? value) {
    if (value == null) return "";
    return value.split("(").first.trim();
  }

  @override
  Widget build(BuildContext context) {
    // ===== DATA FROM API (guide mode) =====
    final title = isGuide ? (guide?.title ?? "") : "Rice Blast";

    final description = isGuide
        ? (guide?.definition ?? "")
        : "rice_blast_description".tr();

    // split symptoms theo dòng từ API
    final symptomsList = isGuide
        ? (guide?.symtomz ?? "")
              .split("\n")
              .where((e) => e.trim().isNotEmpty)
              .toList()
        : ["symptom_lesions".tr(), "symptom_leaves_dry".tr()];

    final cause = isGuide ? (guide?.cause ?? "") : "cause_description".tr();

    // 👉 recommendation lấy từ measurement (theo yêu cầu của bạn)
    final recommendation = isGuide
        ? (guide?.measurement ?? "")
        : "rec_default".tr();

    final severity = isGuide ? cleanValue(guide?.severity) : "Medium";
    final spreadRisk = isGuide ? cleanValue(guide?.speadrisk) : "High";
    final humidity = isGuide ? (guide?.humidity ?? "") : "High";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // IMAGE HEADER
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset("assets/images/paddy1.jpg", fit: BoxFit.cover),
          ),

          // CLOSE BUTTON
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

          // CONTENT SHEET
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
                      // DRAG HANDLE
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

                      // TITLE
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // DESCRIPTION
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

                      // SYMPTOMS (NO BULLET)
                      sectionTitle("symptoms".tr()),
                      Text(
                        symptomsList.join("\n"),
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),

                      const SizedBox(height: 16),

                      // CAUSE
                      sectionTitle("cause".tr()),
                      Text(cause),

                      const SizedBox(height: 16),

                      // RECOMMENDATION (measurement)
                      sectionTitle("recommendation".tr()),
                      Text(
                        recommendation,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),

                      const SizedBox(height: 20),
                      const Divider(),

                      const SizedBox(height: 10),

                      // INFO BOXES
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
                        ],
                      ),

                      const SizedBox(height: 20),
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

  // ===== UI HELPERS =====

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
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 quan trọng
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

        Expanded(
          // 👈 quan trọng nhất
          child: Column(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
