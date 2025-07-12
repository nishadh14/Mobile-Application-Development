import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garage_app/View/login_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds then navigate to login screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/1.jpeg", // Ensure this image exists in assets
            fit: BoxFit.cover,
          ),

          // Semi-transparent overlay for better visibility
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
          ),

          // Centered Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(
                        255, 9, 9, 9), // White background for contrast
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/2.jpg", // Ensure this image exists
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  "Garage App",
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Your car, your garage, your control.",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(215, 222, 238, 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
