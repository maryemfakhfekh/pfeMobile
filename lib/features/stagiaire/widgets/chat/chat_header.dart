// lib/features/stagiaire/widgets/chat/chat_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';

class ChatHeader extends StatelessWidget {
  final EncadrantModel? encadrant;

  const ChatHeader({super.key, required this.encadrant});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(children: [

        // ── Avatar + point vert ────────────────────────
        Stack(children: [
          Container(
            width: 42, height: 42,
            decoration: const BoxDecoration(
              color: AppTheme.textPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                encadrant != null ? _initials(encadrant!.nomComplet) : '?',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1, right: 1,
            child: Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.surface, width: 1.5),
              ),
            ),
          ),
        ]),

        const SizedBox(width: 12),

        // ── Nom + statut ───────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                encadrant?.nomComplet ?? 'Encadrant',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Row(children: [
                Icon(Icons.circle, size: 7, color: AppTheme.success),
                SizedBox(width: 4),
                Text('En ligne',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w500,
                    )),
              ]),
            ],
          ),
        ),

        // ── Bouton info ────────────────────────────────
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.info_outline_rounded,
              color: AppTheme.textSecond, size: 18),
        ),
      ]),
    );
  }
}