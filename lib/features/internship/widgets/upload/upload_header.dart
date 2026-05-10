import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UploadHeader extends StatelessWidget {
  const UploadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
          child: Row(
            children: [

              // ── Bouton retour ──────────────────────────
              GestureDetector(
                onTap: () => context.router.maybePop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius:
                    BorderRadius.circular(AppTheme.radiusSM),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.textPrimary,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // ── Titre + Subtitle ───────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Déposer ma candidature',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Étape 3 sur 3 · Upload CV',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecond,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}