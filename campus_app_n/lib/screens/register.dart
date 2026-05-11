import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final campusIdController = TextEditingController();

  String role = "student";
  String faculty = "Computing Faculty";
  String department = "";
  String degree = "";
  String batchNumber = "23.1";
  bool loading = false;

  final batchNumbers = ["23.1", "23.2", "24.1", "24.2"];

  final faculties = [
    "Computing Faculty",
    "Business Management Faculty",
    "Engineering Faculty",
    "Law Faculty",
    "Medicine Faculty",
  ];

  final Map<String, List<String>> facultyDepartments = {
    "Computing Faculty": [
      "Department of Software Engineering",
      "Department of Computer and Data Science",
      "Department of Computer Security",
    ],
    "Business Management Faculty": [
      "Department of Management",
      "Department of Accounting and Finance",
      "Department of Marketing and Tourism",
      "Department of Operations and Logistics",
    ],
    "Engineering Faculty": [
      "Department of Electrical, Electronic & Systems Engineering",
      "Department of Design Studies",
      "Department of Mechatronic and Industrial Engineering",
    ],
    "Law Faculty": ["Department of Legal Studies"],
    "Medicine Faculty": ["Department of Medicine"],
  };

  final Map<String, List<String>> departmentDegrees = {
    "Department of Software Engineering": [
      "BSc (Hons) Software Engineering – Plymouth University (UK)",
      "BSc (Hons) Software Engineering – NSBM",
      "Foundation Programme for Bachelor’s Degree",
    ],
    "Department of Computer and Data Science": [
      "BSc (Hons) Data Science – NSBM",
      "BSc (Hons) Computer Science – Plymouth University (UK)",
    ],
    "Department of Management": [
      "Foundation Programme for Bachelor’s Degree",
      "BM (Hons) International Business – NSBM",
    ],
    "Department of Accounting and Finance": [
      "BM (Hons) Accounting and Finance – NSBM",
    ],
    "Department of Marketing and Tourism": [
      "BM (Hons) Marketing Management – NSBM",
    ],
    "Department of Operations and Logistics": [
      "BSc Business Management – NSBM",
    ],
    "Department of Electrical, Electronic & Systems Engineering": [
      "BSc Engineering (Hons) Electrical – NSBM",
    ],
    "Department of Design Studies": ["Bachelor of Interior Design – NSBM"],
    "Department of Mechatronic and Industrial Engineering": [
      "BSc Engineering (Hons) Mechatronic – NSBM"
    ],
  };

  @override
  void initState() {
    super.initState();
    department = facultyDepartments[faculty]!.first;
    degree = departmentDegrees[department]!.first;
  }

  void register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all basic fields")));
      return;
    }

    setState(() => loading = true);
    final response = await ApiService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      role,
      role == "student" ? department : null,
      role == "student" ? faculty : null,
      role == "student" ? degree : null,
      role == "student" ? campusIdController.text.trim() : null,
      role == "student" ? batchNumber : null,
    );
    setState(() => loading = false);

    if (response != null && response['token'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered successfully")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        title: const Text("Create Account",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// --- STEP 1: ACCOUNT INFO ---
            _buildSection(
              title: "Basic Information",
              icon: Icons.person_outlined,
              children: [
                _buildField("Full Name", nameController, Icons.person_outlined),
                _buildField(
                    "Email Address", emailController, Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                _buildField("Password", passwordController, Icons.lock_outlined,
                    isPassword: true),
                _buildDropdown("Role", role, ["student", "lecturer"],
                    (v) => setState(() => role = v)),
              ],
            ),

            const SizedBox(height: 24),

            /// --- STEP 2: STUDENT DETAILS (IF STUDENT) ---
            if (role == "student")
              _buildSection(
                title: "Academic Details",
                icon: Icons.school_outlined,
                children: [
                  _buildDropdown("Faculty", faculty, faculties, (v) {
                    setState(() {
                      faculty = v;
                      department = facultyDepartments[faculty]!.first;
                      degree = departmentDegrees[department]!.first;
                    });
                  }),
                  _buildDropdown(
                      "Department", department, facultyDepartments[faculty]!,
                      (v) {
                    setState(() {
                      department = v;
                      degree = departmentDegrees[department]!.first;
                    });
                  }),
                  _buildDropdown(
                      "Degree Program",
                      degree,
                      departmentDegrees[department]!,
                      (v) => setState(() => degree = v)),
                  _buildField(
                      "Campus ID", campusIdController, Icons.badge_outlined),
                  _buildDropdown("Batch Number", batchNumber, batchNumbers,
                      (v) => setState(() => batchNumber = v)),
                ],
              ),

            const SizedBox(height: 40),

            /// --- REGISTER BUTTON ---
            loading
                ? const CircularProgressIndicator(color: AppColors.primaryGreen)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: register,
                      child: const Text("COMPLETE REGISTRATION",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.cardRadius,
        boxShadow: AppStyles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController c, IconData icon,
      {bool isPassword = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: c,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: AppColors.softGrey,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: items.contains(value) ? value : items.first,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.softGrey,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
        items: items
            .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}
