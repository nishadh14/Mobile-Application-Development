import 'package:corruptify/view/slider/main_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anti-Corruption App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto', // Clean and professional font
      ),
      home: SplashScreen(),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Navigate to HomeScreen after a delay of 5 seconds
//     Timer(Duration(seconds: 5), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => SliderPage()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedOpacity(
//               opacity: 1.0,
//               duration: Duration(seconds: 2),
//               child: Image.asset(
//                 'assets/ScreenUser/logo.png',
//                 width: 500,
//                 height: 500,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Empowering Citizens, Fighting Corruption',
//               style: TextStyle(
//                 fontSize: 18,
//                 color:
//                     const Color.fromARGB(255, 224, 226, 234).withOpacity(0.7),
//               ),
//             ),
//             SizedBox(height: 40),
//             const CircularProgressIndicator(
//               color: Color.fromARGB(255, 88, 106, 199),
//               strokeWidth: 4,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    // Initialize the audio player
    _audioPlayer = AudioPlayer();

    // Play the splash sound when the splash screen is displayed
    _playSplashSound();
    // Navigate to HomeScreen after a delay of 5 seconds
    Timer(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SliderPage()),
      );
    });
  }

  Future<void> _playSplashSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/splash_sound1.mp3'));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void dispose() {
    // Release the audio player when the screen is disposed
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/ScreenUser/logo.png',
                width: 500,
                height: 500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Empowering Citizens, Fighting Corruption',
              style: TextStyle(
                fontSize: 18,
                color:
                    const Color.fromARGB(255, 224, 226, 234).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 88, 106, 199),
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
