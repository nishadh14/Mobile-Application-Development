// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String title;
  final String icon;
  final String description;

  const ServiceDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });
  Future<void> submitProblem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    String? userId = prefs.getString("user_id");

    if (username == null || userId == null) {
      print("User not logged in!");
      return;
    }

    const String apiUrl =
        "http://garage.satishpawale.link/store_problem.php"; // For emulator

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "phone_no": "1234567890",
          "problems": description
        }),
      );

    log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["status"] == "success") {
        print("✅ Service request stored in the database!");
      } else {
        print("❌ Failed to store service request: ${responseData["message"]}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<void> submitProblem() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? username = prefs.getString("username"); // Retrieve username
  //   String? userId = prefs.getString("user_id");

  //   if (username == null || userId == null) {
  //     print("User not logged in!");
  //     return;
  //   }

  //   const String apiUrl = "http://localhost/garageapi/store_problem.php";

  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       "username": username,
  //       "phone_no": "1234567890",
  //       "problems": description
  //     }),
  //   );

  //   final responseData = jsonDecode(response.body);
  //   print(responseData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.quicksand(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers content horizontally
          children: [
            Image.asset(icon, height: 120, width: 120),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.quicksand(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await submitProblem();

                // Show confirmation after successful submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Service request submitted successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Select Service',
                style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white),
              ),
            ),

            // Spacing before button
            // ElevatedButton(
            //   onPressed: () async {
            //     await submitProblem();

            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text('$title selected!')),
            //     );
            //   },

            //   // style: ElevatedButton.styleFrom(
            //   //   backgroundColor: Colors.black,
            //   //   padding:
            //   //       const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            //   //   shape: RoundedRectangleBorder(
            //   //     borderRadius: BorderRadius.circular(10),
            //   //   ),
            //   // ),
            //   child: Text(
            //     'Select Service',
            //     style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
