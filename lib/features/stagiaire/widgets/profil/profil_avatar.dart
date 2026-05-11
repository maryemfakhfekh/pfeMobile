// lib/features/stagiaire/widgets/profil/profil_avatar.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilAvatar extends StatelessWidget {
  final String  nomComplet;
  final String? cycleName;
  final String? filiereName;

  const ProfilAvatar({
    super.key,
    required this.nomComplet,
    this.cycleName,
    this.filiereName,
  });

  String get _initials {
    final parts = nomComplet.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return nomComplet.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Avatar rond ──────────────────────────────────
        Container(
          width: 88, height: 88,
          decoration: const BoxDecoration(
            color: AppTheme.textPrimary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Nom complet ──────────────────────────────────
        Text(
          nomComplet,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 6),

        // ── Badge cycle · filière ────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.primarySoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primary.withOpacity(0.20)),
          ),
          child: Text(
            '${cycleName ?? 'Stagiaire'} · ${filiereName ?? ''}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}