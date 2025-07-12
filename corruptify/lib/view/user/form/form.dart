import 'dart:developer';
import 'dart:io';

import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/models/form_model.dart';
import 'package:corruptify/models/statistics.dart';
import 'package:corruptify/view/user/success_notify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:corruptify/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/view/user/form/get_formData.dart';
import 'package:image_picker/image_picker.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State createState() => ReportFormState();
}

class ReportFormState extends State {
  bool hideIdentity = false;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController contact = TextEditingController();
  String? submitButton;
  Map<int, String> approvalStatus = {};

  XFile? _selectedFile;
  bool iswait = false;
  double pending = 0;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool isDark = SessionData.isDark;

  final ImagePicker _imagePicker = ImagePicker();
  final List<Map<String, String>> NotificationList = [
    {'title': 'New Notification', 'message': 'You recieved a new Report'},
  ];

  Future<void> saveNotification(String title, String message) async {
    try {
      await FirebaseFirestore.instance.collection('AdminNotifications').add({
        "userEmail": _currentUser!.email,
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log("Error saving notification: $e");
    }
  }

  void submitComplaint() {
    setState(() {
      approvalStatus = "Submitted" as Map<int, String>;
    });
  }

  void addDataToFireBase({String? url}) async {
    if (description.text.trim().isNotEmpty &&
        location.text.trim().isNotEmpty &&
        contact.text.trim().isNotEmpty) {
      Map<String, dynamic> data = {
        "name": name.text.trim(),
        "description": description.text.trim(),
        "location": location.text.trim(),
        "number": contact.text.trim(),
        "approvalStatus": "Submitted",
        "evidanceurl": url,
        'userEmail': FirebaseAuth.instance.currentUser?.email,
      };
      await FirebaseFirestore.instance.collection("FormData").add(data);
      name.clear();
      description.clear();
      contact.clear();
      location.clear();
    }
  }

  // Future<void> getFormData() async {
  //   formData.clear();
  //   QuerySnapshot response =
  //       await FirebaseFirestore.instance.collection("FormData").get();

  //   for (var value in response.docs) {
  //     formData.add(
  //       FormModel(
  //         name: value['name'],
  //         description: value['description'],
  //         location: value['location'],
  //         contact: value['contact'],
  //       ),
  //     );
  //   }
  // }

  Future<void> uploadImage({required String filename}) async {
    await FirebaseStorage.instance
        .ref()
        .child(filename)
        .putFile(File(_selectedFile!.path));
  }

  Future<String> downloadImage({required String fileName}) async {
    String url =
        await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();

    return url;
  }

  void submitCase(int index) {
    saveNotification(
      NotificationList[0]['title']!,
      NotificationList[0]['message']!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 107, 106, 106)
          : const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: const Text(
          "Report an Issue",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 4, 4, 4)
            : const Color(0xFF6C63FF),
        centerTitle: true,
      ),
      body: iswait
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Voice Your Concern",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Your Name ",
                          labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                          filled: true,
                          fillColor: isDark
                              ? const Color.fromARGB(255, 18, 18, 18)
                                  .withOpacity(0.5)
                              : const Color.fromARGB(255, 60, 59, 59)
                                  .withOpacity(0.15),
                          prefixIcon: isDark
                              ? const Icon(Icons.person, color: Colors.white)
                              : const Icon(Icons.person, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: description,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Description of the Issue",
                          labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                          filled: true,
                          fillColor: isDark
                              ? const Color.fromARGB(255, 18, 18, 18)
                                  .withOpacity(0.5)
                              : const Color.fromARGB(255, 60, 59, 59)
                                  .withOpacity(0.15),
                          prefixIcon: isDark
                              ? const Icon(Icons.description,
                                  color: Colors.white)
                              : const Icon(Icons.description,
                                  color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: location,
                        decoration: InputDecoration(
                          labelText: "Location",
                          labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                          filled: true,
                          fillColor: isDark
                              ? const Color.fromARGB(255, 18, 18, 18)
                                  .withOpacity(0.5)
                              : const Color.fromARGB(255, 60, 59, 59)
                                  .withOpacity(0.15),
                          prefixIcon: isDark
                              ? const Icon(Icons.location_on,
                                  color: Colors.white)
                              : const Icon(Icons.location_on,
                                  color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: contact,
                        decoration: InputDecoration(
                          labelText: "Contact Information (Email or Phone)",
                          labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                          filled: true,
                          fillColor: isDark
                              ? const Color.fromARGB(255, 18, 18, 18)
                                  .withOpacity(0.5)
                              : const Color.fromARGB(255, 60, 59, 59)
                                  .withOpacity(0.15),
                          prefixIcon: isDark
                              ? const Icon(Icons.location_on,
                                  color: Colors.white)
                              : const Icon(Icons.contact_page,
                                  color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          _selectedFile = await _imagePicker.pickImage(
                              source: ImageSource.gallery);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color.fromARGB(255, 18, 18, 18)
                                    .withOpacity(0.5)
                                : const Color.fromARGB(255, 60, 59, 59)
                                    .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: isDark ? Colors.black : Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  color: isDark ? Colors.white : Colors.black),
                              SizedBox(width: 10),
                              Text(
                                "Add Evidence",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: hideIdentity,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           hideIdentity = value ?? false;
                      //         });
                      //       },
                      //       activeColor: Colors.deepPurpleAccent,
                      //     ),
                      //     const Text(
                      //       "Hide My Identity",
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (name.text.trim().isNotEmpty &&
                                location.text.trim().isNotEmpty &&
                                description.text.trim().isNotEmpty &&
                                contact.text.trim().isNotEmpty &&
                                _selectedFile!.name.isNotEmpty) {
                              await FirestoreService()
                                  .updateField('pending', 1);
                              pending = pending + 1.0;
                              SessionData.storeSessionData(pending: pending);
                              SessionData.getSessionData();
                              iswait = true;
                              setState(() {});
                              String fileName = _selectedFile!.name +
                                  DateTime.now().toString();

                              await uploadImage(filename: fileName);
                              String url =
                                  await downloadImage(fileName: fileName);

                              addDataToFireBase(url: url);

                              // await GetFormData.getFormData();
                              submitCase(0);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SuccessPage(),
                                  ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 18, 18, 18)
                                    .withOpacity(0.5)
                                : const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "SUBMIT REPORT",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
