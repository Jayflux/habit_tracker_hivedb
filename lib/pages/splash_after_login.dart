import 'package:flutter/material.dart';
import 'package:habit_tracker_hivedb/pages/home_page.dart';

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
    await Future.delayed(const Duration(seconds: 3));
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
    return Scaffold(
      backgroundColor: const Color(0xFF195497),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/habit2.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome\n${widget.username}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
