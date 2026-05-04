import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String imageUrl;
  final String title;
  final DateTime time;
  final double confidence;

  HistoryModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.confidence,
  });

  /// 🔹 đọc từ Firestore
  factory HistoryModel.fromMap(String id, Map<String, dynamic> map) {
    return HistoryModel(
      id: id,
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
      time: map['time'] != null
          ? (map['time'] as Timestamp).toDate()
          : DateTime.now(),
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'time': Timestamp.now(),
      'confidence': confidence,
    };
  }
}
