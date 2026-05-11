// lib/features/stagiaire/widgets/dashboard/notif_section_label.dart

import 'package:flutter/material.dart';

class NotifSectionLabel extends StatelessWidget {
  final String   label;
  final Color    color;
  final IconData icon;

  const NotifSectionLabel({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}