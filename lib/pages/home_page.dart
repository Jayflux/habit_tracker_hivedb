import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/components/custom_drawer.dart';
import 'package:habit_tracker_hivedb/components/habit_tile.dart';
import 'package:habit_tracker_hivedb/components/month_summary.dart';
import 'package:habit_tracker_hivedb/components/my_alert_box.dart';
import 'package:habit_tracker_hivedb/components/my_fab.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/datetime/date_time.dart';

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
      Hive.box<Habit>(boxName).close(); // pastikan box ditutup saat keluar
    }
    _newHabitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        username: widget.username,
        userId: widget.userId,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: MyFloatingActionButton(onPressed: createNewHabit),
      ),
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
            : SafeArea(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 8),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 80),
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Weekly Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            MonthlySummary(
                              datasets: generateHeatMapData(),
                              startDate:
                                  convertDateTimeToString(DateTime.now()),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Today\'s Habits',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: todaysHabits.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                final habit = todaysHabits[index];
                                return HabitTile(
                                  habitName: habit.name,
                                  habitCompleted: habit.completed,
                                  onChanged: (value) =>
                                      checkBoxTapped(value, index),
                                  settingsTapped: (context) =>
                                      openHabitSettings(index),
                                  deleteTapped: (context) => deleteHabit(index),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
