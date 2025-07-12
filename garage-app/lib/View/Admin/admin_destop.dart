import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int totalRequests = 0; // Total requests received today
  int acceptedRequests = 0; // Requests accepted today
  int completedRequests = 0;
  int rejectedRequest = 0; // Completed requests today

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      final response = await http.get(
        Uri.parse('your url'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('problems') &&
            jsonResponse['problems'] != null) {
          List<dynamic> data = jsonResponse['problems'];

          setState(() {
            totalRequests = data.length;
            acceptedRequests =
                data.where((request) => request['status'] == 'Accepted').length;
            completedRequests = data
                .where((request) => request['status'] == 'Completed')
                .length;
            rejectedRequest =
                data.where((request) => request['status'] == 'Rejected').length;
          });
        } else {
          throw Exception(
              "API response does not contain 'problems' or it is null");
        }
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final response = await http.get(
        Uri.parse('your url'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Check if 'data' exists and is not null
      if (jsonResponse.containsKey('problems') &&
          jsonResponse['problems'] != null) {
        List<dynamic> data = jsonResponse['problems'];

        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception("API response does not contain 'data' or it is null");
      }
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<void> updateProblemStatus(
      String problemId, String status, String workerAssign) async {
    final String apiUrl = "your url";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": int.parse(problemId.toString()),
          "status": status,
          "worker_assign": workerAssign,
        }),
      );
      setState(() {});

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData["message"]);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Admin Dashboard",
            style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 15, 12, 12),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary",
                style: GoogleFonts.quicksand(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _dashboardCard(
                        "Total Requests", totalRequests, Colors.blue),
                    _dashboardCard("Accepted Requests",acceptedRequests, Colors.green),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _dashboardCard(
                        "Completed Requests", completedRequests, Colors.purple),
                    _dashboardCard(
                        "Pending Requests",
                        totalRequests - (acceptedRequests + rejectedRequest),
                        Colors.orange),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
            Text("Recent Bookings",
                style: GoogleFonts.quicksand(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(child: _recentBookingsTable()),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, int count, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
        width: 180,
        height: 135,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Text("$count",
                style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _recentBookingsTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No recent bookings available"));
        }

        List<Map<String, dynamic>> bookings = snapshot.data!;

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text("User",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(
                        label: Text("Service",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(
                        label: Text("Status",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(
                        label: Text("Worker Assigned",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    DataColumn(
                        label: Text("Action",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                  ],
                  rows: bookings.map((booking) {
                    Color statusColor = booking["status"] == "Completed"
                        ? Colors.green
                        : booking["status"] == "Accepted"
                            ? Colors.blue
                            : Colors.orange;

                    return DataRow(cells: [
                      DataCell(Text(booking["username"] ?? "",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 70, 68, 68)))),
                      // DataCell(Text(booking["problems"] ?? "",
                      //     overflow: TextOverflow.clip,
                      //     style: GoogleFonts.quicksand(
                      //         fontWeight: FontWeight.bold,
                      //         color: const Color.fromARGB(255, 70, 68, 68)))),
                      DataCell(
                        Container(
                          width:
                              120, // Set a fixed width to prevent horizontal overflow
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (booking["problems"] as String)
                                  .split(
                                      ",") // Split the string by commas to list services
                                  .map((service) => Text(
                                        service.trim(),
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 70, 68, 68)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),

                      DataCell(Text(booking["status"] ?? "",
                          style: GoogleFonts.quicksand(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ))),
                      DataCell(Text(booking["worker_assign"] ?? "N/A",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87))),
                      DataCell(
                        booking["status"] == "Completed"
                            ? ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),
                                child: const Text(
                                  "Completed",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : booking["status"] == "Rejected"
                                ? Text("Rejected",
                                    style: GoogleFonts.quicksand(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ))
                                : booking["status"] == "pending"
                                    ? Text("Pending",
                                        style: GoogleFonts.quicksand(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : ElevatedButton(
                                        onPressed: () {
                                          updateProblemStatus(
                                            booking["id"],
                                            "Completed",
                                            booking["worker_assign"],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text(
                                          "Mark as Completed",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
