// lib/features/stagiaire/widgets/chat/chat_input.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback          onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      child: Row(children: [

        // ── Champ texte ────────────────────────────────
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Écrire un message...',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppTheme.textLight,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              maxLines: null,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ── Bouton envoyer ─────────────────────────────
        GestureDetector(
          onTap: onSend,
          child: Container(
            width: 42, height: 42,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send_rounded,
                color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }
}