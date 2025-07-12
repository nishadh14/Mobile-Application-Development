// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:garage_app/View/User/Service_Detail_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

class GenralServicesScreen extends StatefulWidget {
  const GenralServicesScreen({super.key});

  @override
  State<GenralServicesScreen> createState() => _GenralServicesScreenState();
}

class _GenralServicesScreenState extends State<GenralServicesScreen> {
  final List<Map<String, dynamic>> services = const [
    {
      'title': 'Exterior Services',
      'icon': 'assets/exterior.png',
      'description': 'Car wash, waxing, paint protection.'
    },
    {
      'title': 'Interior Services',
      'icon': 'assets/interior.png',
      'description': 'Deep cleaning, upholstery care, and odor removal.'
    },
    {
      'title': 'Car Modification',
      'icon': 'assets/modification.png',
      'description': 'Custom body kits, spoilers, and performance upgrades.'
    },
    {
      'title': 'Detailing Services',
      'icon': 'assets/detailing.png',
      'description': 'Complete detailing for a showroom finish.'
    },
    {
      'title': 'Paint & Wrap',
      'icon': 'assets/paint.png',
      'description': 'Custom paint jobs and vehicle wraps.'
    },
    {
      'title': 'Glass & Tinting',
      'icon': 'assets/glass.png',
      'description': 'Window tinting and windshield repairs.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Our Services',
          style: GoogleFonts.quicksand(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two boxes per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1, // Square shape
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailScreen(
                      title: services[index]['title'],
                      icon: services[index]['icon'],
                      description: services[index]['description'],
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      services[index]['icon'],
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      services[index]['title'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
