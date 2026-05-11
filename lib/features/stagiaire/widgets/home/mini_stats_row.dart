// lib/features/stagiaire/widgets/home/mini_stats_row.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MiniStatsRow extends StatelessWidget {
  final int terminees;
  final int enCours;
  final int aFaire;
  final int total;

  const MiniStatsRow({
    super.key,
    required this.terminees,
    required this.enCours,
    required this.aFaire,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
      child: Row(
        children: [
          _StatItem(value: '$terminees', label: 'Terminées', color: const Color(0xFF16A34A), icon: Icons.check_circle_outline_rounded),
          _Divider(),
          _StatItem(value: '$enCours',   label: 'En cours',  color: AppTheme.primary,        icon: Icons.timelapse_rounded),
          _Divider(),
          _StatItem(value: '$aFaire',    label: 'À faire',   color: const Color(0xFF64748B), icon: Icons.radio_button_unchecked_rounded),
          _Divider(),
          _StatItem(value: '$total',     label: 'Total',     color: const Color(0xFF1E293B), icon: Icons.bar_chart_rounded),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String   value;
  final String   label;
  final Color    color;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.5, height: 40, color: const Color(0xFFE2E8F0));
  }
}