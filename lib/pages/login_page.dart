import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/home_page.dart';
import 'package:habit_tracker_hivedb/pages/register_page.dart';
import 'package:habit_tracker_hivedb/pages/admin/admin_home_page.dart';
import 'package:habit_tracker_hivedb/components/my_button.dart';
import 'package:habit_tracker_hivedb/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all fields');
      return;
    }

    try {
      // Pastikan box sudah terbuka
      if (!Hive.isBoxOpen('users')) {
        await Hive.openBox<AppUser>('users');
      }

      final userBox = Hive.box<AppUser>('users');

      print('DEBUG: Total users = ${userBox.length}');
      for (var u in userBox.values) {
        print('User: ${u.username}, Role: ${u.role}');
      }

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
        Fluttertoast.showToast(msg: 'Invalid credentials');
        return;
      }

      // Temukan key (id) pengguna dari Hive
      final userKey = userBox.keys.firstWhere(
        (key) => userBox.get(key) == matchedUser,
        orElse: () => null,
      );

      // Navigasi berdasarkan role
      if (matchedUser.role.toLowerCase() == 'admin') {
        debugPrint('LOGIN: Berhasil sebagai admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomePage()),
        );
      } else {
        debugPrint('LOGIN: Berhasil sebagai user ${matchedUser.username}');
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
      debugPrint('ERROR saat login: $e');
      Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/habit.png', height: 120),
              const SizedBox(height: 30),
              Text(
                'Welcome Back!',
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
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () => loginUser(context),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
