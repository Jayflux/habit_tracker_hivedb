// lib/data/habit_database_hive.dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:habit_tracker_hivedb/models/habit.dart';
import 'package:habit_tracker_hivedb/models/user.dart';

class HabitDatabaseHive {
  static const String userBoxName = 'users';
  static const String habitBoxPrefix = 'habits_'; // e.g. habits_juan

  static bool _isInitialized = false;

  Future<void> initHive() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AppUserAdapter());
    }

    await Hive.openBox<AppUser>(userBoxName);
    _isInitialized = true;
  }

  // ================= USER =================

  Future<AppUser?> login(String username, String password) async {
    final box = Hive.box<AppUser>(userBoxName);
    try {
      return box.values.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> register(AppUser user) async {
    final box = Hive.box<AppUser>(userBoxName);
    final exists = box.values.any((u) => u.username == user.username);
    if (exists) return false;

    await box.add(user);
    await Hive.openBox<Habit>('${habitBoxPrefix}${user.username}');
    return true;
  }

  // ================= HABITS =================

  Future<List<Habit>> loadHabits(String username, DateTime date) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    return habitBox.values.where((h) {
      final hDate = DateTime.parse(h.date);
      return hDate.year == date.year &&
          hDate.month == date.month &&
          hDate.day == date.day;
    }).toList();
  }

  Future<void> addHabit(String username, Habit habit) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    await habitBox.add(habit);
  }

  Future<void> updateHabit(
      String username, int index, Habit updatedHabit) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    await habitBox.putAt(index, updatedHabit);
  }

  Future<void> deleteHabit(String username, int index) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    await habitBox.deleteAt(index);
  }

  Future<Map<String, List<Habit>>> getHabitHistory(String username) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    Map<String, List<Habit>> history = {};

    for (Habit h in habitBox.values) {
      final key = h.date.substring(0, 10); // yyyy-MM-dd
      history.putIfAbsent(key, () => []).add(h);
    }

    return history;
  }

  Future<Map<String, List<Habit>>> getReminders(String username) async {
    final habitBox = await Hive.openBox<Habit>('${habitBoxPrefix}$username');
    Map<String, List<Habit>> reminders = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    reminders['Today'] = habitBox.values.where((h) {
      final d = DateTime.parse(h.date);
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day &&
          !h.completed;
    }).toList();

    reminders['Tomorrow'] = habitBox.values.where((h) {
      final d = DateTime.parse(h.date);
      return d.year == tomorrow.year &&
          d.month == tomorrow.month &&
          d.day == tomorrow.day;
    }).toList();

    return reminders;
  }
}
