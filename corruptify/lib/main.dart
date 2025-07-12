import 'package:corruptify/view/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Corruptify());
}

class Corruptify extends StatelessWidget {
  const Corruptify({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,                            
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State createState() => _MainAppState();
}

class _MainAppState extends State {
  bool hideIdentity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenPage(),
    );
  }
}
