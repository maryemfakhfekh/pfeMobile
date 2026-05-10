// lib/features/stagiaire/widgets/dashboard/home/stage_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../../stagiaire_ui_tokens.dart';

class StageCard extends StatelessWidget {
  final StagiaireModel dossier;
  final double         progression;
  final int            terminees;
  final int            total;

  const StageCard({
    super.key,
    required this.dossier,
    required this.progression,
    required this.terminees,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progression * 100).toInt();

    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header : icône + titre + badge statut ──────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dossier.sujet.titre.trim(),
                      style: StagiaireUiTokens.sectionTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'ASM · Informatique',
                      style: StagiaireUiTokens.cardSubtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: dossier.statusStage),
            ],
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 14),

          // ── Label PROGRESSION + pourcentage ───────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROGRESSION',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Barre de progression ───────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value:      progression,
              minHeight:  8,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            total > 0
                ? '$terminees sur $total tâches complétées'
                : 'Aucune tâche assignée',
            style: StagiaireUiTokens.cardSubtitle,
          ),

          const SizedBox(height: 14),

          // ── Dates début / fin ──────────────────────────
          Row(
            children: [
              _DateChip(
                label: 'DÉBUT',
                value: dossier.dateDebut,
                color: AppTheme.primary,
                bg:    AppTheme.primarySoft,
              ),
              const Spacer(),
              _DateChip(
                label: 'FIN',
                value: dossier.dateFin ?? 'Non défini',
                color: StagiaireUiTokens.done,
                bg:    StagiaireUiTokens.done.withOpacity(0.10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Widgets privés ──────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  String get _label => switch (status.toUpperCase()) {
    'EN_COURS' => 'En cours',
    'TERMINE'  => 'Terminé',
    'EN_PAUSE' => 'En pause',
    _          => 'En cours',
  };

  Color get _color => switch (status.toUpperCase()) {
    'TERMINE'  => StagiaireUiTokens.done,
    'EN_PAUSE' => StagiaireUiTokens.late,
    _          => AppTheme.primary,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label, value;
  final Color  color, bg;
  const _DateChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}