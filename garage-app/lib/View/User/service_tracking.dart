import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ServiceTrackingScreen extends StatefulWidget {
  const ServiceTrackingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceTrackingScreenState createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen> {
  List<String> statuses = [
    "Requested ",
    "Requested Accepted",
    "Mechanic Assigned",
    "Service in Progress",
    "Service Completed"
  ];

  int currentStatus = 0;

  void updateStatus() {
    if (currentStatus < statuses.length - 1) {
      setState(() {
        currentStatus++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Tracking",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Live Service Status",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElasticIn(
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 255, 148, 82),
                child: Icon(
                  Icons.build,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              statuses[currentStatus],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (currentStatus + 1) / statuses.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 148, 82)),
              minHeight: 10,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                currentStatus == statuses.length - 1
                    ? "Service Completed"
                    : "Update Status",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
