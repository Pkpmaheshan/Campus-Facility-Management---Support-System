import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'batch_students_page.dart';
import 'problem_page.dart';
import 'students_page.dart';
import 'lecturers_page.dart';
import 'add_user_page.dart';
import 'batch_management_page.dart';
import 'academic_management_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalStudents = 0;
  int totalLecturers = 0;
  int totalBatches = 0;
  int totalFaculties = 0;
  List batches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final batchRes = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/batches"),
      );
      final userRes = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/admin/users"),
      );
      final academicRes = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/academic/all"),
      );

      print("Batches Status: ${batchRes.statusCode}");
      print("Users Status: ${userRes.statusCode}");
      print("Academic Status: ${academicRes.statusCode}");

      if (batchRes.statusCode == 200 &&
          userRes.statusCode == 200 &&
          academicRes.statusCode == 200) {
        final userData = json.decode(userRes.body);
        final academicData = json.decode(academicRes.body);

        setState(() {
          batches = json.decode(batchRes.body);
          totalBatches = batches.length;
          totalStudents = (userData['students'] as List).length;
          totalLecturers = (userData['lecturers'] as List).length;
          totalFaculties = (academicData['faculties'] as List).length;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("One or more API calls failed with non-200 status.");
      }
    } catch (e) {
      print("Dashboard load error: $e");
      setState(() => isLoading = false);
    }
  }

  // Sidebar state
  String _activePage = "Dashboard";

  void _navigateTo(String pageName, Widget page) async {
    setState(() => _activePage = pageName);
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    loadDashboardData(); // Refresh stats when returning
    setState(() => _activePage = "Dashboard");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Row(
        children: [
          // SIDEBAR
          _buildSidebar(context),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: loadDashboardData,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Dashboard Overview",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // STAT CARDS
                                _buildStatCards(),

                                const SizedBox(height: 40),

                                // BATCHES SECTION
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recent Batches",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _showCreateBatchDialog,
                                      icon: const Icon(Icons.add),
                                      label: const Text("Create New Batch"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildBatchGrid(),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFF1B5E20), // Dark NSBM Green
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.school, size: 60, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            "NSBM ADMIN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildSidebarItem(
            Icons.dashboard,
            "Dashboard",
            _activePage == "Dashboard",
            () {
              setState(() => _activePage = "Dashboard");
            },
          ),
          _buildSidebarItem(
            Icons.groups,
            "Batches",
            _activePage == "Batches",
            () {
              _navigateTo("Batches", BatchManagementPage());
            },
          ),
          _buildSidebarItem(
            Icons.account_balance,
            "Academic",
            _activePage == "Academic",
            () {
              _navigateTo("Academic", const AcademicManagementPage());
            },
          ),
          _buildSidebarItem(
            Icons.person,
            "Students",
            _activePage == "Students",
            () {
              _navigateTo("Students", const StudentsPage());
            },
          ),
          _buildSidebarItem(
            Icons.assignment_ind,
            "Lecturers",
            _activePage == "Lecturers",
            () {
              _navigateTo("Lecturers", const LecturersPage());
            },
          ),
          _buildSidebarItem(
            Icons.report_problem,
            "Requests",
            _activePage == "Requests",
            () {
              _navigateTo("Requests", AdminProblemReportsPage());
            },
          ),
          const Spacer(),
          _buildSidebarItem(Icons.logout, "Logout", false, () {}),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String title,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Welcome back, Administrator",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _navigateTo(
                  "Students",
                  AddUserPage(initialRole: 'student'),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Add Student"),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _buildStatCard(
          "Total Students",
          totalStudents.toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          "Total Lecturers",
          totalLecturers.toString(),
          Icons.school,
          Colors.orange,
        ),
        _buildStatCard(
          "Active Batches",
          totalBatches.toString(),
          Icons.groups,
          Colors.green,
        ),
        _buildStatCard(
          "Faculties",
          totalFaculties.toString(),
          Icons.account_balance,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final b = batches[index];
        return HoverBatchCard(batchName: b['batch']);
      },
    );
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
            labelText: "Batch Name (e.g. 23.1)",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await http.post(
                Uri.parse("http://127.0.0.1:8000/api/create-batch"),
                body: {'batch': controller.text},
              );
              Navigator.pop(context);
              loadDashboardData();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}

class HoverBatchCard extends StatefulWidget {
  final String batchName;
  const HoverBatchCard({super.key, required this.batchName});

  @override
  State<HoverBatchCard> createState() => _HoverBatchCardState();
}

class _HoverBatchCardState extends State<HoverBatchCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BatchStudentsPage(batch: widget.batchName),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isHovered ? Colors.green[50] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isHovered ? Colors.green : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                size: 40,
                color: isHovered ? Colors.green : Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                widget.batchName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Batch Group",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
