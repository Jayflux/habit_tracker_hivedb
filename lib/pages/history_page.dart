import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final String username;

  const HistoryPage({super.key, required this.username});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Box<Habit> habitBox;
  Map<String, List<Habit>> habitHistory = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final boxName = 'habits_${widget.username}';
    if (!Hive.isBoxOpen(boxName)) {
      habitBox = await Hive.openBox<Habit>(boxName);
    } else {
      habitBox = Hive.box<Habit>(boxName);
    }

    final Map<String, List<Habit>> grouped = {};

    for (var habit
        in habitBox.values.where((h) => h.username == widget.username)) {
      grouped.putIfAbsent(habit.date, () => []).add(habit);
    }

    // Sort by date descending
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    setState(() {
      habitHistory = Map.fromEntries(sortedEntries);
      isLoading = false;
    });
  }

  String formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('EEEE, dd MMMM yyyy').format(parsed);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF174E8F)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : habitHistory.isEmpty
                ? const Center(
                    child: Text('No habit history.',
                        style: TextStyle(color: Colors.white)),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                    children: habitHistory.entries.map((entry) {
                      final date = formatDate(entry.key);
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
                              date,
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
                                    Icon(
                                      habit.completed
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: habit.completed
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        habit.name,
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
