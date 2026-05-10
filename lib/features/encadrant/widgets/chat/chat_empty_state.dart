// lib/features/encadrant/widgets/chat/chat_empty_state.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// État vide : aucun message dans la conversation
class ChatEmptyState extends StatelessWidget {
  final String nomComplet;

  const ChatEmptyState({super.key, required this.nomComplet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppTheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Démarrez la conversation',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: AppTheme.textDark),
          ),
          const SizedBox(height: 5),
          Text(
            'Envoyez un message à $nomComplet',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// État d'erreur avec bouton retry
class ChatErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ChatErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.darkSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: AppTheme.dark,
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Impossible de charger',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: AppTheme.dark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}