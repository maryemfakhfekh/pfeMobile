// lib/features/encadrant/widgets/accueil/accueil_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AccueilHeader extends StatelessWidget {
  final String prenom;
  final String date;
  final VoidCallback? onProfilTap;

  const AccueilHeader({
    super.key,
    required this.prenom,
    required this.date,
    this.onProfilTap,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bonjour,',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  prenom.isEmpty ? 'Encadrant' : prenom,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Avatar profil
          GestureDetector(
            onTap: onProfilTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.dark,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.35), width: 2),
              ),
              child: const Icon(Icons.person_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}