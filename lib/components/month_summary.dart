// lib/components/month_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker_hivedb/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: const Color.fromARGB(255, 47, 47, 47),
        textColor: Colors.white,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color(0xFFE1BEE7), // Lavender pink
          2: Color(0xFFCE93D8),
          3: Color(0xFFBA68C8),
          4: Color(0xFFAB47BC),
          5: Color(0xFF9C27B0), // Purple
          6: Color(0xFF8E24AA),
          7: Color(0xFF7B1FA2),
          8: Color(0xFF6A1B9A),
          9: Color(0xFF4A148C),
          10: Color(0xFFAD1457), // Deep pink
        },
        onClick: (date) {
          final habitsCount = datasets[date] ?? 0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Date: ${convertDateTimeToString(date)}\nCompleted Score: $habitsCount/10',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
