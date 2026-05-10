// lib/features/encadrant/widgets/accueil/accueil_activite_card.dart

import 'package:flutter/material.dart';

/// Modèle d'activité — adapte selon ta vraie source de données (BLoC/API)
class ActiviteItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String message; // ex: "Rania Meddeb a soumis une tâche"
  final String sousTitre; // ex: "Module Flutter encadrant"
  final String temps; // ex: "Il y a 14 min"

  const ActiviteItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.message,
    required this.sousTitre,
    required this.temps,
  });
}

class AccueilActiviteCard extends StatelessWidget {
  final List<ActiviteItem> activites;

  const AccueilActiviteCard({super.key, required this.activites});

  @override
  Widget build(BuildContext context) {
    if (activites.isEmpty) return const SizedBox.shrink();

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
                  'Activité récente',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.access_time_rounded,
                        size: 13, color: Color(0xFF94A3B8)),
                    SizedBox(width: 4),
                    Text(
                      "Aujourd'hui",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Activités
          ...activites.asMap().entries.map((e) {
            final item = e.value;
            final isLast = e.key == activites.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: item.iconBg,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(item.icon,
                            color: item.iconColor, size: 16),
                      ),
                      const SizedBox(width: 12),

                      // Texte
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.message,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F172A),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.sousTitre,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.temps,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                      height: 1,
                      indent: 62,
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