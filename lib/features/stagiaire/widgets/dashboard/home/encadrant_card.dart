// lib/features/stagiaire/widgets/dashboard/home/encadrant_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';

class EncadrantCard extends StatelessWidget {
  final EncadrantModel? encadrant;
  final VoidCallback?   onChatTap; // ← navigue vers onglet Chat

  const EncadrantCard({
    super.key,
    required this.encadrant,
    this.onChatTap,
  });

  String get _initials {
    if (encadrant == null) return '?';
    final parts = encadrant!.nomComplet.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return encadrant!.nomComplet.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (encadrant == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSM,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre ─────────────────────────────────────
          const Text(
            'Mon encadrant',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          // ── Ligne : avatar + infos + boutons ──────────
          Row(
            children: [

              // Avatar rond noir
              Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(
                  color: AppTheme.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Nom + email + disponibilité
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      encadrant!.nomComplet,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      encadrant!.email,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: AppTheme.textSecond,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Disponible',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ── Bouton Appel ──────────────────────────
              GestureDetector(
                onTap: () async {
                  // Utilise telephone si disponible sinon email
                  final tel = encadrant!.telephone;
                  if (tel != null && tel.isNotEmpty) {
                    final uri = Uri.parse('tel:$tel');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  } else {
                    // Fallback : ouvre email
                    final uri = Uri.parse(
                        'mailto:${encadrant!.email}');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  }
                },
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.successSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: AppTheme.success,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ── Bouton Message → Chat ─────────────────
              GestureDetector(
                onTap: onChatTap,
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: onChatTap != null
                        ? AppTheme.primarySoft
                        : AppTheme.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: onChatTap != null
                        ? AppTheme.primary
                        : AppTheme.textLight,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}