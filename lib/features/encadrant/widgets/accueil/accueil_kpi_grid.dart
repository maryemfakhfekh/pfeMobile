// lib/features/encadrant/widgets/accueil/accueil_kpi_grid.dart

import 'package:flutter/material.dart';

class AccueilKpiGrid extends StatelessWidget {
  final int stagiairesActifs;
  final int tachesActives;
  final int tachesEnRetard;
  final int entretiensAVenir;
  final int evaluationsEnAttente;

  const AccueilKpiGrid({
    super.key,
    required this.stagiairesActifs,
    required this.tachesActives,
    required this.tachesEnRetard,
    required this.entretiensAVenir,
    required this.evaluationsEnAttente,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.people_alt_outlined,
                iconColor: const Color(0xFF185FA5),
                iconBg: const Color(0xFFE6F1FB),
                value: '$stagiairesActifs',
                label: 'Stagiaires actifs',
                tag: 'actifs',
                tagColor: const Color(0xFF085041),
                tagBg: const Color(0xFFE1F5EE),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                icon: Icons.checklist_rounded,
                iconColor: const Color(0xFF3C3489),
                iconBg: const Color(0xFFEEEDFE),
                value: '$tachesActives',
                label: 'Tâches actives',
                tag: tachesEnRetard > 0 ? '$tachesEnRetard en retard' : null,
                tagColor: const Color(0xFF633806),
                tagBg: const Color(0xFFFAEEDA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF0F6E56),
                iconBg: const Color(0xFFE1F5EE),
                value: '$entretiensAVenir',
                label: 'Entretiens à venir',
                tag: 'cette sem.',
                tagColor: const Color(0xFF185FA5),
                tagBg: const Color(0xFFE6F1FB),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                icon: Icons.star_outline_rounded,
                iconColor: const Color(0xFF993C1D),
                iconBg: const Color(0xFFFAECE7),
                value: '$evaluationsEnAttente',
                label: 'Éval. en attente',
                tag: evaluationsEnAttente > 0 ? 'urgent' : null,
                tagColor: const Color(0xFFA32D2D),
                tagBg: const Color(0xFFFCEBEB),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String? tag;
  final Color? tagColor;
  final Color? tagBg;

  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    this.tag,
    this.tagColor,
    this.tagBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 17),
              ),
              if (tag != null)
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: tagColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -1,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}