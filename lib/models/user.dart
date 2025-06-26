import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  String email;

  @HiveField(4)
  String phoneNumber;

  @HiveField(5)
  String fullName;

  @HiveField(6)
  String role; // 'admin' atau 'user'

  AppUser({
    required this.username,
    required this.password,
    required this.startDate,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
  });
}
