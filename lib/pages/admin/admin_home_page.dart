import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/login_page.dart';
import 'package:habit_tracker_hivedb/pages/admin/admin_profile_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppUser> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final userBox = Hive.box<AppUser>('users');
    setState(() {
      users = userBox.values.where((u) => u.role != 'admin').toList();
    });
  }

  Future<void> deleteUserAndHabits(int userId) async {
    final userBox = Hive.box<AppUser>('users');
    final user = userBox.get(userId);

    if (user != null) {
      final boxName = 'habits_${user.username}';

      // Tutup dan hapus box habit jika terbuka
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }

      if (await Hive.boxExists(boxName)) {
        await Hive.deleteBoxFromDisk(boxName);
      }

      await userBox.delete(userId);
      await fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      drawer: buildAdminDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF174E8F),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 20),
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Users",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user.key;

                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFFD3EBFD),
                          child: Image.asset('assets/avatar.png',
                              width: 30, height: 30),
                        ),
                        title: Text(
                          user.fullName.isNotEmpty
                              ? user.fullName
                              : user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete User'),
                                    content: Text(
                                        'Are you sure you want to delete ${user.username}?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        child: const Text('Delete'),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await deleteUserAndHabits(userId);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                        onTap: () {
                          if (userId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfilePage(userId: userId),
                              ),
                            );
                          }
                        },
                      ),
                      const Divider(
                          height: 1, thickness: 1, color: Colors.black12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // DRAWER UNTUK ADMIN (GAYA CUSTOM)
  // ================================

  Widget buildAdminDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Admin',
              style: TextStyle(
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("About page coming soon!")),
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
                  MaterialPageRoute(builder: (_) => const LoginPage()),
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
