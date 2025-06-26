import 'package:flutter/material.dart';
import 'package:habit_tracker_hivedb/pages/about_page.dart';
import 'package:habit_tracker_hivedb/pages/history_page.dart';
import 'package:habit_tracker_hivedb/pages/reminder_page.dart';
import 'package:habit_tracker_hivedb/pages/login_page.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final int userId;

  const CustomDrawer({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              username,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            height: 30,
            color: Colors.white24,
          ),
          drawerItem(
            iconData: Icons.home,
            label: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          drawerItem(
            iconData: Icons.settings,
            label: 'Settings',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings coming soon!")),
              );
            },
          ),
          drawerItem(
            iconData: Icons.history,
            label: 'History',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(username: username),
                ),
              );
            },
          ),
          drawerItem(
            iconData: Icons.notifications,
            label: 'Reminder',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReminderPage(username: username),
                ),
              );
            },
          ),
          drawerItem(
            iconData: Icons.person_add,
            label: 'Invite Friend',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invite feature coming soon!")),
              );
            },
          ),
          drawerItem(
            iconData: Icons.star,
            label: 'Rate the App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Rating feature coming soon!")),
              );
            },
          ),
          drawerItem(
            iconData: Icons.info_outline,
            label: 'About Us',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OurTeamPage(),
                ),
              );
            },
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white24)),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Sign Out', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.logout, color: Colors.redAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem({
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(iconData, color: Colors.white70),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
