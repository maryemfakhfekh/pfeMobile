// lib/features/encadrant/widgets/taches/tache_empty.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TacheEmpty extends StatelessWidget {
  const TacheEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppTheme.darkSoft,
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          ),
          child: const Icon(Icons.task_alt_rounded,
              color: AppTheme.dark, size: 28),
        ),
        const SizedBox(height: 14),
        Text('Aucune tâche',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.textDark)),
        const SizedBox(height: 6),
        Text('Appuyez sur + pour créer une tâche',
            style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}