import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/components/my_button.dart';
import 'package:habit_tracker_hivedb/components/my_textfield.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fullNameController = TextEditingController();
  bool isRegistering = false;

  void registerUser() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final fullName = fullNameController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phoneNumber.isEmpty ||
        fullName.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address');
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(msg: 'Password should be at least 6 characters');
      return;
    }

    setState(() => isRegistering = true);

    try {
      if (!Hive.isBoxOpen('users')) {
        await Hive.openBox<AppUser>('users');
      }
      final userBox = Hive.box<AppUser>('users');

      final existingUser =
          userBox.values.any((user) => user.username == username);
      if (existingUser) {
        Fluttertoast.showToast(msg: 'Username is already taken');
        setState(() => isRegistering = false);
        return;
      }

      final newUser = AppUser(
        username: username,
        password: password,
        startDate: DateTime.now(),
        email: email,
        phoneNumber: phoneNumber,
        fullName: fullName,
        role: 'user',
      );

      await userBox.add(newUser);

      Fluttertoast.showToast(msg: 'Account created successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Registration failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => isRegistering = false);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Get Started with Your Daily Routines',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create your profile to save and sync your habits.',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  MyTextField(
                    controller: fullNameController,
                    hintText: 'Full Name',
                    obscureText: false,
                    prefixIcon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    controller: emailController,
                    hintText: 'Email Address',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    controller: phoneNumberController,
                    hintText: 'Phone Number',
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 12),

                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => registerUser(),
                  ),
                  const SizedBox(height: 24),

                  MyButton(
                    onTap: isRegistering ? null : registerUser,
                    text: isRegistering ? 'Creating Account...' : 'Create Account',
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: textSecondary, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Sign In',
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
