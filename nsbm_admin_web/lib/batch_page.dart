import 'package:flutter/material.dart';
import 'student_list_page.dart';

class BatchPage extends StatelessWidget {
  final String batch;

  const BatchPage({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batch $batch"),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          ListTile(
            title: const Text("Time Table"),
            leading: const Icon(Icons.schedule),
          ),

          ListTile(
            title: const Text("Alerts"),
            leading: const Icon(Icons.notifications),
          ),

          ListTile(
            title: const Text("Students"),
            leading: const Icon(Icons.people),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentListPage(batch: batch),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
