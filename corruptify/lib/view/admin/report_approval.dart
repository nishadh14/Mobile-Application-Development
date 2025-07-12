import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:corruptify/models/form_model.dart';
import 'package:corruptify/models/statistics.dart';
import 'package:corruptify/models/officer_model.dart';
import 'package:corruptify/view/admin/admin_home_screen.dart';
import 'package:corruptify/view/user/form/get_formData.dart';

class ReportApprovalPage extends StatelessWidget {
  const ReportApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;
  bool isDark = SessionData.isDark;
  List<FormModel> formdataList = [];
  List<Officer_Model> officers = [];
  String? selectedOfficer;
  Map<String, String> approvalStatus = {};
  final List<Map<String, String>> _staticNotifications = [
    {'title': 'Approval', 'message': 'Your report has been approved!'},
    {'title': 'Disapproval', 'message': 'Your report has been disapproved.'},
    {'title': 'Resolved', 'message': 'Your case has been resolved.'},
  ];
  double pending = SessionData.pending!;
  double resolved = SessionData.resolved!;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchOfficers();
    fetchApprovalStatus();
  }

  Future<void> fetchData() async {
    await GetFormData.getFormData();
    setState(() {
      formdataList = GetFormData.formData;
      isLoading = false;
    });
  }

  Future<void> saveNotification(
      String title, String message, String userName) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        "userEmail": userName,
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log("Error saving notification: $e");
    }
  }

  Future<void> fetchOfficers() async {
    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection('Officers').get();
      setState(() {
        officers = response.docs
            .map((doc) => Officer_Model(
                  officer_name: doc['name'],
                  rank: doc['rank'],
                  id: doc['id'],
                ))
            .toList();
      });
    } catch (e) {
      log("Error fetching officers: $e");
    }
  }

  Future<void> fetchApprovalStatus() async {
    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection('FormData').get();
      setState(() {
        for (var doc in response.docs) {
          approvalStatus[doc.id] = doc['approvalStatus'] ?? "Submitted";
        }
      });
    } catch (e) {
      log("Error fetching approval status: $e");
    }
  }

  void updateStatus(String docId, String status) async {
    setState(() {
      approvalStatus[docId] = status;
    });

    await FirebaseFirestore.instance.collection('FormData').doc(docId).update({
      'approvalStatus': status,
      if (status == "Investigation Started") 'assignedOfficer': selectedOfficer,
    });
  }

  void showAssignOfficerDialog(FormModel complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Assign Officer"),
              content: officers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      value: selectedOfficer,
                      items: officers.map((officer) {
                        return DropdownMenuItem(
                          value: officer.officer_name,
                          child:
                              Text('${officer.officer_name} (${officer.rank})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOfficer = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Officer",
                        border: OutlineInputBorder(),
                      ),
                    ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: isDark
                        ? const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text(
                            'Cancel',
                            style: TextStyle(
                                color: Color.fromARGB(255, 243, 243, 243)),
                          )),
                ElevatedButton(
                  onPressed: () {
                    if (selectedOfficer != null) {
                      updateStatus(complaint.id, "Investigation Started");
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select an officer')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color.fromARGB(255, 64, 61, 65)
                        : const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEvidenceDialog(String? evidence) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("View Evidence"),
          content: evidence == null
              ? const Text('No evidence provided.')
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    Image.network(
                      evidence,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const SizedBox.shrink();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Failed to load image.');
                      },
                    ),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 49, 48, 48)
          : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 18, 18, 18)
            : const Color(0xFF6C63FF),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AdminFirstPage()));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: formdataList.length,
              itemBuilder: (context, index) {
                var complaint = formdataList[index];
                String? status = approvalStatus[complaint.id];

                return Padding(
                  padding: const EdgeInsets.all(8.5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: isDark ? 9 : 17,
                    shadowColor: isDark
                        ? const Color.fromARGB(255, 240, 238, 238)
                            .withOpacity(0.8)
                        : Colors.black.withOpacity(0.8),
                    child: Container(
                      decoration: isDark
                          ? BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 57, 56, 57),
                                  Color.fromARGB(255, 14, 14, 14)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            )
                          : BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 227, 227, 250),
                                  Color.fromARGB(255, 220, 203, 246)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isDark
                              ? const Text(
                                  'Name: ',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 247, 243, 249),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )
                              : const Text(
                                  'Name:',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                          isDark
                              ? Text(
                                  '${complaint.name}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 247, 243, 249),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              : Text(
                                  ' ${complaint.name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                          const SizedBox(height: 5),
                          Divider(
                            color: isDark ? Colors.white : Colors.white,
                          ),
                          isDark
                              ? const Text('Description:',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 247, 243, 249)))
                              : const Text('Description:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                          isDark
                              ? Text('${complaint.description}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color:
                                          Color.fromARGB(255, 247, 243, 249)))
                              : Text('${complaint.description}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                          const SizedBox(height: 5),
                          Divider(
                            color: isDark ? Colors.white : Colors.white,
                          ),
                          isDark
                              ? const Text('Location:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 247, 243, 249),
                                  ))
                              : const Text('Location:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                          isDark
                              ? Text('${complaint.location}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 247, 243, 249),
                                  ))
                              : Text('${complaint.location}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                          const SizedBox(height: 5),
                          Divider(
                            color: isDark ? Colors.white : Colors.white,
                          ),
                          isDark
                              ? const Text('Contact:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 247, 243, 249)))
                              : const Text('Contact:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                          isDark
                              ? Text('${complaint.contact}',
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 247, 243, 249)))
                              : Text('${complaint.contact}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  )),
                          const SizedBox(height: 14),
                          Divider(
                            color: isDark ? Colors.white : Colors.white,
                          ),
                          Text(
                            status ?? "Submitted",
                            style: TextStyle(
                              color: status == "Resolved"
                                  ? Colors.green
                                  : status == "Disapproved"
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                showEvidenceDialog(complaint.evidanceUrl),
                            child: const Text(
                              'View Evidence',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          const SizedBox(height: 15),
                          if (status == "Submitted")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    saveNotification(
                                        "${_staticNotifications[0]['title']}",
                                        "${_staticNotifications[0]['message']}",
                                        complaint.email!);
                                    showAssignOfficerDialog(complaint);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    backgroundColor: isDark
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Color(0xFF6C63FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: isDark
                                      ? const Text(
                                          'Approve',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : const Text(
                                          'Approve',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirestoreService()
                                        .updateField('pending', -1);
                                    await FirestoreService()
                                        .updateField('resolved', 1);

                                    saveNotification(
                                        "${_staticNotifications[1]['title']}",
                                        "${_staticNotifications[1]['message']}",
                                        complaint.email!);
                                    updateStatus(complaint.id, "Disapproved");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    backgroundColor: isDark
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Color(0xFF6C63FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: isDark
                                      ? const Text('Disapprove',
                                          style: TextStyle(color: Colors.white))
                                      : const Text(
                                          'Disapprove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ],
                            )
                          else if (status == "Investigation Started")
                            ElevatedButton(
                              onPressed: () async {
                                await FirestoreService()
                                    .updateField('pending', -1);
                                await FirestoreService()
                                    .updateField('resolved', 1);

                                saveNotification(
                                    "${_staticNotifications[2]['title']}",
                                    "${_staticNotifications[2]['message']}",
                                    complaint.email!);
                                updateStatus(complaint.id, "Resolved");
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                backgroundColor: Color(0xFF6C63FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Resolve',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
