// lib/features/encadrant/widgets/profile/profile_stats_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileStatsCard extends StatelessWidget {
  final int stagairesCount;

  const ProfileStatsCard({super.key, required this.stagairesCount});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue d\'ensemble',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.textDark),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatIcon(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stagiaires assignés',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '$stagairesCount',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: AppTheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
      child: const Icon(
        Icons.people_outline,
        color: AppTheme.primary,
        size: 22,
      ),
    );
  }
}