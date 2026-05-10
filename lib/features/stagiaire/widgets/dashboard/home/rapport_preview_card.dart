import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/rapport_model.dart';
import '../../../data/models/stagiaire_model.dart';
import '../../stagiaire_ui_tokens.dart';

class RapportPreviewCard extends StatelessWidget {
  final StagiaireModel dossier;
  final RapportModel? rapport;
  const RapportPreviewCard({super.key, required this.dossier, this.rapport});

  @override
  Widget build(BuildContext context) {
    final hasRapport = rapport != null;
    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text('Rapport de stage', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 20, thickness: 0.5, color: AppTheme.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dossier.sujet.titre.trim(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${dossier.dateDebut} - ${dossier.dateFin ?? 'En cours'}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: hasRapport ? 1.0 : 0.4,
                        backgroundColor: AppTheme.border,
                        color: AppTheme.primary,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(hasRapport ? '100%' : '40%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                  ],
                ),
                const SizedBox(height: 16),
                // Annotation supprimée car 'commentaireEncadrant' n'existe pas
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.primary)),
                    child: const Text('Accéder au rapport'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}