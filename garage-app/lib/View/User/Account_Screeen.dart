import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("My Account",
              style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 14, 11, 11),
          iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildAccountOptions(context),
            const SizedBox(height: 20),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // Profile Card
  Widget _buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                  "assets/2.jpg"), // Change this to user's profile picture
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("noya ", // Replace with actual user name
                    style: GoogleFonts.quicksand(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("test@gmail.com", // Replace with actual email
                    style: GoogleFonts.quicksand(
                        fontSize: 14, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Account Options
  Widget _buildAccountOptions(BuildContext context) {
    return Column(
      children: [
        _buildAccountOptionItem(Icons.person, "Edit Profile", () {
          // Navigate to Edit Profile Screen
        }),
        _buildAccountOptionItem(Icons.lock, "Change Password", () {
          // Navigate to Change Password Screen
        }),
        _buildAccountOptionItem(Icons.history, "Order History", () {
          // Navigate to Order History Screen
        }),
        _buildAccountOptionItem(Icons.payment, "Payment Methods", () {
          // Navigate to Payment Methods Screen
        }),
        _buildAccountOptionItem(Icons.help_outline, "Help & Support", () {
          // Navigate to Help & Support Screen
        }),
      ],
    );
  }

  Widget _buildAccountOptionItem(
      IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 255, 148, 82)),
        title: Text(title, style: GoogleFonts.quicksand(fontSize: 16)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle logout logic
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 148, 82),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text("LOG OUT",
            style: GoogleFonts.quicksand(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
