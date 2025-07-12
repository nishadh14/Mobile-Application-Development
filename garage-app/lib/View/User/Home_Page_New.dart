// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:garage_app/View/User/Account_Screeen.dart';
import 'package:garage_app/View/User/Genral_Services_Screen.dart';
import 'package:garage_app/View/User/service_tracking.dart';
import 'package:garage_app/View/User/Specific_Services_Screen.dart';
import 'package:garage_app/View/User/user_booking.dart';
import 'package:garage_app/View/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // To handle JSON

class GarageServiceScreen extends StatefulWidget {
  const GarageServiceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GarageServiceScreenState createState() => _GarageServiceScreenState();
}

class _GarageServiceScreenState extends State<GarageServiceScreen> {
  bool showTextField = false;
  TextEditingController problemController = TextEditingController();
  List<String> userProblems = [];

  void _addProblem() {
    if (problemController.text.isNotEmpty) {
      setState(() {
        userProblems.add(problemController.text);
        problemController.clear();
      });
    }
  }

  void _removeProblem(int index) {
    setState(() {
      userProblems.removeAt(index);
    });
  }

  void _submitProblems() async {
    if (userProblems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please add at least one problem before submitting!')),
      );
    } else {
      try {
        const String apiUrl =
            "http://garage.satishpawale.link/store_problem.php"; // Replace with your actual URL
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? username = prefs.getString("username");
        int? phone_no = prefs.getInt("phone_no");
        String problemsString = userProblems.join(', ');

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "username": username, // Replace with real username
            "phone_no": phone_no, // Replace with real phone number
            "problems": problemsString, // Pass the list of problems
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData["status"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData["message"])),
            );

            setState(() {
              userProblems.clear(); // Clear the list after submission
              showTextField = false; // Collapse the TextField section
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${responseData["message"]}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Server Error: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to connect to server: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Service'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text("Select The Services",
                  style: TextStyle(
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: [
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: _buildSquareButton(Icons.build, 'General Service', () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const SpecificServicesScreen();
                    }));
                  }),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: _buildSquareButton(
                      Icons.car_repair, 'Specific Service', () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const GenralServicesScreen();
                    }));
                  }),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 500),
                  child:
                      _buildSquareButton(Icons.more_horiz, 'Add Problems', () {
                    setState(() {
                      showTextField = !showTextField;
                    });
                  }),
                ),
              ],
            ),
            if (showTextField) ...[
              const SizedBox(height: 20),
              FadeIn(
                duration: const Duration(milliseconds: 500),
                child: TextField(
                  controller: problemController,
                  decoration: InputDecoration(
                    hintText: 'Describe your problem',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 10),
              FadeInRight(
                delay: const Duration(milliseconds: 600),
                child:
                    _buildSquareButton(Icons.add, 'Add to List', _addProblem),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: userProblems.length,
                  itemBuilder: (context, index) {
                    return FadeInLeft(
                      duration: const Duration(milliseconds: 500),
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.report_problem,
                              color: Colors.red),
                          title: Text(
                            userProblems[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.black),
                            onPressed: () => _removeProblem(index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child:
                    _buildSquareButton(Icons.send, 'Continue', _submitProblems),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome, User",
                  style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
              icon: Icons.book_online,
              text: "Booking",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookingScreen()),
                );
              }),
          _buildDrawerItem(
              icon: Icons.track_changes,
              text: "Tracking",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ServiceTrackingScreen()),
                );
              }),
          _buildDrawerItem(
              icon: Icons.account_circle,
              text: "Account",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              }),
          const Divider(),
          _buildDrawerItem(
              icon: Icons.logout,
              text: "Logout",
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const SignInScreen();
                }));
              }),
        ],
      ),
    );
  }

  // 🔹 Drawer Item Builder
  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(text,
          style:
              GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  Widget _buildSquareButton(
      IconData icon, String text, VoidCallback onPressed) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          padding: const EdgeInsets.all(10),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 40),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
