import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:garage_app/View/User/Genral_Services_Screen.dart';

import 'package:garage_app/View/User/User_home_screen.dart';
import 'package:garage_app/View/User/Specific_Services_Screen.dart';
import 'package:garage_app/View/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDmIoVT_edhk2QbYjUlyucDydnO0JyNUW0",
    appId: "1:395818536966:android:6e55606d0c6b2ca0137387",
    messagingSenderId: "395818536966",
    projectId: "garage-27087",
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool("IsLoggin") ?? false;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const UserHomeScreen() : const SplashScreen(),
    );
  }
}
