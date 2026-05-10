// lib/features/encadrant/widgets/chat/conversation_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class ConversationCard extends StatelessWidget {
  final StagiaireEncadrantModel s;
  const ConversationCard({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(EncadrantChatRoute(stagiaire: s)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          boxShadow: AppTheme.shadowSM,
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Stack(children: [
            Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                  color: AppTheme.dark, shape: BoxShape.circle),
              child: Center(
                child: Text(s.initials,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ),
            ),
            Positioned(
              bottom: 1, right: 1,
              child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.surface, width: 2),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.nomComplet,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: AppTheme.textDark)),
                const SizedBox(height: 2),
                Text(s.sujetTitre,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppTheme.textLight, size: 22),
        ]),
      ),
    );
  }
}