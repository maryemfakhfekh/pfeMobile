// lib/features/stagiaire/widgets/rapport/rapport_info_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../stagiaire_ui_tokens.dart';

class RapportInfoCard extends StatelessWidget {
  const RapportInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Votre rapport sera consulté par votre encadrant et le service RH. Assurez-vous qu\'il est complet avant de le soumettre.',
                  style: StagiaireUiTokens.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}