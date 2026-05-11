// lib/features/encadrant/widgets/chat/chat_app_bar.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class ChatAppBar extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  const ChatAppBar({super.key, required this.stagiaire});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        12,
        MediaQuery.of(context).padding.top + 10,
        16,
        12,
      ),
      child: Row(
        children: [
          // Bouton retour
          GestureDetector(
            onTap: () => context.router.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), width: 0.5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Avatar
          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stagiaire.initials,
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
                bottom: 1,
                right: 1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8FAFC),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),

          // Nom + statut
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stagiaire.nomComplet,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'En ligne',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}