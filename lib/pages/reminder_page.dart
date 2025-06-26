import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/datetime/date_time.dart';
import 'package:intl/intl.dart';

class ReminderPage extends StatefulWidget {
  final String username;

  const ReminderPage({super.key, required this.username});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  Map<String, List<String>> reminderData = {};
  late Box<Habit> habitBox;

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  Future<void> loadReminders() async {
    final boxName = 'habits_${widget.username}';
    if (!Hive.isBoxOpen(boxName)) {
      habitBox = await Hive.openBox<Habit>(boxName);
    } else {
      habitBox = Hive.box<Habit>(boxName);
    }

    final todayStr = convertDateTimeToString(DateTime.now());
    final tomorrowStr =
        convertDateTimeToString(DateTime.now().add(const Duration(days: 1)));

    // Habit yang belum dikerjakan hari ini
    final incompleteToday = habitBox.values
        .where((habit) => habit.date == todayStr && habit.completed == false)
        .map((habit) => habit.name)
        .toList();

    // Semua habit milik user (tanpa melihat tanggal)
    final allUserHabits = habitBox.values
        .map((habit) => habit.name)
        .toSet()
        .toList(); // gunakan toSet untuk menghindari duplikat

    setState(() {
      reminderData = {
        'Today - ${formatDateLabel(DateTime.now())}': incompleteToday,
        'Tomorrow - ${formatDateLabel(DateTime.now().add(const Duration(days: 1)))}':
            allUserHabits,
      };
    });
  }

  String formatDateLabel(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Reminders', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF174E8F)],
          ),
        ),
        child: reminderData.isEmpty
            ? const Center(
                child: Text('No pending habits.',
                    style: TextStyle(color: Colors.white)),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                children: reminderData.entries.map((entry) {
                  final label = entry.key;
                  final habits = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Column(
                          children: habits.map((habit) {
                            return Row(
                              children: [
                                const Icon(Icons.check_box_outline_blank,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    habit,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
      ),
    );
  }
}
