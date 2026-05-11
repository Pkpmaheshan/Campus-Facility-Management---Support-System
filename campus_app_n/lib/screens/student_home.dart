import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'problem_report.dart';
import 'profile.dart';
import 'reminder_page.dart';
import 'notifications_page.dart';
import 'lost_found_list.dart';
import 'lecturer_search.dart';
import '../services/api_service.dart';
import 'time_table.dart';
import 'settings_page.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final TextEditingController feedbackController = TextEditingController();
  final PageController _pageController = PageController();
  String batchNumber = "23.1";
  String userName = "Student";
  int _currentPage = 0;
  Timer? _timer;

  final List<String> banners = [
    "assets/images/banner1.png",
    "assets/images/banner2.png",
    "assets/images/banner3.png",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      batchNumber = prefs.getString("batch_number") ?? "23.1";
      userName = prefs.getString("name") ?? "Student";
    });
  }

  @override
  void dispose() {
    feedbackController.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          /// --- MODERN APP BAR ---
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.primaryGreen,
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                height: 38,
                fit: BoxFit.contain,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.mainGradient,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage())),
              ),
              IconButton(
                icon: const Icon(Icons.person_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- GREETING SECTION ---
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: AppStyles.headerRadius,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.accentGold.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 35, color: AppColors.accentGold),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_getGreeting()},",
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// --- EVENTS CAROUSEL ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("University Events", style: AppStyles.heading),
                      TextButton(onPressed: () {}, child: const Text("See All")),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int index) => setState(() => _currentPage = index),
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          image: DecorationImage(
                            image: AssetImage(banners[index]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: AppStyles.softShadow,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(banners.length, (index) => _buildIndicator(index)),
                ),

                const SizedBox(height: 24),

                /// --- FEATURE GRID ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Quick Services", style: AppStyles.heading),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildFeatureCard(
                      context,
                      title: "Lost & Found",
                      icon: Icons.inventory_2_outlined,
                      color: Colors.green,
                      page: const LostFoundPage(),
                    ),
                    _buildFeatureCard(
                      context,
                      title: "Problem",
                      icon: Icons.report_problem_outlined,
                      color: Colors.red,
                      page: const ProblemReportScreen(),
                    ),
                    _buildFeatureCard(
                      context,
                      title: "Table",
                      icon: Icons.calendar_month_outlined,
                      color: Colors.blue,
                      page: TimeTablePage(batch: batchNumber),
                    ),
                    _buildFeatureCard(
                      context,
                      title: "Reminders",
                      icon: Icons.alarm_on_outlined,
                      color: Colors.orange,
                      page: const ReminderPage(),
                    ),
                    _buildFeatureCard(
                      context,
                      title: "Lecturers",
                      icon: Icons.people_outlined,
                      color: Colors.purple,
                      page: const LecturerSearchScreen(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// --- FEEDBACK SECTION ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: AppStyles.cardRadius,
                      boxShadow: AppStyles.softShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.feedback_outlined, color: AppColors.primaryGreen),
                            SizedBox(width: 8),
                            Text("Your Feedback", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: feedbackController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "How can we improve your experience?",
                            filled: true,
                            fillColor: theme.brightness == Brightness.light ? AppColors.softGrey : Colors.white10,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _submitFeedback,
                            child: const Text("Submit Feedback", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final theme = Theme.of(context);
    return Container(
      width: _currentPage == index ? 20 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: _currentPage == index ? AppColors.primaryGreen : (theme.brightness == Brightness.light ? Colors.grey[300] : Colors.white24),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {required String title, required IconData icon, required Color color, required Widget page}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppStyles.softShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: theme.brightness == Brightness.light ? AppColors.darkGrey : Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    if (feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter feedback")));
      return;
    }
    final success = await ApiService.submitFeedback(feedbackController.text.trim());
    if (success) {
      feedbackController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback submitted")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to submit feedback")));
    }
  }
}
