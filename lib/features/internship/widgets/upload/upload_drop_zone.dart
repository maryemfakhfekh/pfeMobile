import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UploadDropZone extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const UploadDropZone({
    super.key,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: AppTheme.shadowSM,
        ),
        child: Stack(
          children: [
            // ── Motif dots ───────────────────────────────
            Positioned.fill(
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(AppTheme.radiusLG),
                child: CustomPaint(
                  painter: _DotPatternPainter(),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Icône animée ──────────────────────
                  ScaleTransition(
                    scale: pulseAnimation,
                    child: Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.upload_file_rounded,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Titre ─────────────────────────────
                  const Text(
                    'Appuyer pour sélectionner',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'PDF uniquement · 5 MB max',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textLight,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Bouton parcourir ──────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusSM),
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      'Parcourir les fichiers →',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    const radius  = 1.5;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}