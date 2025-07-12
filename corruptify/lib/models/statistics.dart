import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference statisticsCollection =
      FirebaseFirestore.instance.collection('statistics');

  Future<void> updateField(String field, int value) async {
    try {
      await statisticsCollection.doc('reports').update({
        field: FieldValue.increment(value),
      });
    } catch (e) {
      print('Error updating $field: $e');
    }
  }
}
