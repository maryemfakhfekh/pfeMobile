// lib/features/encadrant/widgets/taches/tache_encadrant_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/tache_encadrant_model.dart';

class TacheEncadrantCard extends StatelessWidget {
  final TacheEncadrantModel tache;
  final StagiaireEncadrantModel? stagiaire;
  final VoidCallback onDelete;
  final bool showStagiaire;

  const TacheEncadrantCard({
    super.key,
    required this.tache,
    required this.stagiaire,
    required this.onDelete,
    this.showStagiaire = true,
  });

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';

  Color get _statutColor => switch (tache.statut) {
    StatutTacheEncadrant.termine => const Color(0xFF16A34A),
    StatutTacheEncadrant.enCours => AppTheme.primary,
    StatutTacheEncadrant.aFaire  => const Color(0xFF94A3B8),
  };

  String get _statutLabel => switch (tache.statut) {
    StatutTacheEncadrant.termine => 'Terminé',
    StatutTacheEncadrant.enCours => 'En cours',
    StatutTacheEncadrant.aFaire  => 'À faire',
  };

  Color get _prioriteColor => switch (tache.priorite) {
    PrioriteTache.critique => const Color(0xFF7C3AED),
    PrioriteTache.haute    => const Color(0xFFDC2626),
    PrioriteTache.moyenne  => AppTheme.primary,
    PrioriteTache.basse    => const Color(0xFF16A34A),
  };

  Color get _prioriteBg => switch (tache.priorite) {
    PrioriteTache.critique => const Color(0xFFF5F3FF),
    PrioriteTache.haute    => const Color(0xFFFEF2F2),
    PrioriteTache.moyenne  => const Color(0xFFFFF0E6),
    PrioriteTache.basse    => const Color(0xFFEAFAF0),
  };

  @override
  Widget build(BuildContext context) {
    final isTermine  = tache.statut == StatutTacheEncadrant.termine;
    final nomComplet = stagiaire?.nomComplet ?? '';
    final prenom     = nomComplet.trim().split(' ').first;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Barre latérale colorée ─────────────────
              Container(width: 4, color: _statutColor),

              // ── Contenu ────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Titre + bouton supprimer ─────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              tache.titre,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isTermine
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF0F172A),
                                decoration: isTermine
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 14,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── Description ──────────────────────
                      if (tache.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          tache.description,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: 10),
                      const Divider(
                        color: Color(0xFFE2E8F0),
                        height: 1,
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 10),

                      // ── Badges ───────────────────────────
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [

                          // Statut
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _statutColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _statutColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _statutLabel,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _statutColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Priorité
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _prioriteBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tache.priorite.uiLabel,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _prioriteColor,
                              ),
                            ),
                          ),

                          // Assigné à
                          if (showStagiaire && prenom.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    size: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    prenom,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Date
                          if (tache.dateEcheance != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _formatDate(tache.dateEcheance!),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}