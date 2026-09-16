import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';
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

    if (mounted) {
      setState(() {
        habitHistory = Map.fromEntries(sortedEntries);
        isLoading = false;
      });
    }
  }

  String formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('EEEE, d MMMM yyyy').format(parsed);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Streaks'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
              ),
            )
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppTheme.maxContentWidth,
                  ),
                  child: habitHistory.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history_toggle_off,
                                  size: 48,
                                  color: textSecondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No History Recorded Yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Completed habits will appear here organized by date.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          children: habitHistory.entries.map((entry) {
                            final dateLabel = formatDate(entry.key);
                            final habits = entry.value;
                            final completedCount = habits.where((h) => h.completed).length;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                                border: Border.all(color: borderColor, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dateLabel,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                          ),
                                        ),
                                        Text(
                                          '$completedCount of ${habits.length}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1, color: borderColor),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: habits.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 1, indent: 16, endIndent: 16, color: borderColor.withValues(alpha: 0.5)),
                                    itemBuilder: (context, index) {
                                      final habit = habits[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              habit.completed
                                                  ? Icons.check_circle
                                                  : Icons.radio_button_unchecked,
                                              size: 18,
                                              color: habit.completed
                                                  ? (isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark)
                                                  : textSecondary,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                habit.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: habit.completed ? textPrimary : textSecondary,
                                                  decoration: habit.completed
                                                      ? TextDecoration.none
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ),
    );
  }
}
