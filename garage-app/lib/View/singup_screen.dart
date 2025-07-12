
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garage_app/View/login_screen.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _confirmPasswordVisible = false;

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    const String apiUrl = "your url";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "phone_no": phonecontroller.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["status"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful!")),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["message"])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error, please try again")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset("assets/1.jpeg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)), // Dark overlay

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.04,
                    horizontal: screenWidth > 600 ? screenWidth * 0.1 : 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Create Account",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        SizedBox(height: screenHeight * 0.01),
                        Text("Sign up to get started",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600])),
                        SizedBox(height: screenHeight * 0.03),
                        buildTextField(nameController, 'User Name',
                            Icons.person, TextInputType.name),
                        SizedBox(height: screenHeight * 0.02),
                        buildTextField(emailController, 'Email', Icons.email,
                            TextInputType.emailAddress),
                        SizedBox(height: screenHeight * 0.02),
                        buildTextField(phonecontroller, 'Phone No.',
                            Icons.phone, TextInputType.phone),
                        SizedBox(height: screenHeight * 0.02),
                        buildTextField(
                          passwordController,
                          'Password',
                          Icons.lock,
                          TextInputType.text,
                          obscureText: !_confirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() => _confirmPasswordVisible =
                                  !_confirmPasswordVisible);
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        buildTextField(
                          confirmPasswordController,
                          'Confirm Password',
                          Icons.lock,
                          TextInputType.text,
                          obscureText: !_confirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() => _confirmPasswordVisible =
                                  !_confirmPasswordVisible);
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: registerUser,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  child: const Text("Sign Up",
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                        SizedBox(height: screenHeight * 0.02),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          },
                          child: const Text("Already have an account? Sign In"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      IconData icon, TextInputType inputType,
      {bool obscureText = false, Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: inputType,
      obscureText: obscureText,
      validator: (value) => value!.isEmpty ? "Please enter your $label" : null,
    );
  }
}
