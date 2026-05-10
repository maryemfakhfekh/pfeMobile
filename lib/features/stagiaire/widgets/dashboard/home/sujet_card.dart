import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../../stagiaire_ui_tokens.dart';

class SujetCard extends StatelessWidget {
  final StagiaireModel dossier;
  const SujetCard({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dossier.sujet.titre.trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${dossier.dateDebut} - ${dossier.dateFin ?? 'En cours'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecond,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '60%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.6,
                backgroundColor: AppTheme.border,
                color: AppTheme.primary,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}