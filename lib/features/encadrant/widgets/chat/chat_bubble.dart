// lib/features/encadrant/widgets/chat/chat_bubble.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class ChatBubble extends StatelessWidget {
  final dynamic message;
  final StagiaireEncadrantModel stagiaire;

  const ChatBubble({
    super.key,
    required this.message,
    required this.stagiaire,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stagiaire.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppTheme.primary
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                      Radius.circular(isMine ? 16 : 4),
                      bottomRight:
                      Radius.circular(isMine ? 4 : 16),
                    ),
                    border: isMine
                        ? null
                        : Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.5),
                    boxShadow: isMine
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      )
                    ],
                  ),
                  child: Text(
                    message.contenu as String,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: isMine
                          ? Colors.white
                          : const Color(0xFF0F172A),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.dateEnvoi as String),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          if (isMine) const SizedBox(width: 4),
        ],
      ),
    );
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
}