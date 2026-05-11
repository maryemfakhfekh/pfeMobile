// lib/features/stagiaire/widgets/profil/profil_encadrant_card.dart

import 'package:flutter/material.dart';
import '../../data/models/stagiaire_model.dart';
import '../stagiaire_ui_tokens.dart';

class ProfilEncadrantCard extends StatelessWidget {
  final EncadrantModel encadrant;

  const ProfilEncadrantCard({super.key, required this.encadrant});

  String get _initials {
    final parts = encadrant.nomComplet.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return encadrant.nomComplet.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: StagiaireUiTokens.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mon Encadrant', style: StagiaireUiTokens.sectionTitle),
          const SizedBox(height: 14),
          Row(children: [

            // Avatar encadrant
            Container(
              width: 42, height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Nom + email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(encadrant.nomComplet,
                      style: StagiaireUiTokens.cardTitle),
                  const SizedBox(height: 2),
                  Text(encadrant.email,
                      style: StagiaireUiTokens.cardSubtitle,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

            // Badge disponible
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: StagiaireUiTokens.done.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      color: StagiaireUiTokens.done,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Disponible',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: StagiaireUiTokens.done,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}