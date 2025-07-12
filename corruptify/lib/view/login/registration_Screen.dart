import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/view/admin/admin_home_Screen.dart';
import 'package:corruptify/view/login/login_Screen.dart';
import 'package:corruptify/view/user/homescreen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final TextEditingController _UserEmail = TextEditingController();
  final TextEditingController _UserPassword = TextEditingController();
  final TextEditingController _UserRePassword = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isObscured = true;
  bool? isAdmin;
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
                  height: 170,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 90,
                    ),
                    Text(
                      "Sign Up",
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
                  controller: _UserEmail,
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
                const SizedBox(height: 30),
                TextField(
                  controller: _UserPassword,
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
                const SizedBox(height: 30),
                TextField(
                  controller: _UserRePassword,
                  decoration: InputDecoration(
                    labelText: "Re-Enter Password",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onEditingComplete: () {
                    if (_UserPassword.text != _UserRePassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Password didn't match")));
                    }
                  },
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_UserPassword.text != _UserRePassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password didn't match")));
                      }
                      if (_UserEmail.text.trim().isNotEmpty &&
                          _UserPassword.text.trim().isNotEmpty) {
                        try {
                          await _firebaseAuth.createUserWithEmailAndPassword(
                              email: _UserEmail.text.trim(),
                              password: _UserPassword.text.trim());
                          await SessionData.getSessionData();
                          isAdmin = SessionData.isAdmin;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => isAdmin!
                                      ? const AdminFirstPage()
                                      : const FirstPage()));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("User register Succesfully")));
                        } on FirebaseAuthException catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${error.message}")));
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
                      "Sign Up",
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
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text(
                      "Already have an account ? Login Here",
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
