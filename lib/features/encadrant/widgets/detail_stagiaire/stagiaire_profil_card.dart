import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/evaluation_model.dart';

class StagiaireProfilCard extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  final double progress;
  final int totalTaches;
  final EvaluationModel? evaluation;

  const StagiaireProfilCard({
    super.key,
    required this.stagiaire,
    required this.progress,
    required this.totalTaches,
    this.evaluation,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: AppTheme.shadowSM,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Ligne avatar + infos + note ──────────────
          Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.dark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    stagiaire.initials,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Nom + filière + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stagiaire.nomComplet,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.darkSoft,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Text(
                            stagiaire.filiere,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: AppTheme.textLight),
                        const SizedBox(width: 4),
                        Text(
                          stagiaire.dateDebut,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Note évaluation
              if (evaluation != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.3)),
                  ),
                  child: Column(children: [
                    Text(
                      evaluation!.noteFinale.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                    const Text('/20',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            color: AppTheme.primary)),
                  ]),
                ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppTheme.border, height: 1),
          const SizedBox(height: 14),

          // ── Stats en ligne ───────────────────────────
          Row(
            children: [
              _StatPill(
                icon: Icons.checklist_rounded,
                label: '$totalTaches tâche${totalTaches > 1 ? 's' : ''}',
                color: AppTheme.dark,
                bg: AppTheme.darkSoft,
              ),
              const SizedBox(width: 8),
              _StatPill(
                icon: Icons.check_circle_outline_rounded,
                label: '${stagiaire.tachesTerminees} terminée${stagiaire.tachesTerminees > 1 ? 's' : ''}',
                color: AppTheme.success,
                bg: AppTheme.successSoft,
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: pct >= 70
                      ? AppTheme.success
                      : pct >= 40
                      ? AppTheme.primary
                      : AppTheme.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Barre de progression ─────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.border,
              color: pct >= 70
                  ? AppTheme.success
                  : pct >= 40
                  ? AppTheme.primary
                  : AppTheme.error,
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;

  const _StatPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}