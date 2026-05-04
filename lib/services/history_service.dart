import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/historymodel.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Lưu history theo user
  Future<void> addHistory(String userId, HistoryModel history) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .add(history.toMap());
  }

  /// 🔹 Lấy history theo user
  Stream<List<HistoryModel>> getHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => HistoryModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Future<List<HistoryModel>> getHistoryOnce(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('history')
        .get();

    return snapshot.docs
        .map((doc) => HistoryModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// 🔹 Xoá history
  Future<void> deleteHistory(String userId, String historyId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .doc(historyId)
        .delete();
  }
}
