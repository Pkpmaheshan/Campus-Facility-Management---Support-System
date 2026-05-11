import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'batch_students_page.dart';

class BatchManagementPage extends StatefulWidget {
  const BatchManagementPage({super.key});

  @override
  State<BatchManagementPage> createState() => _BatchManagementPageState();
}

class _BatchManagementPageState extends State<BatchManagementPage> {
  List batches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBatches();
  }

  Future<void> loadBatches() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/batches"));
      if (response.statusCode == 200) {
        setState(() {
          batches = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading batches: $e");
      setState(() => isLoading = false);
    }
  }

  void _showCreateBatchDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Batch"),
        content: TextField(
          controller: controller, 
          decoration: const InputDecoration(
            labelText: "Batch Name",
            hintText: "e.g. 23.1, 24.2",
            border: OutlineInputBorder(),
          )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final res = await http.post(
                  Uri.parse("http://127.0.0.1:8000/api/create-batch"),
                  body: {'batch': controller.text},
                );
                if (res.statusCode == 200 || res.statusCode == 201) {
                  Navigator.pop(context);
                  loadBatches();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to create batch. It might already exist."))
                  );
                }
              }
            },
            child: const Text("Create"),
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
        title: const Text("Batch Management"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton.icon(
              onPressed: _showCreateBatchDialog,
              icon: const Icon(Icons.add),
              label: const Text("New Batch"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green[800]),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : batches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.groups_outlined, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text("No batches found.", style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 24),
                      ElevatedButton(onPressed: _showCreateBatchDialog, child: const Text("Create Your First Batch")),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: batches.length,
                  itemBuilder: (context, index) {
                    final b = batches[index];
                    return _buildBatchCard(b['batch']);
                  },
                ),
    );
  }

  Widget _buildBatchCard(String name) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BatchStudentsPage(batch: name))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
              child: Icon(Icons.groups, color: Colors.green[800], size: 30),
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Click to view students", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
