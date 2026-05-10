import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sujet_model.dart';

class SubjectInfoCard extends StatelessWidget {
  final SujetModel sujet;
  const SubjectInfoCard({super.key, required this.sujet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          _InfoItem(
            icon: Icons.school_rounded,
            label: 'Filière',
            value: sujet.filiereCible,
            color: AppTheme.primary,
            bg: AppTheme.primarySoft,
          ),
          _VertDivider(),
          _InfoItem(
            icon: Icons.workspace_premium_rounded,
            label: 'Cycle',
            value: sujet.cycleCible,
            color: const Color(0xFF0891B2),
            bg: const Color(0xFFECFEFF),
          ),
          _VertDivider(),
          _InfoItem(
            icon: sujet.estDisponible
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            label: 'Statut',
            value: sujet.estDisponible ? 'Ouvert' : 'Fermé',
            color: sujet.estDisponible
                ? AppTheme.success
                : AppTheme.error,
            bg: sujet.estDisponible
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppTheme.border,
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}