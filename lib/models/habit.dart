import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  String date;

  @HiveField(3)
  String username;

  @HiveField(4)
  int userId; // 🔥 Tambahkan ini!

  Habit({
    required this.name,
    required this.completed,
    required this.date,
    required this.username,
    required this.userId,
  });
}
