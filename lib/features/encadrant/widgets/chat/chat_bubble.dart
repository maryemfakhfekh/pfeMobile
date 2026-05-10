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
            _OtherAvatar(initials: stagiaire.initials),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _BubbleContent(
                  contenu: message.contenu as String,
                  isMine: isMine,
                ),
                const SizedBox(height: 3),
                _TimeLabel(
                  dateStr: message.dateEnvoi as String,
                  context: context,
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

class _OtherAvatar extends StatelessWidget {
  final String initials;
  const _OtherAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppTheme.dark,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final String contenu;
  final bool isMine;
  const _BubbleContent({required this.contenu, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: isMine ? AppTheme.primary : AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMine ? 16 : 4),
          bottomRight: Radius.circular(isMine ? 4 : 16),
        ),
        border: isMine ? null : Border.all(color: AppTheme.border),
        boxShadow: isMine ? null : AppTheme.shadowLight,
      ),
      child: Text(
        contenu,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: isMine ? Colors.white : AppTheme.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  final String dateStr;
  final BuildContext context;
  const _TimeLabel({required this.dateStr, required this.context});

  @override
  Widget build(BuildContext _) {
    return Text(
      _formatTime(dateStr),
      style: Theme.of(context).textTheme.labelSmall,
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