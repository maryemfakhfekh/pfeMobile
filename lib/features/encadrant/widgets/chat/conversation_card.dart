// lib/features/encadrant/widgets/chat/conversation_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

const _avatarColors = [
  Color(0xFF1E293B),
  Color(0xFF0F6E56),
  Color(0xFF534AB7),
  Color(0xFF993556),
  Color(0xFF185FA5),
  Color(0xFF854F0B),
];

class ConversationCard extends StatelessWidget {
  final StagiaireEncadrantModel s;
  final int index;

  const ConversationCard({
    super.key,
    required this.s,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarColors[index % _avatarColors.length];

    return GestureDetector(
      onTap: () => context.router.push(EncadrantChatRoute(stagiaire: s)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [

            // ── Avatar rond + point vert ─────────────────
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      s.initials,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            // ── Nom + aperçu ─────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.nomComplet,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    s.sujetTitre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Flèche ───────────────────────────────────
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}