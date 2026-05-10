// lib/features/encadrant/widgets/taches/tache_stat_pill.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TacheStatPill extends StatelessWidget {
  final String label;
  final int count;
  final Color dotColor;

  const TacheStatPill(this.label, this.count, this.dotColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(children: [
          Container(
            width: 10, height: 10,
            decoration:
            BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(height: 8),
          Text('$count',
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textDark)),
          const SizedBox(height: 3),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ]),
      ),
    );
  }
}