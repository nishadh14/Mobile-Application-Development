import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/admin/admin_home_Screen.dart';
import 'package:corruptify/view/admin/admin_notifications/firebaseAdminNotification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<AdminNotificationPage> {
  final NotificationService _notificationService = NotificationService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool isdark = SessionData.isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isdark
          ? const Color.fromARGB(255, 84, 84, 84)
          : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: isdark
            ? const Color.fromARGB(255, 0, 0, 0)
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isdark
                ? [
                    const Color.fromARGB(255, 52, 51, 53),
                    const Color.fromARGB(255, 142, 141, 144)
                  ]
                : [Colors.deepPurple.shade100, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: (_currentUser != null)
            ? StreamBuilder<List<Map<String, dynamic>>>(
                stream: _notificationService
                    .fetchNotifications(_currentUser.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notifications yet.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  final notifications = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: isdark
                            ? const Color.fromARGB(255, 30, 30, 30)
                            : const Color.fromARGB(255, 255, 255, 255),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isdark
                                ? const Color.fromARGB(255, 248, 245, 255)
                                : Color.fromARGB(255, 203, 199, 255),
                            child: isdark
                                ? const Icon(
                                    Icons.notifications_active,
                                    color: Color.fromARGB(255, 12, 12, 12),
                                  )
                                : const Icon(
                                    Icons.notifications_active,
                                    color: Color.fromARGB(255, 108, 99, 255),
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notifications[index]['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isdark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                notifications[index]['message'] ?? 'No Message',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isdark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                notifications[index]['timestamp'] != null
                                    ? _formatTimestamp(
                                        notifications[index]['timestamp'])
                                    : 'No Time Provided',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isdark ? Colors.white : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : const Center(
                child: Text(
                  'User not logged in.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
  }

  String _formatTimestamp(dynamic time) {
    if (time is Timestamp) {
      final DateTime dateTime = time.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}    ${dateTime.hour}:${dateTime.minute}';
    }
    return 'Invalid Time';
  }
}
