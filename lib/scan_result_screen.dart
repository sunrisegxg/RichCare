import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';

import '../../constants/colors.dart';
import '../../models/predictionresultmode.dart';
import 'components/info_box.dart';
import 'models/historymodel.dart';
import 'services/cloudinary_service.dart';
import 'services/history_service.dart';
import 'services/token_service.dart';

class ScanResultScreen extends StatelessWidget {
  final PredictionResult result;

  const ScanResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isVietnamese = context.locale.languageCode == "vi";

    final title = isVietnamese
        ? (result.classVi ?? "Không xác định")
        : (result.classEn ?? "Unknown Disease");

    final hasReason = (result.reason?.trim().isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Stack(
        children: [
          /// IMAGE
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.memory(
              base64Decode(result.originalImage!),
              fit: BoxFit.cover,
            ),
          ),

          /// CLOSE BUTTON
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

          /// CONTENT
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
                      /// DRAG HANDLE
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

                      /// HEADER
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: hasReason
                                ? const Color(0xFFFFEBEE)
                                : const Color(0xFFE8F5E9),

                            child: Icon(
                              hasReason ? Icons.close : Icons.check,
                              size: 14,
                              color: hasReason ? Colors.red : Colors.green,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            hasReason
                                ? "unable_to_identify".tr()
                                : "hurray_identified".tr(),

                            style: TextStyle(
                              color: hasReason ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// TITLE + SCANNED RESULT
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            flex: 3,
                            child: Text(
                              "scanned_result".tr(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// RESULT CARD
                      Container(
                        width: double.infinity,
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

                                  FutureBuilder<String>(
                                    future: context.locale.languageCode == "en"
                                        ? GoogleTranslator()
                                              .translate(
                                                result.reason!,
                                                to: "en",
                                              )
                                              .then((value) => value.text)
                                        : Future.value(result.reason!),

                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data ?? "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: InfoBox(
                                      title: "confidence".tr(),
                                      value:
                                          "${(result.confidence ?? 0).toStringAsFixed(1)}%",
                                      color: Colors.green,
                                      icon: Icons.verified_rounded,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 20),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,

                                side: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),

                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              child: Text(
                                "re_scan".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.btnbgrColor,
                                foregroundColor: Colors.white,

                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              onPressed: () async {
                                final userId = await TokenService.getUserId();

                                if (userId == null) return;

                                /// upload cloudinary
                                final imageUrl =
                                    await CloudinaryService.uploadImage(
                                      result.originalImage!,
                                    );
                                const uuid = Uuid();

                                /// tạo history
                                final history = HistoryModel(
                                  id: uuid.v4(),
                                  imageUrl: imageUrl,
                                  titleVi: result.classVi ?? "Không xác định",
                                  time: DateTime.now(),
                                  confidence: result.confidence ?? 0,
                                  reasonVi: result.reason,
                                );

                                /// lưu firestore
                                await HistoryService().addHistory(
                                  userId,
                                  history,
                                );
                                if (!context.mounted) return;

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("saved_success".tr())),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.bookmark_add_outlined,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "save_result".tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
}
