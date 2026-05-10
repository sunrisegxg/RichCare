import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/historymodel.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Lưu history theo user
  Future<void> addHistory(String userId, HistoryModel history) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .add(history.toMap());
    } catch (e) {
      throw Exception("Add history failed: $e");
    }
  }

  /// 🔹 Lấy history realtime
  Stream<List<HistoryModel>> getHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return HistoryModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  /// 🔹 Lấy history 1 lần
  Future<List<HistoryModel>> getHistoryOnce(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .orderBy('time', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return HistoryModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      throw Exception("Get history failed: $e");
    }
  }

  /// 🔹 Xoá history
  Future<void> deleteHistory(String userId, String historyId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(historyId)
          .delete();
    } catch (e) {
      throw Exception("Delete history failed: $e");
    }
  }
}
