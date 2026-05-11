// lib/features/stagiaire/widgets/profil/profil_info_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';
import '../stagiaire_ui_tokens.dart';

class ProfilInfoCard extends StatelessWidget {
  final UtilisateurModel utilisateur;

  const ProfilInfoCard({super.key, required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: StagiaireUiTokens.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informations personnelles',
              style: StagiaireUiTokens.sectionTitle),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nom complet',
            value: utilisateur.nomComplet,
          ),
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: utilisateur.email,
          ),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: utilisateur.telephone ?? 'Non renseigné',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  final bool     isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: StagiaireUiTokens.statLabel.copyWith(fontSize: 11)),
                Text(value,
                    style: StagiaireUiTokens.cardTitle.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
        if (!isLast)
          Container(
            height: 1,
            color: AppTheme.border,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
      ],
    );
  }
}