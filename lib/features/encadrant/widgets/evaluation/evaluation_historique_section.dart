// lib/features/encadrant/widgets/evaluation/evaluation_historique_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/evaluation_model.dart';

class EvaluationHistoriqueSection extends StatefulWidget {
  final List<EvaluationModel> evaluations;

  const EvaluationHistoriqueSection({
    super.key,
    required this.evaluations,
  });

  @override
  State<EvaluationHistoriqueSection> createState() =>
      _EvaluationHistoriqueSectionState();
}

class _EvaluationHistoriqueSectionState
    extends State<EvaluationHistoriqueSection> {
  bool _expanded = true;

  static const _emojis = ['🧑‍💻', '👩‍💼', '🧑‍🔧', '👩‍🎨', '🧑‍🔬'];

  String _emoji(String nom) =>
      _emojis[nom.codeUnitAt(0) % _emojis.length];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ───────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: AppTheme.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                'Historique des évaluations (${widget.evaluations.length})',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppTheme.textDark),
              ),
              const Spacer(),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textLight,
              ),
            ],
          ),
        ),

        // ── Liste ────────────────────────────────
        if (_expanded && widget.evaluations.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...widget.evaluations.map((e) => _HistoriqueCard(
            eval: e,
            emoji: _emoji(e.nomComplet),
          )),
        ],

        if (_expanded && widget.evaluations.isEmpty) ...[
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Aucune évaluation soumise',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}

class _HistoriqueCard extends StatelessWidget {
  final EvaluationModel eval;
  final String emoji;

  const _HistoriqueCard({
    required this.eval,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // ── Nom + note ──────────────────────────
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eval.nomComplet,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppTheme.textDark)),
                    Text(eval.date,
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    eval.note.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    eval.appreciation,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Badges critères ─────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: eval.criteres.entries
                .map((e) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Text(
                '${e.key}: ${e.value.toInt()}/5',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecond,
                ),
              ),
            ))
                .toList(),
          ),

          // ── Commentaire ─────────────────────────
          if (eval.commentaire.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '"${eval.commentaire}"',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.textSecond,
              ),
            ),
          ],
        ],
      ),
    );
  }
}