// lib/features/stagiaire/widgets/rapport/rapport_status_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/rapport_model.dart';
import '../stagiaire_ui_tokens.dart';

class RapportStatusCard extends StatelessWidget {
  final RapportModel? rapport;
  const RapportStatusCard({super.key, this.rapport});

  @override
  Widget build(BuildContext context) {
    final estDepose = rapport != null;
    final iconColor = estDepose ? AppTheme.success : AppTheme.primary;
    final iconBg    = estDepose
        ? AppTheme.success.withOpacity(0.10)
        : AppTheme.primarySoft;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Row(
        children: [

          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              estDepose
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estDepose ? 'Rapport déposé' : 'Aucun rapport déposé',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: estDepose ? AppTheme.success : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  estDepose
                      ? 'Déposé le ${rapport!.dateDepot ?? ''} · En attente encadrant'
                      : 'Déposez votre rapport avant la fin du stage',
                  style: StagiaireUiTokens.cardSubtitle,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5, height: 5,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  estDepose ? 'Déposé' : 'En attente',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
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