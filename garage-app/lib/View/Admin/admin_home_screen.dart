import 'package:flutter/material.dart';
import 'package:garage_app/View/Admin/Admin_booking_screen.dart';
import 'package:garage_app/View/Admin/admin_destop.dart';
import 'package:garage_app/View/Admin/admin_services_screen.dart';
import 'package:garage_app/View/Admin/workers_list.dart';
import 'package:garage_app/View/login_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  final String garageName;
  final String garageAddress;

  const AdminHomeScreen(
      {super.key, required this.garageName, required this.garageAddress});

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              );
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Garage Name
            Text(
              widget.garageName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 50, 50, 49),
                shadows: [Shadow(color: Colors.black38, blurRadius: 5)],
              ),
            ),
            const SizedBox(height: 8),

            // Garage Address
            Text(
              widget.garageAddress,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Grid Layout for Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _buildGridItem("Dashboard", "assets/dashboard.png", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AdminDashboardScreen()),
                    );
                  }),
                  _buildGridItem("Services", "assets/repair-shop.png", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AdminServicesScreen()),
                    );
                  }),
                  _buildGridItem("Workers", "assets/workers.png", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AdminWorkersScreen()),
                    );
                  }),
                  _buildGridItem("Bookings", "assets/calendar.png", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AdminBookingScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid Item Widget with PNG Icons
  Widget _buildGridItem(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(232, 230, 230, 230),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 60, height: 60), // PNG Icon
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
