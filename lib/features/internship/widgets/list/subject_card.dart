import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sujet_model.dart';

class SubjectCard extends StatelessWidget {
  final SujetModel sujet;
  final int index;
  final Animation<double> animation;

  const SubjectCard({
    super.key,
    required this.sujet,
    required this.index,
    required this.animation,
  });

  static const _domainIcons = {
    'informatique': Icons.code_rounded,
    'génie civil':  Icons.architecture_rounded,
    'électronique': Icons.electrical_services_rounded,
    'mécanique':    Icons.settings_rounded,
    'gestion':      Icons.bar_chart_rounded,
  };

  static const _iconColors = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF059669),
    Color(0xFFDB2777),
    Color(0xFF0891B2),
  ];

  static const _iconBgs = [
    Color(0xFFEFF6FF),
    Color(0xFFF5F3FF),
    Color(0xFFF0FDF4),
    Color(0xFFFDF2F8),
    Color(0xFFECFEFF),
  ];

  @override
  Widget build(BuildContext context) {
    final iconColor = _iconColors[index % _iconColors.length];
    final iconBg    = _iconBgs[index % _iconBgs.length];
    final domainKey = sujet.filiereCible.toLowerCase();
    final icon = _domainIcons.entries
        .firstWhere(
          (e) => domainKey.contains(e.key),
      orElse: () =>
      const MapEntry('default', Icons.work_outline_rounded),
    )
        .value;

    return FadeTransition(
      opacity: animation,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - animation.value)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () =>
                context.router.push(SubjectDetailRoute(sujet: sujet)),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.shadowSM,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top row ─────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Icône domaine ──────────────
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius:
                          BorderRadius.circular(AppTheme.radiusSM),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),

                      const SizedBox(width: 12),

                      // ── Titre + Tags ───────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    sujet.titre,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // ── Status dot ────────
                                Container(
                                  width: 8, height: 8,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    color: sujet.estDisponible
                                        ? AppTheme.success
                                        : AppTheme.textLight,
                                    shape: BoxShape.circle,
                                    boxShadow: sujet.estDisponible
                                        ? [
                                      BoxShadow(
                                        color: AppTheme.success
                                            .withOpacity(0.4),
                                        blurRadius: 6,
                                      )
                                    ]
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // ── Tags ──────────────────
                            Row(
                              children: [
                                _buildTag(
                                  sujet.filiereCible,
                                  iconColor,
                                  iconBg,
                                ),
                                const SizedBox(width: 6),
                                _buildTag(
                                  sujet.cycleCible,
                                  AppTheme.textSecond,
                                  AppTheme.background,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppTheme.border),
                  const SizedBox(height: 12),

                  // ── Description ─────────────────────
                  Text(
                    sujet.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecond,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // ── Skills ──────────────────────────
                  if (sujet.competencesCibles.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6, runSpacing: 6,
                      children: sujet.competencesCibles
                          .take(3)
                          .map((c) => _buildSkillChip(c))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Footer ──────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(sujet.datePublication),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // ── Voir détail btn ─────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primarySoft,
                          borderRadius:
                          BorderRadius.circular(AppTheme.radiusSM),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Voir le détail',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 11,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecond,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return "Hier";
    return "Il y a $diff jours";
  }
}