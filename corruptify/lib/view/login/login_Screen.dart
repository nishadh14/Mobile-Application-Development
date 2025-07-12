import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/login_type.dart';
import 'package:corruptify/view/admin/admin_home_Screen.dart';
import 'package:corruptify/view/login/registration_Screen.dart';
import 'package:corruptify/view/user/homescreen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _loginUserEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool? isAdmin;

  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    fetchType();
  }

  Future<void> fetchType() async {
    LoginChoiceScreen();
  }

  void createStatisticsCollection() async {
    try {
      FirebaseFirestore.instance
          .collection('statistics') // Collection name
          .doc('reports') // Document ID
          .set({
        // Initial data
        'pending': 0,
        'resolved': 0,
      });
      print("Collection and document created successfully!");
    } catch (e) {
      print("Error creating collection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 63, 46, 140),
                  Color.fromARGB(255, 104, 100, 216),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 230,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 110,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _loginUserEmail,
                  decoration: InputDecoration(
                    labelText: "Enter Your Email",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    suffixIcon: const Icon(Icons.person, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                TextField(
                  controller: _loginPassword,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_loginUserEmail.text.trim().isNotEmpty &&
                          _loginPassword.text.trim().isNotEmpty) {
                        try {
                          await _firebaseAuth.signInWithEmailAndPassword(
                              email: _loginUserEmail.text.trim(),
                              password: _loginPassword.text.trim());
                          await SessionData.getSessionData();
                          isAdmin = SessionData.isAdmin;
                          //createStatisticsCollection();

                          await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => isAdmin!
                                      ? const AdminFirstPage()
                                      : const FirstPage()));
                        } on FirebaseAuthException catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.code)));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext conyext) {
                        return const RegistrationScreen();
                      }));
                    },
                    child: const Text(
                      "New User ? Sign Up Here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class AdminLoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AdminFirstPage(),
//     );
//   }
// }

// class UserLoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FirstPage(),
//     );
//   }
// }
