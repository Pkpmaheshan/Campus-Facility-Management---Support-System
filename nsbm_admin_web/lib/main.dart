import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NSBM Admin Panel',
      home: DashboardPage(),
    );
  }
}
