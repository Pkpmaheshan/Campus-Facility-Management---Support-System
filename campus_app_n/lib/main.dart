import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // 🔔 Initialize Notifications
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  // 🔥 LOAD SAVED THEME
  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool("darkMode") ?? false;
    });
  }

  // 🔥 CHANGE THEME
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !isDark;
    await prefs.setBool("darkMode", newValue);

    setState(() {
      isDark = newValue;
    });
  }

  // 🔥 KEEP YOUR LOGIN LOGIC
  Future<Widget> getStartScreen() async {
    final token = await ApiService.getToken();

    if (token != null) {
      return LoginScreen(); // later change to HomePage
    }

    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Campus App",

      // ✅ LIGHT + DARK THEME
      theme: AppStyles.getLightTheme(),
      darkTheme: AppStyles.getDarkTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      home: FutureBuilder<Widget>(
        future: getStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Error loading app")),
            );
          }

          return snapshot.data ?? LoginScreen();
        },
      ),
    );
  }
}
