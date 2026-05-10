import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileInfoCard extends StatelessWidget {
  final String nomAffiche;
  final String email;
  final String filiere;
  final String cycle;

  const ProfileInfoCard({
    super.key,
    required this.nomAffiche,
    required this.email,
    required this.filiere,
    required this.cycle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF3B82F6),
            bgColor: const Color(0xFFEFF6FF),
            label: 'Nom complet',
            value: nomAffiche.isNotEmpty ? nomAffiche : '—',
          ),
          _ProfileRow(
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF0891B2),
            bgColor: const Color(0xFFECFEFF),
            label: 'Email',
            value: email.isNotEmpty ? email : '—',
          ),
          _ProfileRow(
            icon: Icons.account_tree_rounded,
            iconColor: AppTheme.primary,
            bgColor: AppTheme.primarySoft,
            label: 'Filière',
            value: filiere.isNotEmpty ? filiere : '—',
          ),
          _ProfileRow(
            icon: Icons.workspace_premium_rounded,
            iconColor: const Color(0xFF8B5CF6),
            bgColor: const Color(0xFFF5F3FF),
            label: 'Cycle',
            value: cycle.isNotEmpty ? cycle : '—',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  final bool isLast;

  const _ProfileRow({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecond,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            color: AppTheme.border,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}