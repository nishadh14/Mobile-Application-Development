import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String referralCode = "GARAGE1000";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Refer & Earn",
            style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 11, 11),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Image or Icon
            Image.asset("assets/refer_friend.jpg",
                height: 180, fit: BoxFit.cover), // Add your image in assets

            const SizedBox(height: 20),

            // Referral Text
            Text(
              "Invite your Friends & Earn ₹1000!",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Share your referral code with your friends. When they sign up, you both get rewards!",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Referral Code Box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Color.fromARGB(255, 255, 148, 82), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    referralCode,
                    style: GoogleFonts.quicksand(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy,
                        color: Color.fromARGB(255, 255, 148, 82)),
                    onPressed: () {
                      _copyToClipboard(context, referralCode);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Share Button
            ElevatedButton.icon(
              onPressed: () {
                _shareReferralCode(referralCode);
              },
              icon: const Icon(Icons.share, color: Colors.white),
              label: Text(
                "Share Now",
                style: GoogleFonts.quicksand(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 148, 82),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const Spacer(),

            // Terms & Conditions
            Text(
              "Terms & Conditions apply",
              style: GoogleFonts.quicksand(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.black45),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Copy to Clipboard Function
  void _copyToClipboard(BuildContext context, String text) {
    Share.share(
        "Use my referral code: $text to sign up for Garage Services & earn rewards!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Referral Code Copied: $text"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Share Function
  void _shareReferralCode(String referralCode) {
    Share.share(
        "Join Garage Services & get ₹1000! Use my referral code: $referralCode to sign up.");
  }
}
