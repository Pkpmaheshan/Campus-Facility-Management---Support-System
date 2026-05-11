import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LecturerSearchScreen extends StatefulWidget {
  const LecturerSearchScreen({super.key});

  @override
  State<LecturerSearchScreen> createState() => _LecturerSearchScreenState();
}

class _LecturerSearchScreenState extends State<LecturerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List lecturers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLecturers();
  }

  Future<void> _fetchLecturers({String? query}) async {
    setState(() => isLoading = true);
    final data = await ApiService.getLecturers(search: query);
    setState(() {
      lecturers = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Lecturer Search", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _fetchLecturers(query: value),
              decoration: InputDecoration(
                hintText: "Search by name or department...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchLecturers();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 📄 LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : lecturers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off_outlined, size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 10),
                            Text("No lecturers found", style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: lecturers.length,
                        itemBuilder: (context, index) {
                          final lec = lecturers[index];
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.purple[100],
                                child: Text(
                                  lec['name']?[0] ?? 'L',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[800]),
                                ),
                              ),
                              title: Text(
                                lec['name'] ?? 'Unknown',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  if (lec['department'] != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.business, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(lec['department'], style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  const SizedBox(height: 2),
                                  if (lec['faculty'] != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.school, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(lec['faculty'], style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    lec['email'] ?? '',
                                    style: TextStyle(color: Colors.blue[700], fontSize: 13),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
