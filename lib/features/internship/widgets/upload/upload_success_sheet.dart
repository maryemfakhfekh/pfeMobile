import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

void showUploadSuccessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    isScrollControlled: true,
    builder: (_) => const _SuccessSheetContent(),
  );
}

class _SuccessSheetContent extends StatelessWidget {
  const _SuccessSheetContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Handle ───────────────────────────────────
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppTheme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 28),

          // ── Icône success ─────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success.withOpacity(0.06),
                ),
              ),
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success.withOpacity(0.1),
                  border: Border.all(
                    color: AppTheme.success.withOpacity(0.25),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 58, height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Candidature envoyée !',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            "Votre dossier est maintenant en attente.\nL'encadrant examinera votre candidature.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecond,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          // ── Timeline ──────────────────────────────────
          _UploadStatusTimeline(),

          const SizedBox(height: 28),

          // ── Bouton retour ─────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.router.popUntilRoot(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusMD),
                ),
              ),
              child: const Text(
                "Retour à l'accueil",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadStatusTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      (
      'Dépôt du CV',
      true,
      false,
      Icons.upload_file_rounded,
      'Fait'
      ),
      (
      'En attente de validation',
      true,
      true,
      Icons.hourglass_top_rounded,
      'En cours'
      ),
      (
      'Réponse encadrant',
      false,
      false,
      Icons.mark_email_unread_outlined,
      ''
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final (label, done, isPending, icon, badge) = steps[i];

          final color = done
              ? isPending
              ? AppTheme.primary
              : AppTheme.success
              : AppTheme.textLight;

          final bg = done
              ? isPending
              ? AppTheme.primarySoft
              : const Color(0xFFF0FDF4)
              : AppTheme.background;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: bg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(icon, size: 14, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: done
                            ? AppTheme.textPrimary
                            : AppTheme.textLight,
                        fontSize: 13,
                        fontWeight: done
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (badge.isNotEmpty)
                    _StatusBadge(
                      label: badge,
                      color: isPending
                          ? AppTheme.primary
                          : AppTheme.success,
                    ),
                ],
              ),
              if (i < steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 2, height: 18,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppTheme.success.withOpacity(0.3)
                              : AppTheme.border,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}