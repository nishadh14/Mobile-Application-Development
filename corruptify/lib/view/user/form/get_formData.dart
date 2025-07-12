import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/models/form_model.dart';

class GetFormData {
  static List<FormModel> formData = [];

  static Future<void> getFormData() async {
    formData.clear();
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("FormData").get();

    for (var value in response.docs) {
      formData.add(
        FormModel(
            id: value.id,
            name: value['name'],
            description: value['description'],
            location: value['location'],
            contact: value['number'],
            evidanceUrl: value['evidanceurl'],
            email: value['userEmail']),
      );
    }
  }
}
