import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker_hivedb/theme/app_theme.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : AppTheme.lightSurface;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.lightBorder;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
    final textMuted = isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        key: ValueKey(habitName),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.35,
          children: [
            if (settingsTapped != null)
              SlidableAction(
                onPressed: settingsTapped!,
                backgroundColor: isDark ? AppTheme.darkSurfaceElevated : const Color(0xFFE2E8F0),
                foregroundColor: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                icon: Icons.tune,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusCard),
                  bottomLeft: Radius.circular(AppTheme.radiusCard),
                ),
              ),
            if (deleteTapped != null)
              SlidableAction(
                onPressed: deleteTapped!,
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppTheme.radiusCard),
                  bottomRight: Radius.circular(AppTheme.radiusCard),
                ),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            onTap: () {
              if (onChanged != null) {
                onChanged!(!habitCompleted);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: habitCompleted
                    ? (isDark ? AppTheme.darkSurfaceElevated.withValues(alpha: 0.5) : AppTheme.lightSurfaceElevated)
                    : cardBg,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(
                  color: habitCompleted
                      ? (isDark ? AppTheme.darkBorder.withValues(alpha: 0.5) : AppTheme.lightBorder)
                      : borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Accessible checkbox with generous tap target
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Checkbox(
                      value: habitCompleted,
                      onChanged: onChanged,
                      activeColor: AppTheme.logoAzure,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      side: BorderSide(
                        color: habitCompleted ? AppTheme.logoAzure : textMuted,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      habitName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: habitCompleted ? FontWeight.normal : FontWeight.w500,
                        color: habitCompleted ? textMuted : textPrimary,
                        decoration: habitCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (habitCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.logoOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.logoOrange : AppTheme.logoOrangeDark,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_left,
                      size: 18,
                      color: textMuted.withValues(alpha: 0.4),
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
