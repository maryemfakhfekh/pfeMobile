// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_empty.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StagiairesEmpty extends StatelessWidget {
  const StagiairesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.darkSoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 30,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun stagiaire trouvé',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Aucun résultat pour cette recherche',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}