// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:garage_app/View/User/Home_Page_New.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('UserName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                child: const Text(
                  'Select Your Vehicle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              BounceInLeft(
                  child: const VehicleCard(
                vehicle: 'Car',
                imagePath: 'assets/4.jpg',
              )),
              const SizedBox(height: 20),
              BounceInRight(
                  child: const VehicleCard(
                vehicle: 'Bike',
                imagePath: 'assets/3.jpg',
              )),
              const SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String vehicle;
  final String imagePath;

  const VehicleCard(
      {super.key, required this.vehicle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log('$vehicle selected');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GarageServiceScreen(),
          ),
        );
      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(imagePath,
                    height: 200, width: 400, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
