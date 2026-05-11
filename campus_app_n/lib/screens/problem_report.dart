import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart'; // 🔗 Import ApiService

class ProblemReportScreen extends StatefulWidget {
  const ProblemReportScreen({super.key});

  @override
  State<ProblemReportScreen> createState() => _ProblemReportScreenState();
}

class _ProblemReportScreenState extends State<ProblemReportScreen> {
  String? selectedProblem;
  String? selectedPriority = "medium"; // Default priority
  String? selectedLocation; // New field for location dropdown

  final TextEditingController otherController = TextEditingController();

  bool isLoading = false;

  File? imageFile;
  final ImagePicker picker = ImagePicker();

  final List<String> problems = [
    "AC not working",
    "Lights not working",
    "Projector not working",
    "Room not clean",
    "Fan not working",
    "Chair broken",
    "Other",
  ];

  final List<String> locations = [
    "Lecture Hall A",
    "Lecture Hall B",
    "Lecture Hall C",
    "Lecture Hall D",
    "Computer Lab 01",
    "Computer Lab 02",
    "Main Library",
    "Cafeteria",
    "Office",
  ];

  final List<Map<String, String>> priorities = [
    {"label": "Normal", "value": "medium"},
    {"label": "Urgent 🚨", "value": "high"},
  ];

  // 📷 PICK IMAGE
  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 🚀 SUBMIT PROBLEM
  Future<void> submitProblem() async {
    if (selectedProblem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a problem")),
      );
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location")),
      );
      return;
    }

    setState(() => isLoading = true);

    print("🚀 SUBMIT PROBLEM STARTED");
    print("SELECTED PROBLEM: $selectedProblem");
    print("SELECTED LOCATION: $selectedLocation");
    print("SELECTED PRIORITY: $selectedPriority");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final userId = prefs.getInt("user_id");

      if (token == null) throw Exception("Not logged in");
      if (userId == null) throw Exception("User ID not found");

      String finalTitle = selectedProblem == "Other"
          ? otherController.text.trim()
          : selectedProblem!;

      if (finalTitle.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter the problem")),
        );
        setState(() => isLoading = false);
        return;
      }

      final uri = Uri.parse("${ApiService.baseUrl}/requests");
      print("Sending request to: $uri");

      final request = http.MultipartRequest("POST", uri);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        "user_id": userId.toString(),
        "type": "problem",
        "title": finalTitle,
        "description": finalTitle,
        "location": selectedLocation!,
        "priority": selectedPriority!,
      });

      // 📷 IMAGE
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", imageFile!.path),
        );
      }

      print("Waiting for response...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("RESPONSE STATUS: ${response.statusCode}");
      print("RESPONSE BODY: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Problem submitted successfully")),
        );

        // clear form
        otherController.clear();
        setState(() {
          imageFile = null;
          selectedProblem = null;
          selectedLocation = null;
          selectedPriority = "medium";
        });

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submit failed: $responseBody")),
        );
      }
    } catch (e) {
      print("❌ ERROR SENDING PROBLEM: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Problem Reporting")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Report a problem around the campus",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // 🔽 LOCATION DROPDOWN
            DropdownButtonFormField<String>(
              initialValue: selectedLocation,
              hint: const Text("Select location (e.g. Classroom)"),
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: locations
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // 🔽 PROBLEM DROPDOWN
            DropdownButtonFormField<String>(
              initialValue: selectedProblem,
              hint: const Text("Select problem"),
              decoration: const InputDecoration(
                labelText: "Problem Type",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.report_problem),
              ),
              items: problems
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProblem = value;
                });
              },
            ),

            // ✏️ OTHER FIELD
            if (selectedProblem == "Other") ...[
              const SizedBox(height: 16),
              TextField(
                controller: otherController,
                decoration: const InputDecoration(
                  labelText: "Enter your problem",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 🔽 PRIORITY TOGGLE / DROPDOWN
            DropdownButtonFormField<String>(
              initialValue: selectedPriority,
              decoration: const InputDecoration(
                labelText: "Problem Priority",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: priorities
                  .map((e) => DropdownMenuItem(
                        value: e['value'],
                        child: Text(e['label']!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPriority = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // 📷 UPLOAD PHOTO
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take a photo of the problem"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            if (imageFile != null) ...[
              const SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(imageFile!, height: 180),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // 🚀 SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading ? null : submitProblem,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Report",
                        style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
