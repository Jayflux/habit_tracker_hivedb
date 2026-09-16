import 'package:flutter/material.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class MyFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const MyFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: isDark ? AppTheme.logoOrangePrimary : AppTheme.logoCobalt,
      foregroundColor: Colors.white,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
      ),
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'New Habit',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      tooltip: 'Add new habit',
    );
  }
}
