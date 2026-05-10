// lib/features/stagiaire/widgets/pending/pending_info_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingInfoCard extends StatelessWidget {
  const PendingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header orange ──────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.work_outline_rounded,
                      color: AppTheme.primary, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Sujet de stage choisi',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          // ── Contenu ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Titre sujet
                const Text(
                  'Développement d\'une application\nde gestion des stagiaires',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 16),

                // Infos
                _infoRow(Icons.school_outlined,       'Filière',       'Informatique'),
                _divider(),
                _infoRow(Icons.calendar_today_rounded, 'Date de dépôt', '03/04/2026'),
                _divider(),
                _infoRow(Icons.timer_outlined,         'Durée',         '3 mois'),

                const SizedBox(height: 16),

                // Compétences requises
                const Text(
                  'Compétences requises',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppTheme.textSecond,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    'Flutter', 'Dart', 'Spring Boot', 'REST API', 'SQL'
                  ].map((s) => _chip(s)).toList(),
                ),

                const SizedBox(height: 16),

                // CV déposé
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppTheme.success,
                            size: 16),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'CV déposé avec succès',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: AppTheme.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: AppTheme.success, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      height: 1,
      color: AppTheme.borderLight,
      margin: const EdgeInsets.symmetric(vertical: 10));

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 15, color: AppTheme.textSecond),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppTheme.textLight,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                )),
            Text(value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: AppTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}