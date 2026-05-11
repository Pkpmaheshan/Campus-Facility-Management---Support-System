import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentListPage extends StatefulWidget {
  final String batch;

  const StudentListPage({super.key, required this.batch});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future loadStudents() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/batch/${widget.batch}/students"),
    );

    if (res.statusCode == 200) {
      setState(() {
        students = json.decode(res.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batch ${widget.batch} Students"),
        backgroundColor: Colors.green,
      ),

      body: ListView.builder(
        itemCount: students.length,

        itemBuilder: (context, index) {
          final s = students[index];

          return ListTile(title: Text(s["name"]), subtitle: Text(s["email"]));
        },
      ),
    );
  }
}
