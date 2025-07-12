import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNotification(String title, String message) async {
    try {
      await _firestore.collection('AdminNotifications').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error saving notification: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchNotifications(String userEmail) {
    return _firestore
        .collection('AdminNotifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
