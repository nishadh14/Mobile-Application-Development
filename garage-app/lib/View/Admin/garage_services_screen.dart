import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {"name": "Car Wash", "icon": Icons.local_car_wash, "color": Colors.blue},
    {
      "name": "Car Polish",
      "icon": Icons.cleaning_services,
      "color": Colors.teal
    },
    {"name": "Car Service", "icon": Icons.build, "color": Colors.green},
    {"name": "Bike Service", "icon": Icons.motorcycle, "color": Colors.orange},
    {"name": "Truck Repair", "icon": Icons.fire_truck, "color": Colors.red},
    {
      "name": "Scooter Wash",
      "icon": Icons.electric_scooter,
      "color": Colors.purple
    },
    {
      "name": "Interior Cleaning",
      "icon": Icons.clean_hands,
      "color": Colors.amber
    },
    {
      "name": "Parking",
      "icon": Icons.local_parking,
      "color": Colors.deepPurple
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 900
        ? 4 // Desktop
        : screenWidth > 600
            ? 2 // Tablet
            : 2; // Mobile

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vehicle Services",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello,\nWelcome Back! Choose One of Our Services",
              style: TextStyle(
                fontSize: 35, // Dynamic font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(service["icon"],
                            size: screenWidth * 0.08, color: service["color"]),
                        const SizedBox(height: 10),
                        Text(
                          service["name"],
                          style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {},
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
