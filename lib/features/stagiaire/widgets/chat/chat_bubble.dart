// lib/features/stagiaire/widgets/chat/chat_bubble.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../chat/data/models/message_model.dart';
import '../../data/models/stagiaire_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel    message;
  final EncadrantModel? encadrant;

  const ChatBubble({
    super.key,
    required this.message,
    this.encadrant,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  String _formatTime(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          // ── Avatar encadrant ───────────────────────────
          if (!isMine) ...[
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                  color: AppTheme.textPrimary, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  encadrant != null
                      ? _initials(encadrant!.nomComplet)
                      : '?',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],

          // ── Bulle message ──────────────────────────────
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMine ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(16),
                      topRight:    const Radius.circular(16),
                      bottomLeft:  Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                    boxShadow: isMine ? null : AppTheme.shadowSM,
                  ),
                  child: Text(
                    message.contenu,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: isMine ? Colors.white : AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.dateEnvoi),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      color: AppTheme.textLight),
                ),
              ],
            ),
          ),

          if (isMine) const SizedBox(width: 4),
        ],
      ),
    );
  }
}