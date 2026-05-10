import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/models/sujet_model.dart';
import '../widgets/detail/Section_card.dart';
import '../widgets/detail/Skill_tag.dart';
import '../widgets/detail/Subject_apply_button.dart';
import '../widgets/detail/Subject_detail_header.dart';
import '../widgets/detail/Subject_info_card.dart';

@RoutePage()
class SubjectDetailPage extends StatelessWidget {
  final SujetModel sujet;
  const SubjectDetailPage({super.key, required this.sujet});

  static const _domainIcons = {
    'informatique': Icons.code_rounded,
    'génie civil':  Icons.architecture_rounded,
    'électronique': Icons.electrical_services_rounded,
    'mécanique':    Icons.settings_rounded,
    'gestion':      Icons.bar_chart_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final domainKey = sujet.filiereCible.toLowerCase();
    final icon = _domainIcons.entries
        .firstWhere(
          (e) => domainKey.contains(e.key),
      orElse: () =>
      const MapEntry('default', Icons.work_outline_rounded),
    )
        .value;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          SubjectDetailHeader(sujet: sujet, domainIcon: icon),

          // ── Divider ───────────────────────────────────
          Container(height: 1, color: AppTheme.border),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 4),

                  // ── Info card ─────────────────────────
                  SubjectInfoCard(sujet: sujet),

                  const SizedBox(height: 16),

                  // ── Description ───────────────────────
                  SectionCard(
                    title: 'Description',
                    icon: Icons.description_outlined,
                    child: Text(
                      sujet.description,
                      style: const TextStyle(
                        color: AppTheme.textSecond,
                        fontSize: 14,
                        height: 1.75,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Compétences ───────────────────────
                  if (sujet.competencesCibles.isNotEmpty) ...[
                    SectionCard(
                      title: 'Compétences requises',
                      icon: Icons.psychology_outlined,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sujet.competencesCibles
                            .map((c) => SkillTag(label: c))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Date publication ──────────────────
                  _PublicationDate(date: sujet.datePublication),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SubjectApplyButton(sujet: sujet),
    );
  }
}

// ── Date de publication ───────────────────────────────────────────
class _PublicationDate extends StatelessWidget {
  final DateTime date;
  const _PublicationDate({required this.date});

  String _formatDate(DateTime d) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Date de publication',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(date),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}