// lib/features/encadrant/widgets/evaluation/evaluation_critere_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EvaluationCritereCard extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final double note;
  final ValueChanged<double> onChanged;

  const EvaluationCritereCard({
    super.key,
    required this.titre,
    required this.sousTitre,
    required this.note,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          Text(titre,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: AppTheme.textDark)),
          const SizedBox(height: 2),
          Text(sousTitre,
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final filled = i < note;
              return GestureDetector(
                onTap: () => onChanged(i + 1.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    filled
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: filled ? AppTheme.primary : AppTheme.border,
                    size: 30,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}