import 'package:flutter/material.dart';



class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [
    {"title": "Service Reminder", "message": "Car A needs servicing today!", "isRead": false},
    {"title": "Payment Confirmation", "message": "Payment for Car B has been received.", "isRead": true},
    {"title": "New Booking", "message": "A new service booking for Car C.", "isRead": false},
  ];

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
              title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
      ),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Dismissible(
            key: Key(notification["title"]),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(
                  notification["isRead"] ? Icons.notifications_none : Icons.notifications_active,
                  color: notification["isRead"] ? Colors.grey : Colors.blueAccent,
                ),
                title: Text(notification["title"], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(notification["message"]),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    notifications[index]["isRead"] = true;
                  });
                  _showPopup(notification["title"], notification["message"]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}





