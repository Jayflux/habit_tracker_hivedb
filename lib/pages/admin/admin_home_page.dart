import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habit_tracker_hivedb/main.dart';
import 'package:habit_tracker_hivedb/models/user.dart';
import 'package:habit_tracker_hivedb/pages/login_page.dart';
import 'package:habit_tracker_hivedb/pages/admin/admin_profile_page.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppUser> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final userBox = Hive.box<AppUser>('users');
    setState(() {
      users = userBox.values.where((u) => u.role != 'admin').toList();
      isLoading = false;
    });
  }

  Future<void> deleteUserAndHabits(int userId) async {
    final userBox = Hive.box<AppUser>('users');
    final user = userBox.get(userId);

    if (user != null) {
      final boxName = 'habits_${user.username}';

      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }

      if (await Hive.boxExists(boxName)) {
        await Hive.deleteBoxFromDisk(boxName);
      }

      await userBox.delete(userId);
      await fetchUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User ${user.username} and their habit data have been removed.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    return Scaffold(
      key: _scaffoldKey,
      drawer: buildAdminDrawer(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        title: const Text('User Management'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.maxContentWidth),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                    ),
                  )
                : users.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 48, color: textSecondary),
                              const SizedBox(height: 16),
                              Text(
                                'No Registered Users Yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Registered regular users will be listed here.',
                                style: TextStyle(fontSize: 14, color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        itemCount: users.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final userId = user.key;

                          return Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: isDark
                                    ? AppTheme.darkSurfaceElevated
                                    : AppTheme.lightSurfaceElevated,
                                child: Text(
                                  user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.fullName.isNotEmpty ? user.fullName : user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                user.email,
                                style: TextStyle(color: textSecondary, fontSize: 13),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppTheme.danger),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Delete User'),
                                          content: Text(
                                            'Are you sure you want to delete ${user.username}? This will remove all their habits permanently.',
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor: AppTheme.danger,
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                if (userId != null) {
                                                  await deleteUserAndHabits(userId);
                                                }
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Icon(Icons.chevron_right, size: 20, color: textSecondary),
                                ],
                              ),
                              onTap: () async {
                                if (userId != null) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProfilePage(userId: userId),
                                    ),
                                  );
                                  await fetchUsers();
                                }
                              },
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }

  Widget buildAdminDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    return Drawer(
      backgroundColor: surfaceColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: isDark ? AppTheme.darkSurfaceElevated : AppTheme.lightSurfaceElevated,
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 28,
                      color: isDark ? AppTheme.emeraldPrimary : AppTheme.emeraldDark,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        'System Management',
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.people_alt_outlined, color: textSecondary, size: 20),
              title: Text('Registered Users', style: TextStyle(color: textPrimary, fontSize: 14)),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurfaceElevated : AppTheme.lightSurfaceElevated,
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                          size: 18,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isDark ? 'Dark Theme' : 'Light Theme',
                          style: TextStyle(fontSize: 13, color: textPrimary),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: isDark,
                      activeTrackColor: AppTheme.emeraldPrimary,
                      onChanged: (val) {
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: borderColor))),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sign Out', style: TextStyle(color: textSecondary, fontSize: 14)),
                      const Icon(Icons.logout, size: 18, color: AppTheme.danger),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
