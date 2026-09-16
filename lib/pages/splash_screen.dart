import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/onboarding_screen.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

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
    var userBox = await Hive.openBox<AppUser>('users');

    final adminExists = userBox.values.any(
      (user) => user.username == 'admin' && user.role == 'admin',
    );

    if (!adminExists) {
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

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/habit.png',
                width: 90,
                height: 90,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.eco_outlined,
                    size: 40,
                    color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Habit Tracker',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
