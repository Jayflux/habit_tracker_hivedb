import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker_hivedb/components/custom_drawer.dart';
import 'package:habit_tracker_hivedb/components/habit_tile.dart';
import 'package:habit_tracker_hivedb/components/month_summary.dart';
import 'package:habit_tracker_hivedb/components/my_alert_box.dart';
import 'package:habit_tracker_hivedb/components/my_fab.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/datetime/date_time.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  final String username;
  final int userId;

  const HomePage({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _newHabitNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  late Box<Habit> habitBox;
  List<Habit> todaysHabits = [];
  late final String boxName;

  @override
  void initState() {
    super.initState();
    boxName = 'habits_${widget.username}';
    openHabitBoxAndLoad();
  }

  Future<void> openHabitBoxAndLoad() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Habit>(boxName);
    }

    habitBox = Hive.box<Habit>(boxName);
    await loadHabits();
  }

  Future<void> loadHabits() async {
    final todayStr = convertDateTimeToString(DateTime.now());

    final allHabits = habitBox.values
        .where((habit) =>
            habit.username == widget.username && habit.date == todayStr)
        .toList();

    if (mounted) {
      setState(() {
        todaysHabits = allHabits;
        isLoading = false;
      });
    }
  }

  void checkBoxTapped(bool? value, int index) {
    final habit = todaysHabits[index];
    habit.completed = value ?? false;
    habit.save();
    setState(() {});
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
          hintText: "Enter Habit Name...",
        );
      },
    );
  }

  void saveNewHabit() {
    final name = _newHabitNameController.text.trim();
    if (name.isEmpty) return;

    final today = convertDateTimeToString(DateTime.now());
    final newHabit = Habit(
      name: name,
      completed: false,
      date: today,
      username: widget.username,
      userId: widget.userId,
    );

    habitBox.add(newHabit);

    setState(() {
      todaysHabits.add(newHabit);
    });

    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    _newHabitNameController.text = todaysHabits[index].name;
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
          hintText: todaysHabits[index].name,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    final name = _newHabitNameController.text.trim();
    if (name.isEmpty) return;

    final habit = todaysHabits[index];
    habit.name = name;
    habit.save();

    setState(() {});
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  void deleteHabit(int index) {
    final habit = todaysHabits[index];
    habit.delete();

    setState(() {
      todaysHabits.removeAt(index);
    });
  }

  Map<DateTime, int> generateHeatMapData() {
    final Map<DateTime, List<Habit>> groupedHabits = {};

    for (final habit in habitBox.values) {
      if (habit.username != widget.username) continue;

      final date = DateTime.parse(habit.date);
      groupedHabits.putIfAbsent(date, () => []);
      groupedHabits[date]!.add(habit);
    }

    final Map<DateTime, int> heatMapData = {};

    groupedHabits.forEach((date, habits) {
      final total = habits.length;
      final completed = habits.where((h) => h.completed).length;
      final percentage = total == 0 ? 0 : ((completed / total) * 10).round();

      heatMapData[date] = percentage;
    });

    return heatMapData;
  }

  @override
  void dispose() {
    if (Hive.isBoxOpen(boxName)) {
      Hive.box<Habit>(boxName).close();
    }
    _newHabitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    final completedCount = todaysHabits.where((h) => h.completed).length;
    final totalCount = todaysHabits.length;
    final completionRatio = totalCount == 0 ? 0.0 : completedCount / totalCount;

    final formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        username: widget.username,
        userId: widget.userId,
      ),
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Open navigation menu',
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Habit Tracker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
              ),
            )
          : SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppTheme.maxContentWidth,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                    children: [
                      // Focal Point: Today's Progress Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Daily Progress',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                Text(
                                  '$completedCount of $totalCount completed',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppTheme.logoOrange : AppTheme.logoOrangeDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: completionRatio,
                                minHeight: 8,
                                backgroundColor: isDark
                                    ? AppTheme.darkSurfaceElevated
                                    : AppTheme.lightSurfaceElevated,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Monthly Heatmap Overview
                      MonthlySummary(
                        datasets: generateHeatMapData(),
                        startDate: convertDateTimeToString(DateTime.now()),
                      ),

                      const SizedBox(height: 22),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Habits',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Swipe right to manage',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Habits List or Empty State (R-27)
                      if (todaysHabits.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rtl_rounded,
                                size: 40,
                                color: isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No habits scheduled for today',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Build momentum one day at a time. Add your first habit for today.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),
                              OutlinedButton.icon(
                                onPressed: createNewHabit,
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add First Habit'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
                                  side: BorderSide(
                                    color: isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todaysHabits.length,
                          itemBuilder: (context, index) {
                            final habit = todaysHabits[index];
                            return HabitTile(
                              habitName: habit.name,
                              habitCompleted: habit.completed,
                              onChanged: (value) => checkBoxTapped(value, index),
                              settingsTapped: (context) => openHabitSettings(index),
                              deleteTapped: (context) => deleteHabit(index),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
