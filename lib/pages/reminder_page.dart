import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/datetime/date_time.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';
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
  bool isLoading = true;

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

    // Habits not completed today
    final incompleteToday = habitBox.values
        .where((habit) => habit.date == todayStr && habit.completed == false)
        .map((habit) => habit.name)
        .toList();

    // All distinct habits for user
    final allUserHabits = habitBox.values
        .map((habit) => habit.name)
        .toSet()
        .toList();

    if (mounted) {
      setState(() {
        reminderData = {
          'Pending Today (${formatDateLabel(DateTime.now())})': incompleteToday,
          'Tomorrow Schedule (${formatDateLabel(DateTime.now().add(const Duration(days: 1)))})':
              allUserHabits,
        };
        isLoading = false;
      });
    }
  }

  String formatDateLabel(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    final hasAnyReminders = reminderData.values.any((list) => list.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Reminders'),
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
                  child: !hasAnyReminders
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_off_outlined,
                                  size: 48,
                                  color: textSecondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'All Caught Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'No pending habits for today. Excellent consistency.',
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
                          children: reminderData.entries.map((entry) {
                            final label = entry.key;
                            final habits = entry.value;

                            if (habits.isEmpty) {
                              return const SizedBox.shrink();
                            }

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
                                      children: [
                                        Icon(
                                          Icons.alarm,
                                          size: 16,
                                          color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: textPrimary,
                                            ),
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
                                              Icons.radio_button_unchecked,
                                              size: 18,
                                              color: textSecondary,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                habit,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: textPrimary,
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
