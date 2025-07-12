import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../models/form_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  void initState() {
    super.initState();
    _fetchAssignedOfficerData();
  }

  bool isDark = SessionData.isDark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 107, 106, 106)
          : const Color.fromARGB(255, 255, 252, 252),
      appBar: AppBar(
        title: const Text(
          "Track Report",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: isDark ? Colors.black : const Color(0xFF6C63FF),
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: _formList.length,
          itemBuilder: (context, index) {
            final form = _formList[index];
            return Column(children: [
              _buildReportCard(index, form),
              const SizedBox(height: 20),
            ]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchAssignedOfficerData();
          setState(() {});
        },
        backgroundColor:
            isDark ? Color.fromARGB(255, 92, 92, 93) : const Color(0xFF6C63FF),
        child: isDark
            ? const Icon(Icons.replay_outlined, color: Colors.white)
            : const Icon(Icons.replay_outlined),
      ),
    );
  }

  List<FormModel> _formList = [];

// Import FirebaseAuth

  Future<void> _fetchAssignedOfficerData() async {
    try {
      // Get the currently logged-in user's email
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String? userEmail = currentUser?.email;

      if (userEmail == null) {
        print("No user logged in");
        return;
      }

      // Fetch data from Firestore with a filter for the current user's email
      QuerySnapshot<Map<String, dynamic>> response =
          await FirebaseFirestore.instance
              .collection("FormData")
              .where("userEmail", isEqualTo: userEmail) // Filter by user email
              .get();

      List<FormModel> loadedForms = response.docs.map((doc) {
        final data = doc.data();
        return FormModel(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          description: data['description'] ?? 'No description',
          location: data['location'] ?? 'No location',
          contact: data['number'] ?? 'No contact',
          evidanceUrl: data['evidanceurl'] ?? '',
          assignedOfficer: data['assignedOfficer'],
          approvalStatus: data['approvalStatus'],
        );
      }).toList();

      setState(() {
        _formList = loadedForms;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {});
    }
  }

  Widget _buildDrawerHeader() {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(width: 50),
            SizedBox(
              height: 40,
              width: 40,
              child: Image.network(
                  "https://cdn-icons-gif.flaticon.com/11186/11186833.gif"),
            ),
            const Text(
              " Menu",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconUrl, VoidCallback onTap) {
    return Card(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Image.network(
              iconUrl,
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(int index, FormModel form) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 30, 30, 30) : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color.fromARGB(255, 150, 148, 148).withOpacity(0.4)
                : const Color.fromARGB(255, 63, 62, 62).withOpacity(0.4),
            blurRadius: 5,
            spreadRadius: 3,
            offset: const Offset(3, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(form),
          const SizedBox(height: 16),
          const Divider(),
          _buildInvestigationDetails(index, form),
          const Divider(),
          (form.approvalStatus == "Disapproved")
              ? const Text(
                  "Report Disapproved",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red),
                )
              : _buildTimeline(form),
        ],
      ),
    );
  }

  Widget _buildTimeline(FormModel form) {
    final List<Map<String, dynamic>> steps = [
      {"title": "Submitted", "color": Colors.green, "state": false},
      {"title": "Under Review", "color": Colors.orange, "state": false},
      {"title": "Investigation Started", "color": Colors.blue, "state": false},
      {"title": "Completed", "color": Colors.greenAccent, "state": false},
    ];

    for (int i = 0; i < steps.length; i++) {
      if (form.approvalStatus == "Resolved") {
        steps[i]["state"] = true;
      } else if (form.approvalStatus == "Investigation Started" && i <= 2) {
        steps[i]["state"] = true;
      } else if (form.approvalStatus == "Submitted" && i <= 1) {
        steps[i]["state"] = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress Timeline",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return _buildTimelineTile(
                steps[index]["title"],
                steps[index]["color"],
                steps[index]["state"],
                index == steps.length - 1,
              );
            }),
      ],
    );
  }

  Widget _buildTimelineTile(
      String title, Color color, bool isCompleted, bool isLast) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 20,
        color: isCompleted ? Colors.white : Colors.grey,
        indicator: isCompleted
            ? isDark
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : const Icon(Icons.check,
                    size: 16, color: Color.fromARGB(255, 0, 0, 0))
            : null,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted ? color : Colors.grey[300]!,
        thickness: 3,
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted ? color : Colors.grey[300]!,
        thickness: 3,
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 5000),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isCompleted
                ? isDark
                    ? Colors.white
                    : Colors.black87
                : isDark
                    ? const Color.fromARGB(255, 169, 158, 158)
                    : Colors.grey,
          ),
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildHeader(FormModel form) {
    return Text(
      "Report Status",
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87),
    );
  }

  Widget _buildInvestigationDetails(int index, FormModel form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Investigation Details",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 10),
        Text(
          "Description:",
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        Text(
          " ${(form.description)}",
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        const SizedBox(height: 10),
        Text(
          "Investigating Officer: ${(form.assignedOfficer != null) ? form.assignedOfficer : "Not Assigned"}",
          style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
