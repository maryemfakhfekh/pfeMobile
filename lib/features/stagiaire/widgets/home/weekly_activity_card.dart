// lib/features/stagiaire/widgets/home/weekly_activity_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class WeeklyActivityCard extends StatelessWidget {
  final List<int> values;
  final int       total;

  static const _days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  const WeeklyActivityCard({
    super.key,
    required this.values,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final safeValues = values.length == 7 ? values : List<int>.filled(7, 0);
    final today      = DateTime.now().weekday - 1;
    final weekTotal  = safeValues.reduce((a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.calendar_month_outlined, size: 15, color: AppTheme.primary),
              ),
              const SizedBox(width: 8),
              const Text(
                'Cette semaine',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$weekTotal tâche${weekTotal > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final val     = safeValues[i];
              final isToday = i == today;
              final hasTask = val > 0;
              return Column(
                children: [
                  _DayCircle(value: val, isToday: isToday, hasTask: hasTask),
                  const SizedBox(height: 6),
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      color: isToday ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DayCircle extends StatelessWidget {
  final int  value;
  final bool isToday;
  final bool hasTask;

  const _DayCircle({
    required this.value,
    required this.isToday,
    required this.hasTask,
  });

  @override
  Widget build(BuildContext context) {
    Color   bg;
    Color   textColor;
    Border? border;

    if (hasTask && value >= 2) {
      bg = const Color(0xFF1E293B); textColor = Colors.white; border = null;
    } else if (hasTask && isToday) {
      bg = AppTheme.primary; textColor = Colors.white; border = null;
    } else if (hasTask) {
      bg = AppTheme.primarySoft; textColor = AppTheme.primary; border = null;
    } else if (isToday) {
      bg = Colors.white; textColor = AppTheme.primary;
      border = Border.all(color: AppTheme.primary, width: 1.5);
    } else {
      bg = const Color(0xFFF1F5F9); textColor = const Color(0xFF94A3B8); border = null;
    }

    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: border),
      child: Center(
        child: Text(
          '$value',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}