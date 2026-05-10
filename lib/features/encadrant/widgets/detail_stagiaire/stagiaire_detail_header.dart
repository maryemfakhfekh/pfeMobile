import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class StagiaireDetailHeader extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  const StagiaireDetailHeader({super.key, required this.stagiaire});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final estActif = stagiaire.dateFin == null || stagiaire.dateFin!.isEmpty;

    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
      child: Row(children: [
        _BackButton(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stagiaire.nomComplet,
                  style: Theme.of(context).textTheme.headlineMedium!
                      .copyWith(color: AppTheme.textDark)),
              Text(stagiaire.sujetTitre,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        _StatusBadge(estActif: estActif),
      ]),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.router.back(),
    child: Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: AppTheme.darkSoft,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Icon(Icons.arrow_back_ios_new_rounded,
          size: 15, color: AppTheme.dark),
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  final bool estActif;
  const _StatusBadge({required this.estActif});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: estActif ? AppTheme.successSoft : AppTheme.darkSoft,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 6, height: 6,
        decoration: BoxDecoration(
          color: estActif ? AppTheme.success : AppTheme.textLight,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 5),
      Text(estActif ? 'Actif' : 'Terminé',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 11,
              fontWeight: FontWeight.w700,
              color: estActif ? AppTheme.success : AppTheme.textSecond)),
    ]),
  );
}