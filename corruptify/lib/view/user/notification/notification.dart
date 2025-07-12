import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/user/notification/firebaseNotification.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// class NotificationPage extends StatefulWidget {
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationPage> {
//   final NotificationService _notificationService = NotificationService();

//   final List<Map<String, String>> _staticNotifications = [
//     {'title': 'New Notification', 'message': 'Your report has been approved!'},
//     {
//       'title': 'New Notification',
//       'message': 'Your report has been disapproved!'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: Expanded(
//         child: StreamBuilder<List<Map<String, dynamic>>>(
//           stream: _notificationService.fetchNotifications(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No notifications yet.'));
//             }

//             final notifications = snapshot.data!;
//             return ListView.builder(
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Icon(Icons.notifications_active),
//                   title: Text(notifications[index]['title'] ?? 'No Title'),
//                   subtitle:
//                       Text(notifications[index]['message'] ?? 'No Message'),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<Map<String, String>> _staticNotifications = [
    {'title': 'New Notification', 'message': 'Your report has been approved!'},
    {
      'title': 'New Notification',
      'message': 'Your report has been disapproved!',
    },
  ];
  bool isDark = SessionData.isDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 107, 106, 106)
          : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 4, 4, 4)
            : const Color(0xFF6C63FF),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
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
                        color: isDark
                            ? const Color.fromARGB(255, 30, 30, 30)
                            : const Color.fromARGB(255, 255, 255, 255),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 248, 245, 255)
                                : Color.fromARGB(255, 203, 199, 255),
                            child: isDark
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
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                notifications[index]['message'] ?? 'No Message',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black87,
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
                                  color: isDark ? Colors.white : Colors.black54,
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}     ${dateTime.hour}:${dateTime.minute}';
    }
    return "InvalidTime";
  }
}
