import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/home_page.dart';
import 'package:habit_tracker_hivedb/pages/register_page.dart';
import 'package:habit_tracker_hivedb/pages/admin/admin_home_page.dart';
import 'package:habit_tracker_hivedb/components/my_button.dart';
import 'package:habit_tracker_hivedb/components/my_textfield.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSubmitting = false;

  void loginUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in your username and password');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      if (!Hive.isBoxOpen('users')) {
        await Hive.openBox<AppUser>('users');
      }

      final userBox = Hive.box<AppUser>('users');

      final matchedUser = userBox.values.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => AppUser(
          username: '',
          password: '',
          startDate: DateTime.now(),
          role: '',
          email: '',
          phoneNumber: '',
          fullName: '',
        ),
      );

      if (matchedUser.username.isEmpty) {
        Fluttertoast.showToast(msg: 'Invalid username or password');
        setState(() => isSubmitting = false);
        return;
      }

      final userKey = userBox.keys.firstWhere(
        (key) => userBox.get(key) == matchedUser,
        orElse: () => null,
      );

      if (!mounted) return;

      if (matchedUser.role.toLowerCase() == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              username: matchedUser.username,
              userId: userKey ?? 0,
            ),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unable to sign in. Please try again.');
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/habit.png',
                        height: 96,
                        width: 96,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurfaceElevated : AppTheme.lightSurfaceElevated,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 44,
                            color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to Habit Tracker',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to review and keep your routines on track.',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Username Field
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),

                  // Password Field
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => loginUser(),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  MyButton(
                    onTap: isSubmitting ? null : loginUser,
                    text: isSubmitting ? 'Signing In...' : 'Sign In',
                  ),
                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
