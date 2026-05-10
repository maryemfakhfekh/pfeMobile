// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_stats_row.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StagiairesStatsRow extends StatelessWidget {
  final int avgProg;
  final int terminees;
  final int aFaire;

  const StagiairesStatsRow({
    super.key,
    required this.avgProg,
    required this.terminees,
    required this.aFaire,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        children: [
          // Card principale — avancement
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.trending_up_rounded,
                        color: Colors.white, size: 17),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$avgProg%',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    'Avancement\nglobal',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Colonne droite
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _SmallCard(
                  icon: Icons.check_circle_outline_rounded,
                  value: '$terminees',
                  label: 'Tâches terminées',
                  iconColor: const Color(0xFF16A34A),
                  iconBg: const Color(0xFFEAFAF0),
                ),
                const SizedBox(height: 10),
                _SmallCard(
                  icon: Icons.radio_button_unchecked_rounded,
                  value: '$aFaire',
                  label: 'À faire',
                  iconColor: const Color(0xFFDC2626),
                  iconBg: const Color(0xFFFEF2F2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color iconBg;

  const _SmallCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}