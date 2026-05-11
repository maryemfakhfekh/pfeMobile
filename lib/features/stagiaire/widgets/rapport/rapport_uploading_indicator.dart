// lib/features/stagiaire/widgets/rapport/rapport_uploading_indicator.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../stagiaire_ui_tokens.dart';

class RapportUploadingIndicator extends StatelessWidget {
  const RapportUploadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: StagiaireUiTokens.cardDecoration(),
      child: const Row(
        children: [
          CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
          SizedBox(width: 16),
          Text(
            'Envoi en cours...',
            style: StagiaireUiTokens.cardSubtitle,
          ),
        ],
      ),
    );
  }
}