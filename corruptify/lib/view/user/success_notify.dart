import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/user/homescreen/homepage.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State createState() => _SuccessPageState();
}

class _SuccessPageState extends State {
  bool successflag = false;
  bool isDark = SessionData.isDark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 30, 30, 30)
          : const Color.fromARGB(255, 255, 237, 237),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Color.fromARGB(255, 71, 70, 71),
                    Color.fromARGB(255, 43, 42, 44),
                  ]
                : [Color(0xFFD3D3D3), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 355,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const FirstPage()),
                    );
                    successflag = true;
                  },
                  child: Image.asset(
                    "assets/ScreenUser/cancel.png",
                    height: 17,
                    width: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 200,
            ),
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/ScreenUser/checked.png",
                      height: 210,
                      width: 210,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Report Submitted Successfully!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.lightBlueAccent,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
