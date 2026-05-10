import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UploadFilePreview extends StatelessWidget {
  final String fileName;
  final int? fileSize;
  final String Function(int) formatSize;
  final VoidCallback onReplace;

  const UploadFilePreview({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.formatSize,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(
          color: AppTheme.success.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Fichier info ─────────────────────────────
          Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius:
                  BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(
                    color: AppTheme.error.withOpacity(0.15),
                  ),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppTheme.error,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (fileSize != null)
                          Text(
                            formatSize(fileSize!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(
                                AppTheme.radiusXS),
                            border: Border.all(
                              color: AppTheme.success.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppTheme.success,
                                size: 10,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Valide',
                                style: TextStyle(
                                  color: AppTheme.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.border),
          const SizedBox(height: 12),

          // ── Prêt à soumettre ─────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppTheme.success,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Fichier prêt à être soumis',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Changer fichier ──────────────────────────
          GestureDetector(
            onTap: onReplace,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swap_horiz_rounded,
                  size: 15,
                  color: AppTheme.textLight,
                ),
                SizedBox(width: 6),
                Text(
                  'Changer de fichier',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}