import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setupApp();
  }

  Future<void> setupApp() async {
    // Pastikan box users dibuka
    var userBox = await Hive.openBox<AppUser>('users');

    // Tambahkan admin jika belum ada
    final adminExists = userBox.values.any(
      (user) => user.username == 'admin' && user.role == 'admin',
    );

    if (!adminExists) {
      debugPrint('Menambahkan user admin...');
      await userBox.add(AppUser(
        username: 'admin',
        email: 'admin@gmail.com',
        phoneNumber: '1234567890',
        fullName: 'Admin User',
        password: 'admin123',
        startDate: DateTime.now(),
        role: 'admin',
      ));
    }

    // Delay untuk splash (2 detik)
    await Future.delayed(const Duration(seconds: 2));

    // Navigasi ke onboarding
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/habit.png'),
              width: 100,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
