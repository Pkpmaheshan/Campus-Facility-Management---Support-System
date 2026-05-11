import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NeedItemsScreen extends StatefulWidget {
  const NeedItemsScreen({super.key});

  @override
  _NeedItemsScreenState createState() => _NeedItemsScreenState();
}

class _NeedItemsScreenState extends State<NeedItemsScreen> {
  final TextEditingController otherController = TextEditingController();

  Map<String, bool> items = {
    "Pen": false,
    "Battery": false,
    "QR Code Sheet": false,
    "Mic / Remote": false,
    "Additional Chairs": false,
    "Other": false,
  };

  Future<void> submitItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("user_id"); // ✅ FIX

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    List<String> selectedItems = [];

    items.forEach((key, value) {
      if (value && key != "Other") {
        selectedItems.add(key);
      }
    });

    if (items["Other"] == true && otherController.text.isNotEmpty) {
      selectedItems.add(otherController.text);
    }

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one item")),
      );
      return;
    }

    TextEditingController hallController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Lecture Hall"),
          content: TextField(
            controller: hallController,
            decoration: const InputDecoration(
              labelText: "Hall Number (e.g., B201)",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (hallController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter hall number")),
                  );
                  return;
                }

                Navigator.popUntil(context, (route) => route.isFirst);

                try {
                  final response = await http.post(
                    Uri.parse("http://10.0.2.2:8000/api/requests"),
                    headers: {
                      "Authorization": "Bearer $token",
                      "Accept": "application/json"
                    },
                    body: {
                      "user_id": userId.toString(), // ✅ FIX
                      "type": "item",
                      "title": selectedItems.join(", "),
                      "description": "Need items request",
                      "location": hallController.text,
                      "priority": "medium",
                    },
                  );

                  print("STATUS: ${response.statusCode}");
                  print("BODY: ${response.body}");

                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Items requested successfully"),
                      ),
                    );

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: ${response.body}"),
                      ),
                    );
                  }
                } catch (e) {
                  print("ERROR: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Server error")),
                  );
                }
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Need Items")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...items.keys.map((item) {
                    return CheckboxListTile(
                      title: Text(item),
                      value: items[item],
                      onChanged: (value) {
                        setState(() {
                          items[item] = value!;
                        });
                      },
                    );
                  }),
                  if (items["Other"] == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: otherController,
                        decoration: const InputDecoration(
                          labelText: "Add your request...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: submitItems,
                child: const Text("Submit"),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You will receive a notification when approved.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
