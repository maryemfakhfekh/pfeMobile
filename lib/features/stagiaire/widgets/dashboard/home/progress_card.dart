import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../stagiaire_ui_tokens.dart';

class ProgressCard extends StatelessWidget {
  final double  progress;
  final int     terminees;
  final int     enCours;
  final int     aFaire;
  final String? dateDebut;
  final String? dateFin;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.terminees,
    required this.enCours,
    required this.aFaire,
    this.dateDebut,
    this.dateFin,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();

    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header titre + pourcentage ─────────────────
          Row(
            children: [
              // Icône avec fond (cohérent avec mini_stats_row)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Progression des tâches',
                  style: StagiaireUiTokens.sectionTitle,
                ),
              ),
              // Badge pourcentage
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Barre de progression ───────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary),
            ),
          ),

          const SizedBox(height: 14),

          // ── Stats 3 colonnes ───────────────────────────
          Row(
            children: [
              _StatPill(
                value:  '$terminees',
                label:  'Terminées',
                color:  StagiaireUiTokens.done,
                bg:     StagiaireUiTokens.done.withOpacity(0.10),
              ),
              const SizedBox(width: 8),
              _StatPill(
                value:  '$enCours',
                label:  'En cours',
                color:  StagiaireUiTokens.inProgress,
                bg:     AppTheme.primarySoft,
              ),
              const SizedBox(width: 8),
              _StatPill(
                value:  '$aFaire',
                label:  'À faire',
                color:  AppTheme.textSecond,
                bg:     AppTheme.background,
              ),
            ],
          ),

          // ── Dates (affichées seulement si fournies) ────
          if (dateDebut != null || dateFin != null) ...[
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: AppTheme.border,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (dateDebut != null)
                  _DateItem(label: 'Début', value: dateDebut!),
                if (dateFin != null)
                  _DateItem(label: 'Fin',   value: dateFin!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Widgets privés ─────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String value, label;
  final Color  color, bg;

  const _StatPill({
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final String label, value;
  const _DateItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: StagiaireUiTokens.statLabel,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: StagiaireUiTokens.cardTitle,
        ),
      ],
    );
  }
}