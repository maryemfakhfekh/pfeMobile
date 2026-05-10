// lib/features/encadrant/widgets/taches/tache_badge.dart

import 'package:flutter/material.dart';

class TacheBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData icon;

  const TacheBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }
}