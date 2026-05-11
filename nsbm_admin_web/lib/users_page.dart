import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List students = [];
  List lecturers = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/admin/users'),
        headers: {"Accept": "application/json"},
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          students = data['students'] ?? [];
          lecturers = data['lecturers'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load users";
          isLoading = false;
        });
      }
    } catch (e) {
      print("EXCEPTION: $e");

      setState(() {
        errorMessage = "Connection error";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Students",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...students.map(
                  (student) => ListTile(
                    title: Text(student['name'] ?? ''),
                    subtitle: Text(student['email'] ?? ''),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Lecturers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...lecturers.map(
                  (lecturer) => ListTile(
                    title: Text(lecturer['name'] ?? ''),
                    subtitle: Text(lecturer['email'] ?? ''),
                  ),
                ),
              ],
            ),
    );
  }
}
