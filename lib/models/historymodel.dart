import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String titleVi;
  final String imageUrl;
  final DateTime time;
  final double confidence;
  final String? reasonVi;

  HistoryModel({
    required this.id,
    required this.titleVi,
    required this.imageUrl,
    required this.time,
    required this.confidence,
    this.reasonVi,
  });

  factory HistoryModel.fromMap(String id, Map<String, dynamic> map) {
    return HistoryModel(
      id: id,
      titleVi: map['titleVi'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      time: (map['time'] as Timestamp).toDate(),
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      reasonVi: map['reasonVi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titleVi': titleVi,
      'imageUrl': imageUrl,
      'time': Timestamp.now(),
      'confidence': confidence,
      'reasonVi': reasonVi,
    };
  }
}
