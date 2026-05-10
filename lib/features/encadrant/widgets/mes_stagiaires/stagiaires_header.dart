// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_header.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StagiairesHeader extends StatelessWidget {
  final int count;

  const StagiairesHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          _BackButton(),
          const SizedBox(width: 14),
          _TitleBlock(count: count),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.back(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.darkSoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppTheme.dark,
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final int count;
  const _TitleBlock({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mes Stagiaires',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: AppTheme.textDark),
        ),
        Text(
          '$count stagiaires actifs',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}