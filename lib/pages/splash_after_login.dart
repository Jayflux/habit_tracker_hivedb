import 'package:flutter/material.dart';
import 'package:habit_tracker_hivedb/pages/home_page.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class SplashAfterLoginPage extends StatefulWidget {
  final String username;
  final int userId;

  const SplashAfterLoginPage({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<SplashAfterLoginPage> createState() => _SplashAfterLoginPageState();
}

class _SplashAfterLoginPageState extends State<SplashAfterLoginPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          username: widget.username,
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/habit2.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome back, ${widget.username}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Loading your routine schedule...',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
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
