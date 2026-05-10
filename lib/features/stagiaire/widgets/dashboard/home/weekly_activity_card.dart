// lib/features/stagiaire/widgets/dashboard/home/weekly_activity_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

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
    final safeValues = values.length == 7
        ? values
        : List<int>.filled(7, 0);

    final today     = DateTime.now().weekday - 1;
    final weekTotal = safeValues.reduce((a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSM,
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header ────────────────────────────────────
          Row(
            children: [
              const Text(
                'Cette semaine',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              Text(
                weekTotal > 0
                    ? '$weekTotal au total'
                    : '$total au total',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppTheme.textSecond,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Graphique points ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final val     = safeValues[i];
              final isToday = i == today;

              return Column(
                children: [

                  // Label jour
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: isToday
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isToday
                          ? AppTheme.textPrimary
                          : AppTheme.textLight,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Points selon nombre de tâches
                  _buildDots(val, isToday),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(int count, bool isToday) {
    // Max 4 points affichés
    final dotCount = count.clamp(0, 4);
    final color = isToday ? AppTheme.primary : AppTheme.textLight;

    if (dotCount == 0) {
      return Container(
        width: 6, height: 6,
        decoration: const BoxDecoration(
          color: AppTheme.borderLight,
          shape: BoxShape.circle,
        ),
      );
    }

    return Column(
      children: List.generate(dotCount, (i) => Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      )),
    );
  }
}