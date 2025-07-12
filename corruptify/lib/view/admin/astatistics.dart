import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  _AdminStatisticsScreenState createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
  double reportsPending = 0;
  double reportsResolved = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    listenToStatistics();
  }

  void listenToStatistics() {
    FirebaseFirestore.instance
        .collection('statistics')
        .doc('reports')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          reportsPending = (snapshot.data()?['pending'] ?? 0).toDouble();
          reportsResolved = (snapshot.data()?['resolved'] ?? 0).toDouble();
        });
      }
    });
  }

  // Future<void> fetchStatistics() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('statistics')
  //         .doc('reports')
  //         .get();
  //     if (snapshot.exists) {
  //       setState(() {
  //         reportsPending = (snapshot.data()?['pending'] ?? 0).toDouble();
  //         reportsResolved = (snapshot.data()?['resolved'] ?? 0).toDouble();
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print("Error fetching data: $error");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Pending Reports": reportsPending,
      "Resolved Reports": reportsResolved,
    };

    List<Color> colorList = [
      const Color(0xFF6A1B9A), // Deep Purple
      const Color.fromARGB(255, 86, 196, 92), // Golden Yellow
      const Color(0xFFFF4081), // Golden Yellow
    ];

    bool isDark = SessionData.isDark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 53, 53, 55)
          : const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          "Statistics",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color(0xFF6C63FF), // Deep Purple
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 73, 150), // Light Purple
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Reports Pending",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${reportsPending.toInt()}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 111, 189, 114), 
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Reports Resolved",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${reportsResolved.toInt()}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
