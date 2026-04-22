import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plannernote.dart';

class PlannerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Lưu note theo user
  Future<void> addNote(String userId, PlannerNote note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toMap());
  }

  /// 🔹 Lấy note theo user
  Stream<List<PlannerNote>> getNotes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PlannerNote.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
}
