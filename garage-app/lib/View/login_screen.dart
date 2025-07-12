// ignore: depend_on_referenced_packages
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:garage_app/View/Admin/admin_home_screen.dart';

import 'package:garage_app/View/User/Home_Page_New.dart';
import 'package:garage_app/View/User/User_home_screen.dart';

import 'package:garage_app/View/singup_screen.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _confirmPasswordVisible = true;

  Future<void> _loginUser() async {
    const String apiUrl = "your url";

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        if (data["status"] == "success") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("username", data["user"]["name"]);
          await prefs.setString("user_id", data["user"]["id"].toString());
          await prefs.setInt(
              "phone_no", int.parse(data["user"]["phone_no"].toString()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${data["message"]}")),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UserHomeScreen()));
        } else {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${data["message"]}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/1.jpeg", // Make sure this image exists in your assets folder
            fit: BoxFit.cover,
          ),

          // Semi-transparent overlay
          Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
          ),

          // Sign-in Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                color: Colors.white
                    // ignore: deprecated_member_use
                    .withOpacity(0.9), // Slight transparency for a sleek look
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: _confirmPasswordVisible,
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _loginUser();
                                },

                                // _loginUser,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("Sign In",
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text("Don't have an account? Sign Up"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminHomeScreen(
                                    garageName: "Speed Motors",
                                    garageAddress:
                                        "123, Main Street, City, Country")),
                          );
                        },
                        child: const Text("Admin "),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
