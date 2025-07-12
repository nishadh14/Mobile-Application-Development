import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corruptify/blockCode/shared_preferance.dart';
import 'package:corruptify/models/officer_model.dart';
import 'package:flutter/material.dart';

class OfficerScreen extends StatefulWidget {
  const OfficerScreen({super.key});
  @override
  State<OfficerScreen> createState() => _OfficerScreenState();
}

class _OfficerScreenState extends State<OfficerScreen> {
  List<Officer_Model> officers = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  late bool isDark = SessionData.isDark;

  @override
  void initState() {
    super.initState();
    getOfficerData();
  }

  Future<void> getOfficerData() async {
    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection('Officers').get();
      List<Officer_Model> fetchedOfficers = response.docs.map((doc) {
        return Officer_Model(
          officer_name: doc['name'],
          rank: doc['rank'],
          id: doc['id'],
        );
      }).toList();

      setState(() {
        officers = fetchedOfficers;
      });
    } catch (e) {
      debugPrint("Error fetching officers: $e");
    }
  }

  void _showAddOfficerSheet() {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              isDark
                  ? const Text(
                      'Add Officer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 4, 4),
                      ),
                    )
                  : const Text(
                      'Add Officer',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rankController,
                decoration: InputDecoration(
                  labelText: 'Rank',
                  prefixIcon: const Icon(Icons.star),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the rank';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Map<String, String> data = {
                      'name': _nameController.text,
                      'rank': _rankController.text,
                      'id': _idController.text,
                    };

                    try {
                      await FirebaseFirestore.instance
                          .collection('Officers')
                          .add(data);

                      _nameController.clear();
                      _rankController.clear();
                      _idController.clear();
                      Navigator.pop(context);
                      getOfficerData();
                    } catch (e) {
                      debugPrint("Error adding officer: $e");
                    }
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Officer',
                    style: TextStyle(color: Colors.white)),
                style: isDark
                    ? ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 88, 88, 91),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))
                    : ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteOfficer(String officerId) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('Officers')
          .where('id', isEqualTo: officerId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }

      setState(() {
        officers.removeWhere((officer) => officer.id == officerId);
      });
    } catch (e) {
      debugPrint("Error deleting officer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 58, 58, 58)
          : const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: const Text('Administration',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
        centerTitle: true,
        backgroundColor: isDark
            ? const Color.fromARGB(255, 4, 4, 4)
            : const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            Expanded(
              child: officers.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'No officers added yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: officers.length,
                      itemBuilder: (context, index) {
                        var officer = officers[index];
                        return Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isDark
                                    ? const CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 18, 18, 18),
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: Color(0xFF6C63FF),
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        officer.officer_name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Rank: ${officer.rank}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "ID: ${officer.id}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: isDark
                                      ? const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(255, 7, 7, 7),
                                        )
                                      : const Icon(
                                          Icons.delete,
                                          color: Color(0xFF6C63FF),
                                        ),
                                  onPressed: () async {
                                    bool confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete Officer"),
                                        content: const Text(
                                            "Are you sure you want to delete this officer?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm) {
                                      await deleteOfficer(officer.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOfficerSheet,
        backgroundColor: isDark
            ? const Color.fromARGB(255, 22, 22, 22)
            : const Color(0xFF6C63FF),
        child: isDark
            ? const Icon(
                Icons.add,
                color: Color.fromARGB(255, 252, 243, 243),
              )
            : const Icon(Icons.add),
      ),
    );
  }
}
