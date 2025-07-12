import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/admin/admin_home_Screen.dart';
import 'package:corruptify/view/user/about_us.dart';
import 'package:corruptify/view/user/homescreen/homepage.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State createState() => _SettingScreenState();
}

class _SettingScreenState extends State {
  bool darkMode = SessionData.isDark;
  bool? isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 247, 240, 240)),
        ),
        centerTitle: true,
        backgroundColor: darkMode
            ? const Color.fromARGB(255, 17, 17, 17)
            : const Color(0xFF6C63FF),
        leading: GestureDetector(
          onTap: () async {
            isAdmin = SessionData.isAdmin;

            await Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    isAdmin! ? const AdminFirstPage() : const FirstPage()));
            ;
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: darkMode
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 22, 20, 20),
                    Color.fromARGB(255, 83, 83, 83)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD3D3D3), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(16.0),
                    child: darkMode
                        ? const Icon(
                            Icons.dark_mode,
                            color: Color.fromARGB(255, 245, 242, 242),
                            size: 28,
                          )
                        : const Icon(
                            Icons.dark_mode,
                            size: 28,
                          )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Dark Mode',
                      style: darkMode
                          ? const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 245, 242, 242),
                            )
                          : const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await SessionData.getSessionData();
                    darkMode = SessionData.isDark;
                    if (darkMode == false) {
                      await SessionData.storeSessionData(darkMode: true);
                    } else {
                      await SessionData.storeSessionData(darkMode: false);
                    }
                    setState(() {});
                    print(darkMode);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      darkMode ? Icons.toggle_on : Icons.toggle_off,
                      color: darkMode
                          ? Color.fromARGB(255, 245, 242, 242)
                          : Color.fromARGB(255, 0, 0, 0),
                      size: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: darkMode
                    ? const Icon(
                        Icons.info_rounded,
                        color: Color.fromARGB(255, 245, 242, 242),
                        size: 28,
                      )
                    : const Icon(
                        Icons.info_rounded,
                        size: 28,
                      ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutUsPage()));
                },
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'About',
                      style: darkMode
                          ? const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 245, 242, 242),
                            )
                          : const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.notifications,
//                     size: 28,
//                   ),
//                 ),
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Notifications',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.toggle_on,
//                     size: 28,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.info,
//                     size: 28,
//                   ),
//                 ),
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'App Version',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.lock_outline,
//                     size: 28,
//                   ),
//                 ),
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Privacy & Security',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.only(bottom: 16.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.headphones_outlined,
//                     size: 28,
//                   ),
//                 ),
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Help and Support',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Icon(
//                     Icons.arrow_forward_ios,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
            ]),
          ),
        ]),
      ),
    );
  }
}
