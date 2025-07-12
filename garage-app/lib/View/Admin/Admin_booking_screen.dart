import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminBookingScreenState createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  List<dynamic> bookings = [];

  List<Map<String, dynamic>> workers = [];

  bool isLoading = false;
  // "John Doe",
  // "Emily Clark",
  // "Michael Smith",
  // "Alice Johnson"

  @override
  void initState() {
    super.initState();
    fetchWorkers();
    fetchBookings(); // Fetch workers when the screen loads
    setState(() => isLoading = false);
  }

  Future<void> updateProblemStatus(
      int problemId, String status, String workerAssign) async {
    final String apiUrl = "your url";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": problemId,
          "status": status,
          "worker_assign": workerAssign,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData["message"]);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('your url'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('problems') &&
            jsonResponse['problems'] != null) {
          setState(() {
            bookings = jsonResponse['problems'];
            isLoading = false;
          });
        } else {
          throw Exception(
              "API response does not contain 'problems' or it is null");
        }
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchWorkers() async {
    const String apiUrl = "your url";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          workers = data.map((worker) {
            return {
              "name": worker["name"],
            };
          }).toList();
        });
      } else {
        throw Exception("Failed to load workers");
      }
    } catch (error) {
      log("Error fetching workers: $error");
    }
  }

  void updateBookingStatus(
      int index, dynamic problemId, String status, String workerAssign) async {
    final String apiUrl = "your url";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": int.parse(problemId.toString()), // Ensure it's an integer
          "status": status,
          "worker_assign": workerAssign,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData["status"] == "success") {
          setState(() {
            bookings[index]["status"] = status;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Booking ${status.toUpperCase()}")),
          );
        } else {
          print("API Error: ${responseData["message"]}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void showWorkerSelectionModal(int bookingIndex) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Worker",
                  style: GoogleFonts.quicksand(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(workers[index]["name"],
                        style: GoogleFonts.quicksand(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      setState(() {
                        bookings[bookingIndex]["worker_assign"] =
                            workers[index]["name"];
                      });
                      updateBookingStatus(index, bookings[index]['id'],
                          "Accepted", bookings[index]['worker_assign']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Bookings",
            style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 15, 12, 12),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isLoading
              ? const Center(child: Text("No bookings available"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("User: ${bookings[index]['username']}",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  "User Phone No: ${bookings[index]['phone_no']}",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("Service: ${bookings[index]['problems']}",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey[700])),
                              const SizedBox(height: 10),
                              if (bookings[index].containsKey("worker_assign"))
                                Text(
                                  "Assigned Worker: ${bookings[index]['worker_assign']}",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              if (bookings[index]['status'] == "Accepted")
                                Text(
                                  "Accepted",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                )
                              else if (bookings[index]['status'] == "Rejected")
                                Text(
                                  "Rejected",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showWorkerSelectionModal(index);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 45, vertical: 12),
                                      ),
                                      child: Text("Accept",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white)),
                                    ),
                                    const SizedBox(width: 50),
                                    ElevatedButton(
                                      onPressed: () => updateBookingStatus(
                                          index,
                                          bookings[index]['id'],
                                          "Rejected",
                                          "no"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 45, vertical: 12),
                                      ),
                                      child: Text("Reject",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
