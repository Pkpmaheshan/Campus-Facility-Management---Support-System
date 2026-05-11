import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TimeTablePage extends StatefulWidget {
  final String batch;

  const TimeTablePage({super.key, required this.batch});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  String timetableLink = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTimetable();
  }

  /// LOAD TIMETABLE FROM API
  Future<void> loadTimetable() async {
    try {
      final url = "${ApiService.baseUrl}/timetable/${widget.batch}";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          timetableLink = data["excel_link"] ?? "";
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print("Error loading timetable: $e");

      setState(() {
        loading = false;
      });
    }
  }

  /// OPEN EXCEL LINK
  Future<void> openTimetable() async {
    if (timetableLink.isEmpty) return;

    final uri = Uri.parse(timetableLink);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not open timetable");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Table"),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : timetableLink.isEmpty
                ? const Text("No timetable available")
                : ElevatedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text("Open Time Table"),
                    onPressed: openTimetable,
                  ),
      ),
    );
  }
}
