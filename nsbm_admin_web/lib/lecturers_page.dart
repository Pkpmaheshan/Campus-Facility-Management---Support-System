import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_user_page.dart';

class LecturersPage extends StatefulWidget {
  const LecturersPage({super.key});

  @override
  State<LecturersPage> createState() => _LecturersPageState();
}

class _LecturersPageState extends State<LecturersPage> {
  List allLecturers = [];
  List filteredLecturers = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLecturers();
  }

  Future<void> loadLecturers() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/admin/users"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allLecturers = data['lecturers'];
          filteredLecturers = allLecturers;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading lecturers: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterLecturers(String query) {
    setState(() {
      filteredLecturers = allLecturers.where((l) {
        final name = l['name'].toString().toLowerCase();
        final email = l['email'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text("Lecturer Directory"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddUserPage(initialRole: 'lecturer'),
                  ),
                );
                loadLecturers();
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Lecturer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green[800],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterLecturers,
                    decoration: InputDecoration(
                      hintText: "Search by Name or Email...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  "${filteredLecturers.length} Lecturers found",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // TABLE SECTION
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLecturers.isEmpty
                ? const Center(
                    child: Text("No lecturers found matching your search."),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          Colors.grey[50],
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              "NAME",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "EMAIL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "DEPARTMENT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "FACULTY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "ACTIONS",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: filteredLecturers.map((l) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.blue[100],
                                      child: const Icon(
                                        Icons.school,
                                        size: 15,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(l['name']),
                                  ],
                                ),
                              ),
                              DataCell(Text(l['email'])),
                              DataCell(Text(l['department'] ?? 'General')),
                              DataCell(Text(l['faculty'] ?? 'N/A')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddUserPage(
                                              initialRole: 'lecturer',
                                              user: l,
                                            ),
                                          ),
                                        );
                                        loadLecturers();
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
