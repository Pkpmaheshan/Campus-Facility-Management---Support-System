import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUserPage extends StatefulWidget {
  final String initialRole;
  final Map? user; // Optional user for editing

  const AddUserPage({super.key, required this.initialRole, this.user});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _campusIdController = TextEditingController();

  late String _selectedRole;
  String? _selectedBatch;
  String? _selectedFaculty;
  String? _selectedDepartment;
  String? _selectedDegree;

  List _batches = [];
  List _faculties = [];
  List _departments = [];
  List _degrees = [];
  bool _isLoading = true;
  bool _isSaving = false;

  bool get isEditMode => widget.user != null;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;

    if (isEditMode) {
      _nameController.text = widget.user!['name'] ?? '';
      _emailController.text = widget.user!['email'] ?? '';
      _campusIdController.text = widget.user!['campus_id'] ?? '';
      _selectedRole = widget.user!['role'] ?? widget.initialRole;
      // Dropdown values will be set after loading data in _loadAllData
    }

    _loadAllData();
  }

  String? _safeValue(String? value, List items, {bool isBatch = false}) {
    if (value == null) return null;
    final exists = items.any((i) {
      final name = isBatch ? i['batch'].toString() : i['name'].toString();
      return name == value;
    });
    return exists ? value : null;
  }

  Future<void> _loadAllData() async {
    try {
      final batchRes = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/batches"),
      );
      final academicRes = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/academic/all"),
      );

      if (batchRes.statusCode == 200 && academicRes.statusCode == 200) {
        final academicData = json.decode(academicRes.body);
        setState(() {
          _batches = json.decode(batchRes.body);
          _faculties = academicData['faculties'];
          _departments = academicData['departments'];
          _degrees = academicData['degrees'];

          if (isEditMode) {
            _selectedFaculty = _safeValue(widget.user!['faculty'], _faculties);
            _selectedDepartment = _safeValue(
              widget.user!['department'],
              _departments,
            );
            _selectedDegree = _safeValue(widget.user!['degree'], _degrees);
            _selectedBatch = _safeValue(
              widget.user!['batch_number'],
              _batches,
              isBatch: true,
            );
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final url = isEditMode
          ? "http://127.0.0.1:8000/api/admin/users/${widget.user!['id']}"
          : "http://127.0.0.1:8000/api/admin/add-user";

      final method = isEditMode ? http.put : http.post;

      final response = await method(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text.isEmpty
              ? null
              : _passwordController.text,
          'role': _selectedRole,
          'batch_number': _selectedRole == 'student' ? _selectedBatch : null,
          'campus_id': _campusIdController.text,
          'faculty': _selectedFaculty,
          'department': _selectedDepartment,
          'degree': _selectedDegree,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? "User updated successfully!"
                    : "User created successfully!",
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        final error = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${error['message'] ?? 'Failed'}")),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: Text(
          isEditMode
              ? "Edit User Account"
              : "Add New ${_selectedRole[0].toUpperCase()}${_selectedRole.substring(1)}",
        ),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Container(
                  width: 700,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditMode
                              ? "Edit ${widget.user!['name']}"
                              : "Register ${_selectedRole.toUpperCase()}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                "Full Name",
                                _nameController,
                                Icons.person,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildTextField(
                                "Email Address",
                                _emailController,
                                Icons.email,
                                isEmail: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                isEditMode
                                    ? "New Password (Leave blank to keep current)"
                                    : "Password",
                                _passwordController,
                                Icons.lock,
                                isPassword: true,
                                required: !isEditMode,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildTextField(
                                "Campus ID",
                                _campusIdController,
                                Icons.badge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          "Academic Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                "Faculty",
                                _selectedFaculty,
                                _faculties,
                                (v) => setState(() => _selectedFaculty = v),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildDropdown(
                                "Department",
                                _selectedDepartment,
                                _departments,
                                (v) => setState(() => _selectedDepartment = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            if (_selectedRole == 'student')
                              Expanded(
                                child: _buildDropdown(
                                  "Degree Program",
                                  _selectedDegree,
                                  _degrees,
                                  (v) => setState(() => _selectedDegree = v),
                                ),
                              ),
                            if (_selectedRole == 'student')
                              const SizedBox(width: 20),
                            if (_selectedRole == 'student')
                              Expanded(
                                child: _buildDropdown(
                                  "Batch Number",
                                  _selectedBatch,
                                  _batches,
                                  (v) => setState(() => _selectedBatch = v),
                                  isBatch: true,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _isSaving ? null : _saveUser,
                            child: _isSaving
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    isEditMode
                                        ? "Save Changes"
                                        : "Create User Account",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List items,
    Function(String?) onChanged, {
    bool isBatch = false,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(isBatch ? Icons.groups : Icons.school_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((i) {
        String name = isBatch ? i['batch'].toString() : i['name'].toString();
        return DropdownMenuItem<String>(value: name, child: Text(name));
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
    bool isEmail = false,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (v) {
        if (!required) return null;
        if (v == null || v.isEmpty) return "Required";
        return null;
      },
    );
  }
}
