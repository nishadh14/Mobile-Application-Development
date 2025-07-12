import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminWorkersScreen extends StatefulWidget {
  const AdminWorkersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminWorkersScreenState createState() => _AdminWorkersScreenState();
}

class _AdminWorkersScreenState extends State<AdminWorkersScreen> {
  List<Map<String, dynamic>> workers =
      []; // Workers fetched from the PHP server
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchWorkers(); // Fetch workers when the screen loads
  }

  Future<void> fetchWorkers() async {
    const String apiUrl = "http://garage.satishpawale.link/fetch_workers.php";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          workers = data.map((worker) {
            return {
              "name": worker["name"],
              "role": worker["role"],
              "image": worker["image"] ?? "assets/man.png",
            };
          }).toList();
        });
      } else {
        throw Exception("Failed to load workers");
      }
    } catch (error) {
      log("Error fetching workers: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkers = workers
        .where((worker) =>
            worker["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
            worker["role"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Garage Workers",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search workers...",
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchQuery = "";
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: filteredWorkers.length,
                itemBuilder: (context, index) {
                  final worker = filteredWorkers[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(worker["image"]),
                        radius: 25,
                      ),
                      title: Text(worker["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(worker["role"]),
                      onTap: () {
                        _showWorkerDetails(worker);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWorker,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showWorkerDetails(Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(worker["name"],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(worker["image"]),
                radius: 40,
              ),
              const SizedBox(height: 10),
              Text(worker["role"]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _addWorker() {
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Add New Worker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Worker Name"),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: "Worker Role"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    roleController.text.isNotEmpty) {
                  await addWorker(nameController.text, roleController.text);
                  Navigator.pop(context);
                  fetchWorkers(); // Refresh the worker list after adding
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> addWorker(String name, String role) async {
    const String apiUrl = "http://garage.satishpawale.link/add_worker.php";

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {"name": name, "role": role, "image": "assets/man.png"},
      );

      var responseData = json.decode(response.body);

      if (responseData["success"] == true) {
        fetchWorkers();
        log("Worker added successfully!");
      } else {
        log("Failed to add worker: ${responseData["message"]}");
      }
    } catch (error) {
      log("Error adding worker: $error");
    }
  }
}
