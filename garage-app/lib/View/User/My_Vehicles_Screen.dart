import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  _MyVehiclesScreenState createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  List<Map<String, String>> vehicles = [
    {
      "name": "Toyota Corolla",
      "image": "assets/5.jpg",
      "number": "MH 12 AB 3456"
    },
    {"name": "Honda Civic", "image": "assets/6.jpg", "number": "KA 05 XY 7890"},
    {"name": "Yamaha R15", "image": "assets/7.jpg", "number": "TN 22 ZZ 5678"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Vehicles",
            style: GoogleFonts.quicksand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 11, 11),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildVehicleList()),
            _buildAddVehicleButton(),
          ],
        ),
      ),
    );
  }

  // Vehicle List UI
  Widget _buildVehicleList() {
    return vehicles.isEmpty
        ? Center(
            child: Text(
              "No vehicles added yet!",
              style: GoogleFonts.quicksand(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          )
        : ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      vehicles[index]["image"]!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(vehicles[index]["name"]!,
                      style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("Number: ${vehicles[index]["number"]}",
                      style: GoogleFonts.quicksand(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        vehicles.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          );
  }

  // Add Vehicle Button
  Widget _buildAddVehicleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            _showAddVehicleDialog();
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Vehicle"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: GoogleFonts.quicksand(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Add Vehicle Dialog
  void _showAddVehicleDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Vehicle",
              style: GoogleFonts.quicksand(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Vehicle Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: "Vehicle Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    numberController.text.isNotEmpty) {
                  setState(() {
                    vehicles.add({
                      "name": nameController.text,
                      "image": "assets/default_vehicle.jpg", // Default Image
                      "number": numberController.text
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
