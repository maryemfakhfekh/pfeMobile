import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sujet_model.dart';

class SubjectApplyButton extends StatelessWidget {
  final SujetModel sujet;
  const SubjectApplyButton({super.key, required this.sujet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Message si indisponible ──────────────────
          if (!sujet.estDisponible) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                border: Border.all(
                    color: AppTheme.error.withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: AppTheme.error),
                  SizedBox(width: 6),
                  Text(
                    "Ce sujet n'accepte plus de candidatures",
                    style: TextStyle(
                      color: AppTheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Bouton postuler ──────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: sujet.estDisponible
                  ? () => context.router
                  .push(UploadCvRoute(sujetId: sujet.id))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor: AppTheme.border,
                foregroundColor: Colors.white,
                disabledForegroundColor: AppTheme.textLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusMD),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sujet.estDisponible
                        ? Icons.send_rounded
                        : Icons.block_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sujet.estDisponible
                        ? 'Postuler à ce sujet'
                        : 'Sujet complet',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}