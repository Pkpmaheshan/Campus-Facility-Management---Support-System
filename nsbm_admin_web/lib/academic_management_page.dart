import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcademicManagementPage extends StatefulWidget {
  const AcademicManagementPage({super.key});

  @override
  State<AcademicManagementPage> createState() => _AcademicManagementPageState();
}

class _AcademicManagementPageState extends State<AcademicManagementPage> {
  List faculties = [];
  List departments = [];
  List degrees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/academic/all"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          faculties = data['faculties'];
          departments = data['departments'];
          degrees = data['degrees'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Academic load error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _addItem(String type, String name) async {
    String endpoint = "";
    if (type == "Faculty") endpoint = "faculty";
    if (type == "Department") endpoint = "department";
    if (type == "Degree") endpoint = "degree";

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/academic/$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$type added successfully!")));
        }
      }
    } catch (e) {
      print("Add error: $e");
    }
  }

  void _showAddDialog(String type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New $type"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: "$type Name", border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addItem(type, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text("Academic Management"),
        backgroundColor: Colors.green[800],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Faculties", faculties, "Faculty"),
                  const SizedBox(width: 24),
                  _buildSection("Departments", departments, "Department"),
                  const SizedBox(width: 24),
                  _buildSection("Degrees", degrees, "Degree"),
                ],
              ),
            ),
    );
  }

  Widget _buildSection(String title, List items, String type) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => _showAddDialog(type),
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['name']),
                  trailing: const Icon(Icons.chevron_right, size: 16),
                );
              },
            ),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("No items found", style: TextStyle(color: Colors.grey))),
              ),
          ],
        ),
      ),
    );
  }
}
