import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class StagiaireAssigneCard extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  const StagiaireAssigneCard({super.key, required this.stagiaire});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(children: [
        _Avatar(initials: stagiaire.initials),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stagiaire.nomComplet,
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(color: AppTheme.textDark)),
              const SizedBox(height: 2),
              Text(stagiaire.sujetTitre,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        _AssigneBadge(),
      ]),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) => Container(
    width: 44, height: 44,
    decoration: BoxDecoration(
      color: AppTheme.dark,
      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
    ),
    child: Center(
      child: Text(initials,
          style: const TextStyle(
              color: Colors.white, fontSize: 16,
              fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
    ),
  );
}

class _AssigneBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.primarySoft,
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
    ),
    child: const Text('Assigné à',
        style: TextStyle(
            fontFamily: 'Poppins', fontSize: 11,
            fontWeight: FontWeight.w600, color: AppTheme.primary)),
  );
}