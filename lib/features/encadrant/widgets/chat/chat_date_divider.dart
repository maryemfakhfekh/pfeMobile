// lib/features/encadrant/widgets/chat/chat_date_divider.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChatDateDivider extends StatelessWidget {
  final String dateStr;

  const ChatDateDivider({super.key, required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppTheme.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _formatDate(dateStr),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Expanded(child: Divider(color: AppTheme.border)),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        return "Aujourd'hui";
      }
      final yesterday = now.subtract(const Duration(days: 1));
      if (d.year == yesterday.year &&
          d.month == yesterday.month &&
          d.day == yesterday.day) {
        return 'Hier';
      }
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

/// Utilitaire partagé pour comparer deux dates
bool isSameDay(String a, String b) {
  try {
    final da = DateTime.parse(a);
    final db = DateTime.parse(b);
    return da.year == db.year && da.month == db.month && da.day == db.day;
  } catch (_) {
    return false;
  }
}