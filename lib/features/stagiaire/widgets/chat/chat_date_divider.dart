// lib/features/stagiaire/widgets/chat/chat_date_divider.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChatDateDivider extends StatelessWidget {
  final String dateStr;

  const ChatDateDivider({super.key, required this.dateStr});

  String _formatDate(String dateStr) {
    try {
      final d   = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (d.year == now.year &&
          d.month == now.month &&
          d.day == now.day) {
        return "Aujourd'hui";
      }
      final hier = now.subtract(const Duration(days: 1));
      if (d.year == hier.year &&
          d.month == hier.month &&
          d.day == hier.day) {
        return 'Hier';
      }
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            _formatDate(dateStr),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppTheme.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ]),
    );
  }
}