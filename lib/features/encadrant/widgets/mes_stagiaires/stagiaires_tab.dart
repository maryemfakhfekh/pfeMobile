// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_state.dart';
import 'stagiaire_card.dart';
import 'stagiaires_empty.dart';
import 'stagiaires_search_bar.dart';

const _avatarColors = [
  Color(0xFF1E293B),
  Color(0xFF0F6E56),
  Color(0xFF534AB7),
  Color(0xFF993556),
  Color(0xFF185FA5),
  Color(0xFF854F0B),
];

class StagiairesTab extends StatefulWidget {
  const StagiairesTab({super.key});

  @override
  State<StagiairesTab> createState() => _StagiairesTabState();
}

class _StagiairesTabState extends State<StagiairesTab> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (ctx, state) {
        final all = state.stagiaires;
        final filtered = _search.isEmpty
            ? all
            : all
            .where((s) => s.nomComplet
            .toLowerCase()
            .contains(_search.toLowerCase()))
            .toList();

        final avgProg = all.isEmpty
            ? 0
            : (all.fold(0.0, (s, x) => s + x.progressionGlobale) /
            all.length *
            100)
            .toInt();
        final terminees = all.fold(0, (s, x) => s + x.tachesTerminees);
        final aFaire = all.fold(
            0, (s, x) => s + (x.tachesTotales - x.tachesTerminees));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ───────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mes Stagiaires',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${all.length} stagiaire${all.length > 1 ? 's' : ''} actif${all.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFE2E8F0), height: 1),

            // ── Stats ────────────────────────────────────────
            if (all.isNotEmpty) ...[
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Avancement',
                      value: '$avgProg%',
                      valueColor: AppTheme.primary,
                      bg: const Color(0xFFFFF4ED),
                      dotColor: AppTheme.primary,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'Terminées',
                      value: '$terminees',
                      valueColor: const Color(0xFF16A34A),
                      bg: const Color(0xFFEAFAF0),
                      dotColor: const Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: 'À faire',
                      value: '$aFaire',
                      valueColor: const Color(0xFF64748B),
                      bg: const Color(0xFFF1F5F9),
                      dotColor: const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE2E8F0), height: 1),
            ],

            // ── Search ───────────────────────────────────────
            StagiairesSearchBar(
              onChanged: (v) => setState(() => _search = v),
            ),

            const Divider(color: Color(0xFFE2E8F0), height: 1),

            // ── Liste ────────────────────────────────────────
// ── Liste ────────────────────────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.white,
                child: filtered.isEmpty
                    ? const StagiairesEmpty()
                    : ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 14, 16, bottomInset + 100),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => StagiaireCard(
                    stagiaire: filtered[i],
                    avatarColor: _avatarColors[i % _avatarColors.length],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color bg;
  final Color dotColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.bg,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: valueColor,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: valueColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}