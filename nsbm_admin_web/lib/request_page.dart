import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProblemReportsPage extends StatefulWidget {
  const ProblemReportsPage({super.key});

  @override
  State<ProblemReportsPage> createState() => _ProblemReportsPageState();
}

class _ProblemReportsPageState extends State<ProblemReportsPage> {
  List requests = [];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future loadRequests() async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/requests"),
    );

    if (response.statusCode == 200) {
      setState(() {
        requests = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Problem Reports"),
      ),

      body: requests.isEmpty
          ? const Center(child: Text("No problem reports"))
          : ListView.builder(
              itemCount: requests.length,

              itemBuilder: (context, index) {
                final request = requests[index];

                return ListTile(
                  title: Text(request["title"] ?? ""),

                  subtitle: Text(
                    "Location: ${request["location"] ?? "No location"}",
                  ),
                );
              },
            ),
    );
  }
}
