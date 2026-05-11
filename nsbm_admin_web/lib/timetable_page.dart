import 'package:flutter/material.dart';

class TimeTablePage extends StatelessWidget {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Time Table")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: "Subject"),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Time"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Saved");
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
