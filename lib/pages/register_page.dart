import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/components/my_button.dart';
import 'package:habit_tracker_hivedb/components/my_textfield.dart';
import 'package:habit_tracker_hivedb/models/user.dart';

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

  void registerUser(BuildContext context) async {
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
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email');
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    final userBox = Hive.box<AppUser>('users');

    final existingUser =
        userBox.values.any((user) => user.username == username);
    if (existingUser) {
      Fluttertoast.showToast(msg: 'Username already taken');
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

    Fluttertoast.showToast(msg: 'Registered successfully');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/habit.png', height: 100),
                      const SizedBox(height: 30),
                      Text(
                        'Create an account',
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: phoneNumberController,
                        hintText: 'Phone Number',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: fullNameController,
                        hintText: 'Full Name',
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 25),
                      MyButton(onTap: () => registerUser(context)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
