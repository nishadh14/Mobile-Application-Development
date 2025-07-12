// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Help & Support",
            style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 11, 11),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpOptions(context),
            const SizedBox(height: 20),
            _buildContactSection(),
            const SizedBox(height: 20),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }

  // Help Options List
  Widget _buildHelpOptions(BuildContext context) {
    return Column(
      children: [
        _buildHelpItem(Icons.chat_bubble_outline, "Live Chat Support", () {
          // Navigate to Live Chat Screen
        }),
        _buildHelpItem(Icons.phone, "Call Us", () {
          // Open Call Dialog
        }),
        _buildHelpItem(Icons.email, "Email Support", () {
          // Open Email App
        }),
        _buildHelpItem(Icons.report_problem, "Report an Issue", () {
          // Navigate to Report Issue Screen
        }),
      ],
    );
  }

  Widget _buildHelpItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 255, 148, 82)),
        title: Text(title, style: GoogleFonts.quicksand(fontSize: 16)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // Contact Information Section
  Widget _buildContactSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Us",
                style: GoogleFonts.quicksand(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone,
                    color: Color.fromARGB(255, 255, 148, 82)),
                const SizedBox(width: 10),
                Text("+1 234 567 890",
                    style: GoogleFonts.quicksand(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.email,
                    color: Color.fromARGB(255, 255, 148, 82)),
                const SizedBox(width: 10),
                Text("support@garageapp.com",
                    style: GoogleFonts.quicksand(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // FAQ Section
  Widget _buildFAQSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Frequently Asked Questions",
                style: GoogleFonts.quicksand(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildFAQItem("How do I book a service?",
                "Go to the Home Screen and select the service you need."),
            _buildFAQItem("What are the payment options?",
                "You can pay via Credit Card, Debit Card, or UPI."),
            _buildFAQItem("How can I track my service?",
                "You can check the service status in the 'My Vehicles' section."),
            _buildFAQItem("How do I contact customer support?",
                "You can use Live Chat, Email, or Call options available in this section."),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question,
          style:
              GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: Text(answer, style: GoogleFonts.quicksand(fontSize: 14)),
        ),
      ],
    );
  }
}
