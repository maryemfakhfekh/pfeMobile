// lib/features/stagiaire/widgets/dashboard/home/mini_stats_row.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../stagiaire_ui_tokens.dart';

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
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.65,
      children: [
        _StatCard(
          value:     terminees,
          label:     'Terminées',
          icon:      Icons.check_circle_outline_rounded,
          iconColor: StagiaireUiTokens.done,
        ),
        _StatCard(
          value:     total,
          label:     'Tâches assignées',
          icon:      Icons.bar_chart_rounded,
          iconColor: StagiaireUiTokens.assigned,
        ),
        _StatCard(
          value:     enCours,
          label:     'En cours',
          icon:      Icons.timelapse_rounded,
          iconColor: StagiaireUiTokens.inProgress,
        ),
        _StatCard(
          value:     aFaire,
          label:     'En retard',
          icon:      Icons.error_outline_rounded,
          iconColor: StagiaireUiTokens.late,
        ),
      ],
    );
  }
}

// ── Widget privé pour éviter la répétition ─────────────────────────
class _StatCard extends StatelessWidget {
  final int      value;
  final String   label;
  final IconData icon;
  final Color    iconColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        // ── Bordure subtile alignée sur le style Encadrant ──
        border: Border.all(color: AppTheme.border, width: 0.5),
        boxShadow: AppTheme.shadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Icône avec fond coloré (comme image 1) ──────
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),

          // ── Valeur + label ───────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: StagiaireUiTokens.statNumber,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: StagiaireUiTokens.statLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}