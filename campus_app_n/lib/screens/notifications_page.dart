import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<dynamic>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = ApiService.getNotifications();
  }

  Future<void> refreshNotifications() async {
    setState(() {
      notificationsFuture = ApiService.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDED),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Failed to load notifications"),
            );
          }

          final notifications = snapshot.data ?? [];

          // 📭 Empty state
          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // 📋 Notification list
          return RefreshIndicator(
            onRefresh: refreshNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                final bool isRead = n['is_read'] == true;

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: isRead ? Colors.grey : Colors.red,
                    ),
                    title: Text(
                      n['title'],
                      style: TextStyle(
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(n['body']),
                    trailing:
                        isRead ? null : const Icon(Icons.circle, size: 10),
                    onTap: () async {
                      // 🔕 Mark as read
                      await ApiService.markNotificationRead(n['id']);
                      refreshNotifications();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
