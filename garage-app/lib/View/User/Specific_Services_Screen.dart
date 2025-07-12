// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SpecificServicesScreen extends StatefulWidget {
  const SpecificServicesScreen({super.key});

  @override
  State<SpecificServicesScreen> createState() => _SpecificServicesScreenState();
}

class _SpecificServicesScreenState extends State<SpecificServicesScreen> {
  final List<Map<String, dynamic>> services = [
    {'title': 'Engine & Mechanical', 'icon': 'assets/car-engine.png'},
    {'title': 'Oil Change', 'icon': 'assets/engine-oil.png'},
    {'title': 'Engine Repair', 'icon': 'assets/technician.png'},
    {'title': 'Brake & Suspension', 'icon': 'assets/disc-brake.png'},
    {'title': 'Gearbox & Driveline', 'icon': 'assets/gearbox.png'},
    {'title': 'Electrical & Battery', 'icon': 'assets/car-battery.png'},
    {'title': 'AC & Heating', 'icon': 'assets/air-conditioner.png'},
    {'title': 'Tire & Wheel Service', 'icon': 'assets/tires.png'},
  ];

  List<int> selectedServiceIndices = []; // Track selected services

  // Method to send data to the backend
  Future<void> sendSelectedServicesToBackend(
      String username, String phoneNo, List<String> selectedServices) async {
    const String apiUrl =
        'your url';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'phone_no': phoneNo,
          'problems': selectedServices.join(", "),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add problems')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending data to backend: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Specific Services',
          style: GoogleFonts.quicksand(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount:
                    services.length, // Add "this." to clarify the context

                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedServiceIndices.contains(index)) {
                          selectedServiceIndices.remove(index);
                        } else {
                          selectedServiceIndices.add(index);
                        }
                      });
                    },
                    child: Card(
                      color: selectedServiceIndices.contains(index)
                          ? Colors.lightBlue.shade100
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(services[index]['icon'],
                              height: 50), // Add "this."
                          const SizedBox(height: 10),
                          Text(
                            services[index]['title'], // Add "this."
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedServiceIndices.isNotEmpty
                  ? () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? username = prefs.getString("username");
                      int? phone_no = prefs.getInt("phone_no");

                      List<String> selectedServices = selectedServiceIndices
                          .map((index) => services[index]['title'] as String)
                          .toList();

                      sendSelectedServicesToBackend(
                          username!, phone_no.toString(), selectedServices);
                    }
                  : null, // Disable button if nothing selected
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedServiceIndices.isNotEmpty
                    ? Colors.black
                    : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Submit Services',
                style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
