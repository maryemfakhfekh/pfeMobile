import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class InfosTabView extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  const InfosTabView({super.key, required this.stagiaire});

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final d = DateTime.parse(raw);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = stagiaire;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [

        // ── Informations personnelles ──────────────────
        _SectionCard(
          title: 'Informations personnelles',
          icon: Icons.person_rounded,
          iconColor: AppTheme.primary,
          iconBg: AppTheme.primarySoft,
          children: [
            _InfoTile(
              icon: Icons.badge_outlined,
              label: 'Nom complet',
              value: s.nomComplet,
            ),
            _InfoTile(
              icon: Icons.email_outlined,
              label: 'Email',
              value: s.email,
            ),
            _InfoTile(
              icon: Icons.school_outlined,
              label: 'Filière',
              value: s.filiere,
              isLast: true,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Période de stage ───────────────────────────
        _SectionCard(
          title: 'Période de stage',
          icon: Icons.calendar_month_rounded,
          iconColor: AppTheme.info,
          iconBg: AppTheme.infoBg,
          children: [
            _InfoTile(
              icon: Icons.play_circle_outline_rounded,
              label: 'Début',
              value: _formatDate(s.dateDebut),
            ),
            _InfoTile(
              icon: Icons.stop_circle_outlined,
              label: 'Fin',
              value: _formatDate(s.dateFin),
              isLast: true,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Sujet ──────────────────────────────────────
        _SectionCard(
          title: 'Sujet de stage',
          icon: Icons.work_outline_rounded,
          iconColor: AppTheme.dark,
          iconBg: AppTheme.darkSoft,
          children: [
            _InfoTile(
              icon: Icons.lightbulb_outline_rounded,
              label: 'Titre',
              value: s.sujetTitre,
              isLast: true,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Progression ────────────────────────────────
        _SectionCard(
          title: 'Progression',
          icon: Icons.insights_rounded,
          iconColor: AppTheme.success,
          iconBg: AppTheme.successSoft,
          children: [
            _InfoTile(
              icon: Icons.checklist_rounded,
              label: 'Tâches terminées',
              value: '${s.tachesTerminees} / ${s.tachesTotales}',
              valueColor: s.tachesTerminees == s.tachesTotales && s.tachesTotales > 0
                  ? AppTheme.success
                  : null,
            ),
            _InfoTile(
              icon: Icons.description_outlined,
              label: 'Rapport déposé',
              value: s.rapportDepose ? 'Oui ✓' : 'Non',
              valueColor: s.rapportDepose ? AppTheme.success : AppTheme.error,
              isLast: true,
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section card avec header coloré
// ─────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 15, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.border, height: 1),
          // Rows
          ...children,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info tile individuelle
// ─────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textLight),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: valueColor ?? AppTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            color: AppTheme.border,
            height: 1,
            indent: 44,
          ),
      ],
    );
  }
}