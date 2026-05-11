import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController titleController = TextEditingController();

  List<dynamic> reminders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // 🔹 LOAD REMINDERS
  Future<void> loadReminders() async {
    setState(() => isLoading = true);

    final data = await ApiService.getReminders();

    setState(() {
      reminders = data;
      isLoading = false;
    });
  }

  // 🔹 SAVE REMINDER
  Future<void> saveReminder() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter reminder description")),
      );
      return;
    }

    final DateTime scheduledDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot set reminder in the past")),
      );
      return;
    }

    final String date =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    final String time =
        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

    final success = await ApiService.saveReminder(
      titleController.text.trim(),
      date,
      time,
    );

    if (success) {
      try {
        print("🔔 SCHEDULING NOTIFICATION...");
        await NotificationService.scheduleNotification(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          titleController.text.trim(),
          scheduledDateTime,
        );
        print("✅ NOTIFICATION SCHEDULED FOR: $scheduledDateTime");
      } catch (e) {
        print("❌ Notification scheduling failed: $e");
      }

      titleController.clear();
      setState(() {
        selectedDate = DateTime.now();
        selectedTime = TimeOfDay.now();
      });

      await Future.delayed(const Duration(milliseconds: 400));
      await loadReminders();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reminder saved and scheduled")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save reminder")),
      );
    }
  }

  // 🔹 DELETE REMINDER
  Future<void> deleteReminder(int id) async {
    final success = await ApiService.deleteReminder(id);

    if (success) {
      await loadReminders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reminder deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete reminder")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EDED),

      // 🔹 APP BAR WITH REFRESH ICON
      appBar: AppBar(
        title: const Text("Reminder"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.blue),
            onPressed: () async {
              await NotificationService.showInstantNotification("Notification is working!");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Test notification sent")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadReminders,
          ),
        ],
      ),

      // 🔹 BODY WITH PULL TO REFRESH
      body: RefreshIndicator(
        onRefresh: loadReminders,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📅 CALENDAR
              TableCalendar(
                focusedDay: selectedDate,
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                onDaySelected: (selected, focused) {
                  setState(() => selectedDate = selected);
                },
              ),

              const SizedBox(height: 12),

              // ⏰ TIME PICKER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    child: Text(selectedTime.format(context)),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 📝 DESCRIPTION
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Reminder description",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 💾 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    shape: const StadiumBorder(),
                  ),
                  onPressed: saveReminder,
                  child: const Text("Save Reminder"),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Your Reminders",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              // 🔄 Loading Indicator
              if (isLoading) const Center(child: CircularProgressIndicator()),

              if (!isLoading && reminders.isEmpty)
                const Text("No reminders yet"),

              if (!isLoading && reminders.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final r = reminders[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(r['title']),
                        subtitle: Text("${r['date']}  •  ${r['time']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteReminder(r['id']),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
