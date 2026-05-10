// lib/features/encadrant/widgets/accueil/accueil_retard_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class AccueilRetardCard extends StatelessWidget {
  final List<StagiaireEncadrantModel> stagiaires;

  const AccueilRetardCard({super.key, required this.stagiaires});

  static const _palette = [
    [Color(0xFFEEEDFE), Color(0xFF3C3489)],
    [Color(0xFFE6F1FB), Color(0xFF0C447C)],
    [Color(0xFFE1F5EE), Color(0xFF085041)],
    [Color(0xFFFAECE7), Color(0xFF712B13)],
    [Color(0xFFEAF3DE), Color(0xFF27500A)],
  ];

  List<Color> _colors(String name) =>
      _palette[name.length % _palette.length];

  @override
  Widget build(BuildContext context) {
    if (stagiaires.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'En retard',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${stagiaires.length} stagiaire${stagiaires.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA32D2D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Liste
          ...stagiaires.asMap().entries.map((e) {
            final s = e.value;
            final isLast = e.key == stagiaires.length - 1;
            final pct = (s.progressionGlobale * 100).round();
            final colors = _colors(s.nomComplet);

            return Column(
              children: [
                InkWell(
                  onTap: () => context.router
                      .push(DetailStagiaireRoute(stagiaire: s)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colors[0],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              s.initials,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors[1],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Infos
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.nomComplet,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                s.sujetTitre,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              // Barre
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: s.progressionGlobale,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFFE24B4A)),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Pourcentage
                        Text(
                          '$pct%',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE24B4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1,
                      indent: 66,
                      endIndent: 16,
                      color: Color(0xFFF1F5F9)),
              ],
            );
          }),
        ],
      ),
    );
  }
}