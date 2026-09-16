import 'package:flutter/material.dart';
import 'package:habit_tracker_hivedb/main.dart';
import 'package:habit_tracker_hivedb/pages/about_page.dart';
import 'package:habit_tracker_hivedb/pages/history_page.dart';
import 'package:habit_tracker_hivedb/pages/reminder_page.dart';
import 'package:habit_tracker_hivedb/pages/login_page.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
    final surfaceColor = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;

    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

    return Drawer(
      backgroundColor: surfaceColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: isDark ? AppTheme.darkSurfaceElevated : AppTheme.lightSurfaceElevated,
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.logoAzure : AppTheme.logoCobalt,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Daily Achiever',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: borderColor),
            const SizedBox(height: 12),

            // Navigation Items (Real destinations only - R-24)
            drawerItem(
              context: context,
              iconData: Icons.check_circle_outline,
              label: 'Today\'s Habits',
              onTap: () => Navigator.pop(context),
            ),
            drawerItem(
              context: context,
              iconData: Icons.calendar_today_outlined,
              label: 'History & Streaks',
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
              context: context,
              iconData: Icons.notifications_none,
              label: 'Daily Reminders',
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
              context: context,
              iconData: Icons.info_outline,
              label: 'About Team',
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

            // Theme Switcher (Working Light/Dark toggle - R-21, R-34)
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
                      activeTrackColor: AppTheme.logoAzure,
                      onChanged: (val) {
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Sign Out Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                        ),
                      ),
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

  Widget drawerItem({
    required BuildContext context,
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final iconColor = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        ),
        leading: Icon(iconData, color: iconColor, size: 20),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}
