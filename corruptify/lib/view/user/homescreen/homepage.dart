import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/login/login_Screen.dart';
import 'package:corruptify/view/login_type.dart';
import 'package:corruptify/view/user/trackreport/track_report.dart';
import 'package:corruptify/view/user/form/form.dart';
import 'package:corruptify/view/user/notification/notification.dart';
import 'package:corruptify/view/user/settings_screen.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

  bool isDark = SessionData.isDark;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          isDark ? Colors.black : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "Corruptify",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: isDark
            ? Color.fromARGB(255, 9, 9, 9)
            : // const Color(0xFF6C63FF)
            const Color(0xFF6C63FF), // Rich violet tone
        centerTitle: true,
        leading: IconButton(
          icon: isDark
              ? const Icon(Icons.menu, color: Colors.white)
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
                  height: screenHeight * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Color.fromARGB(255, 119, 116, 116),
                              Color.fromARGB(255, 212, 204, 204),
                            ]
                          : [
                              Color(0xFF6C63FF),
                              Color(0xFFEDE7F6)
                            ], // Rich violet to soft lavender
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
                      "assets/ScreenUser/homebg.png",
                      height: screenHeight * 0.22,
                      width: screenWidth * 0.4,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Speak Out, Stand Up, Fight Corruption!",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/ScreenUser/filecomplaint.gif",
                      label: "File Complaint",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ReportForm()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/admin/reportmngmnt.gif",
                      label: "Track Report",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const TrackPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildMenuOption(
                      context,
                      iconUrl: "assets/admin/notifications.gif",
                      label: "Notifications",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()),
                        );
                      },
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                Color(0xFF000000),
                                Color(0xFF505050),
                              ]
                            : [
                                Color(0xFF6C63FF),
                                Color(0xFFEDE7F6)
                              ], // Matching gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [
                                      Color(0xFF000000),
                                      Color(0xFF505050),
                                    ]
                                  : [Color(0xFF6C63FF), Color(0xFFEDE7F6)],
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
                                  height: 55,
                                  width: 55,
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
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 10, 9, 9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color.fromARGB(255, 251, 250, 250).withOpacity(0.4)
                : Colors.grey.withOpacity(0.4),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? Color.fromARGB(255, 240, 236, 235) : Colors.black,
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
                  ? Color.fromARGB(255, 254, 252, 252).withOpacity(0.3)
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
