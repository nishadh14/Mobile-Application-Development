import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_car), label: "My Vehicles"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Referral"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: "Account"),
      ],
    );
  }
}
