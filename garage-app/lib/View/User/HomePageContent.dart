// import 'package:flutter/material.dart';
// import 'package:garage_app/View/User/AccountScreeen.dart';
// import 'package:garage_app/View/User/ServiceDetailScreen.dart';

// import 'package:garage_app/View/User/service_tracking.dart';

// import 'package:garage_app/View/User/user_booking.dart';
// import 'package:garage_app/View/loginscreen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomePageContent extends StatelessWidget {
//   const HomePageContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           title: Text(
//             "Garage Services",
//             style: GoogleFonts.quicksand(
//                 fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           centerTitle: true,
//           backgroundColor: const Color.fromARGB(255, 14, 11, 11),
//           iconTheme: const IconThemeData(color: Colors.white)),
//       drawer: _buildDrawer(context), // Added Drawer
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildServiceGrid(context),
//               const SizedBox(height: 20),
//               _buildGuaranteeSection(),
//               const SizedBox(height: 20),
//               _buildReferralSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 🛠️ Drawer Menu
//   Widget _buildDrawer(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(color: Colors.black),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 40, color: Colors.black),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Welcome, User",
//                   style: GoogleFonts.quicksand(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(
//               icon: Icons.book_online,
//               text: "Booking",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const BookingScreen()),
//                 );
//               }),
//           _buildDrawerItem(
//               icon: Icons.track_changes,
//               text: "Tracking",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const ServiceTrackingScreen()),
//                 );
//               }),
//           _buildDrawerItem(
//               icon: Icons.account_circle,
//               text: "Account",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AccountScreen()),
//                 );
//               }),
//           const Divider(),
//           _buildDrawerItem(
//               icon: Icons.logout,
//               text: "Logout",
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (BuildContext context) {
//                   return const SignInScreen();
//                 }));
//               }),
//         ],
//       ),
//     );
//   }

//   // 🔹 Drawer Item Builder
//   Widget _buildDrawerItem(
//       {required IconData icon,
//       required String text,
//       required VoidCallback onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(text,
//           style:
//               GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold)),
//       onTap: onTap,
//     );
//   }

//   // Service Grid with Navigation
//   Widget _buildServiceGrid(BuildContext context) {
//     List<Map<String, String>> services = [
//       {"title": "Periodic Service", "icon": "🛠️"},
//       {"title": "Spa & Detailing", "icon": "🧽"},
//       {"title": "Tyres & Wheel Care", "icon": "🚗"},
//       {"title": "Batteries", "icon": "🔋"},
//       {"title": "Brake & Suspension", "icon": "🔧"},
//       {"title": "Clutch & Transmission", "icon": "⚙️"},
//       {"title": "Lights & Mirror", "icon": "💡"},
//       {"title": "Denting & Painting", "icon": "🎨"},
//       {"title": "Custom Repair", "icon": "🔩"},
//       {"title": "Accessories", "icon": "📱"},
//       {"title": "Electrical Maintenance", "icon": "🔌"},
//       {"title": "Body Parts", "icon": "🚘"},
//     ];

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 1.0,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//       ),
//       itemCount: services.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     ServiceDetailScreen(serviceName: services[index]["title"]!),
//               ),
//             );
//           },
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             elevation: 3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(services[index]["icon"]!,
//                     style: const TextStyle(fontSize: 30)),
//                 const SizedBox(height: 5),
//                 Text(
//                   services[index]["title"]!,
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Guarantee Section
//   Widget _buildGuaranteeSection() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Garage Guarantee",
//                 style: GoogleFonts.quicksand(
//                     fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildGuaranteeItem("🚚", "Free Pickup Drop"),
//                 _buildGuaranteeItem("🔩", "Genuine Parts"),
//                 _buildGuaranteeItem("✅", "30 Days Warranty"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGuaranteeItem(String icon, String title) {
//     return Column(
//       children: [
//         Text(icon, style: const TextStyle(fontSize: 30)),
//         const SizedBox(height: 5),
//         Text(title, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   // Referral Section
//   Widget _buildReferralSection() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           children: [
//             Text("Earn ₹1000 for every Friend you Refer",
//                 style: GoogleFonts.quicksand(
//                     fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 5),
//             Text("Get a friend to start using Garage Service",
//                 style: GoogleFonts.quicksand(fontSize: 14)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {},
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//               child: const Text("REFER NOW"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
