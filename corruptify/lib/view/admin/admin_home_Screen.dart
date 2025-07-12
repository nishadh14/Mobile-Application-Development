import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/admin/astatistics.dart';
import 'package:corruptify/view/login_type.dart';
import 'package:flutter/material.dart';
import 'package:corruptify/view/admin/admin_notifications/anotifications.dart';
import 'package:corruptify/view/admin/officers/officers.dart';
import 'package:corruptify/view/admin/report_approval.dart';
import 'package:corruptify/view/user/settings_screen.dart';

class AdminFirstPage extends StatefulWidget {
  const AdminFirstPage({super.key});

  @override
  State<AdminFirstPage> createState() => _AdminFirstPageState();
}

class _AdminFirstPageState extends State<AdminFirstPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isDark = SessionData.isDark;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
            begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    setState(() {});
  }

  void _toggleDrawer() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 13, 13, 13)
          : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "Corruptify",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),

        backgroundColor: isDark
            ? const Color.fromARGB(255, 13, 13, 13)
            : const Color(0xFF6C63FF), // Violet tone
        centerTitle: true,
        leading: IconButton(
          icon: isDark
              ? const Icon(
                  Icons.menu,
                  color: Colors.white,
                )
              : const Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // Background Wave
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: screenHeight * 0.41,
                  decoration: isDark
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 119, 116, 116),
                              Color.fromARGB(255, 212, 204, 204),
                            ], // Violet to lavender gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        )
                      : const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF6C63FF),
                              Color(0xFFEDE7F6)
                            ], // Violet to lavender gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/admin/bgimg.png",
                      height: screenHeight * 0.21,
                      width: screenWidth * 0.5,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    isDark
                        ? const Text(
                            "Where Decisions Inspire Action !",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            "Where Decisions Inspire Action !",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(height: 50),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/admin/statics.gif",
                      label: "Statistics",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminStatisticsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 23),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/admin/reportmngmnt.gif",
                      label: "Report Management",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ReportApprovalPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 23),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/admin/administation.gif",
                      label: "Administration",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const OfficerScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 23),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminNotificationPage()),
                        );
                      },
                      child: _buildMenuOption(
                        context,
                        iconUrl: "assets/admin/notifications.gif",
                        label: "Notifications",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminNotificationPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Sliding Drawer
              SlideTransition(
                position: _slideAnimation,
                child: Material(
                  elevation: 20,
                  child: Container(
                    width: screenWidth * 0.7,
                    decoration: isDark
                        ? const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF000000),
                                Color(0xFF505050),
                              ],
                              // Matching violet to lavender gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          )
                        : const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF6C63FF),
                                Color(0xFFEDE7F6)
                              ], // Matching violet to lavender gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.2,
                          decoration: isDark
                              ? const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF000000),
                                      Color(0xFF505050),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                )
                              : const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFFEDE7F6)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/admin/menu.gif",
                                  height: screenHeight * 0.06,
                                  width: screenWidth * 0.13,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "  Menu",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDrawerItem(
                          context,
                          iconUrl: "assets/ScreenUser/settings.gif",
                          label: "Settings",
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SettingScreen()));
                          },
                        ),
                        _buildDrawerItem(
                          context,
                          iconUrl: "assets/ScreenUser/logout.gif",
                          label: "Logout",
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginChoiceScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context,
      {required String iconUrl,
      required String label,
      required Function onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isDark
          ? BoxDecoration(
              color: const Color.fromARGB(255, 10, 9, 9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 251, 250, 250).withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: ListTile(
        leading: Image.asset(iconUrl, height: 50, width: 50),
        title: Text(
          label,
          style: isDark
              ? const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255),
                )
              : const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 10, 10, 10),
                ),
        ),
        onTap: () => onTap(),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required String iconUrl,
      required String label,
      required Function onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? const Color.fromARGB(255, 254, 252, 252).withOpacity(0.3)
                  : const Color.fromARGB(255, 95, 91, 157).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Image.asset(iconUrl, height: 40, width: 40),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 100,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 180,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
