// lib/features/encadrant/widgets/evaluation/evaluation_commentaire_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EvaluationCommentaireCard extends StatelessWidget {
  final TextEditingController controller;

  const EvaluationCommentaireCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded,
                size: 16, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              'Commentaire (optionnel)',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: AppTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(color: AppTheme.border),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration(
              hintText:
              'Ajoutez un commentaire sur la performance du stagiaire...',
              contentPadding: EdgeInsets.all(14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}