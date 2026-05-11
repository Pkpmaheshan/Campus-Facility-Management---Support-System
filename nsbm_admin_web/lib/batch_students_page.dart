import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_profile_page.dart';

class BatchStudentsPage extends StatefulWidget {
  final String batch;

  const BatchStudentsPage({super.key, required this.batch});

  @override
  State<BatchStudentsPage> createState() => _BatchStudentsPageState();
}

class _BatchStudentsPageState extends State<BatchStudentsPage> {
  List students = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  /// Load Students from API
  Future loadStudents() async {
    try {
      final url = "http://127.0.0.1:8000/api/batch/${widget.batch}/students";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          students = json.decode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  /// Save Timetable to Laravel API
  Future addTimetable(String link) async {
    try {
      final url = Uri.parse("http://127.0.0.1:8000/api/timetable/add");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"batch": widget.batch, "excel_link": link}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Timetable link published successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to publish timetable")),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void showAddTimetableDialog() {
    TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Publish Timetable Link"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the Excel sheet link for this batch. Students will see this in their app."),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: "Excel Link URL",
                  hintText: "https://docs.google.com/spreadsheets/...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Publish Now"),
              onPressed: () {
                if (linkController.text.isNotEmpty) {
                  addTimetable(linkController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Batch ${widget.batch} - Student List"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PAGE HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Batch ${widget.batch}",
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Total Students Enrolled: ${students.length}",
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text("Manage Timetable Link"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          backgroundColor: Colors.green[700],
                        ),
                        onPressed: showAddTimetableDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // STUDENT LIST
                  Expanded(
                    child: students.isEmpty
                        ? const Center(child: Text("No students found in this batch."))
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                              ],
                            ),
                            child: ListView.separated(
                              itemCount: students.length,
                              separatorBuilder: (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final student = students[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.green[100],
                                    child: Text(
                                      student["name"]?[0].toUpperCase() ?? "?",
                                      style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    student["name"] ?? "Unknown Student",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    "ID: ${student["campus_id"] ?? 'Not Set'}  |  Email: ${student["email"]}",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_calendar, color: Colors.blue),
                                        tooltip: "Change Batch",
                                        onPressed: () => _showChangeBatchDialog(student),
                                      ),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentProfilePage(student: student),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showChangeBatchDialog(dynamic student) async {
    String? selectedNewBatch;
    List availableBatches = [];

    // Load batches
    final res = await http.get(Uri.parse("http://127.0.0.1:8000/api/batches"));
    if (res.statusCode == 200) {
      availableBatches = json.decode(res.body);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Batch for ${student['name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select the new batch for this student:"),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "New Batch"),
              items: availableBatches.map((b) => DropdownMenuItem<String>(
                value: b['batch'].toString(),
                child: Text(b['batch'].toString()),
              )).toList(),
              onChanged: (v) => selectedNewBatch = v,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (selectedNewBatch != null) {
                final updateRes = await http.put(
                  Uri.parse("http://127.0.0.1:8000/api/admin/users/${student['id']}/update-batch"),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode({"batch_number": selectedNewBatch}),
                );
                if (updateRes.statusCode == 200) {
                  Navigator.pop(context);
                  loadStudents(); // Refresh list
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Batch updated successfully!")));
                }
              }
            },
            child: const Text("Update Batch"),
          )
        ],
      ),
    );
  }
}
