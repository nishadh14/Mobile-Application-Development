import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> saveNotification(String title, String message) async {
    try {
      final User? currentUser = _auth.currentUser;
      await _firestore.collection('notifications').add({
        'userEmail': currentUser!.email,
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
        .collection('notifications')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
