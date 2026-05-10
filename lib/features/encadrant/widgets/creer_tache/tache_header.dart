import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TacheHeader extends StatelessWidget {
  const TacheHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(16, top + 14, 16, 16),
      child: Row(children: [
        _BackButton(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Créer une tâche',
                  style: Theme.of(context).textTheme.headlineLarge!
                      .copyWith(color: AppTheme.textDark)),
              const SizedBox(height: 2),
              Text('La tâche sera assignée au stagiaire',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ]),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.back(),
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: AppTheme.darkSoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 15, color: AppTheme.dark),
      ),
    );
  }
}