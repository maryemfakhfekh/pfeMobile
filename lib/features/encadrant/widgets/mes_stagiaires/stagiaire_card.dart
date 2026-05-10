// lib/features/encadrant/widgets/mes_stagiaires/stagiaire_card.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class StagiaireCard extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  const StagiaireCard({super.key, required this.stagiaire});

  @override
  State<StagiaireCard> createState() => _StagiaireCardState();
}

class _StagiaireCardState extends State<StagiaireCard> {
  bool _expanded = false;

  String _badgeLabel(int pct) {
    if (pct >= 80) return 'Excellent';
    if (pct >= 50) return 'En bonne voie';
    if (pct >= 20) return 'En cours';
    return 'Démarrage';
  }

  Color _badgeColor(int pct) {
    if (pct >= 80) return const Color(0xFF16A34A);
    if (pct >= 50) return AppTheme.primary;
    if (pct >= 20) return const Color(0xFFB45309);
    return const Color(0xFF64748B);
  }

  Color _badgeBg(int pct) {
    if (pct >= 80) return const Color(0xFFEAFAF0);
    if (pct >= 50) return AppTheme.primarySoft;
    if (pct >= 20) return const Color(0xFFFEF3C7);
    return const Color(0xFFF1F5F9);
  }

  Color _pctColor(int pct) {
    if (pct >= 70) return const Color(0xFF16A34A);
    if (pct >= 40) return AppTheme.primary;
    return const Color(0xFF94A3B8);
  }

  @override
  Widget build(BuildContext context) {
    final s   = widget.stagiaire;
    final pct = (s.progressionGlobale * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Ligne principale ───────────────────────────
            Row(
              children: [

                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      s.initials,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Nom + sujet
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                          child: Text(
                            s.nomComplet,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 3),
                      Text(
                        s.sujetTitre,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // % progression + chevron
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$pct%',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _pctColor(pct),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'progression',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: () =>
                      setState(() => _expanded = !_expanded),
                  child: Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Barre de progression ───────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: s.progressionGlobale,
                backgroundColor: const Color(0xFFE2E8F0),
                color: _pctColor(pct),
                minHeight: 4,
              ),
            ),

            const SizedBox(height: 10),

            // ── Séparateur ─────────────────────────────────
            const Divider(
              color: Color(0xFFE2E8F0),
              height: 1,
              thickness: 0.5,
            ),

            const SizedBox(height: 10),

            // ── Badges ─────────────────────────────────────
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: _badgeBg(pct),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _badgeColor(pct),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _badgeLabel(pct),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _badgeColor(pct),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 11,
                          color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        '${s.tachesTerminees}/${s.tachesTotales} tâches',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (s.rapportDepose)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAFAF0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.description_outlined,
                            size: 11,
                            color: Color(0xFF16A34A)),
                        SizedBox(width: 4),
                        Text(
                          'Rapport ✓',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // ── Détails expandables ────────────────────────
            if (_expanded) ...[
              const SizedBox(height: 12),
              const Divider(
                  color: Color(0xFFE2E8F0),
                  height: 1,
                  thickness: 0.5),
              const SizedBox(height: 12),
              _InfoRow(
                  icon: Icons.school_outlined,
                  label: 'Filière',
                  value: s.filiere),
              _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Période',
                  value:
                  '${s.dateDebut} — ${s.dateFin ?? "En cours"}'),
              _InfoRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: s.email),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: _ActionBtn(
                    label: 'Message',
                    icon: Icons.chat_bubble_outline_rounded,
                    color: AppTheme.primary,
                    filled: false,
                    onTap: () => context.router
                        .push(EncadrantChatRoute(stagiaire: s)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionBtn(
                    label: 'Voir détail',
                    icon: Icons.arrow_forward_rounded,
                    color: const Color(0xFF1E293B),
                    filled: true,
                    onTap: () => context.router
                        .push(DetailStagiaireRoute(stagiaire: s)),
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 13, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: filled ? Colors.white : color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: filled ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}