// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_state.dart';
import 'stagiaire_card.dart';
import 'stagiaires_empty.dart';
import 'stagiaires_search_bar.dart';

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
        final aFaire =
        all.fold(0, (s, x) => s + (x.tachesTotales - x.tachesTerminees));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header aligné à gauche ───────────────────
            Container(
              color: AppTheme.surface,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mes Stagiaires',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${all.length} stagiaire${all.length > 1 ? 's' : ''} actif${all.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppTheme.border, height: 1),

            // ── Stats compactes ─────────────────────────────
            if (all.isNotEmpty) ...[
              Container(
                color: AppTheme.background,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    _StatChip(
                        label: 'Avancement',
                        value: '$avgProg%',
                        color: AppTheme.primary,
                        bg: AppTheme.primarySoft),
                    const SizedBox(width: 8),
                    _StatChip(
                        label: 'Terminées',
                        value: '$terminees',
                        color: AppTheme.success,
                        bg: AppTheme.successSoft),
                    const SizedBox(width: 8),
                    _StatChip(
                        label: 'À faire',
                        value: '$aFaire',
                        color: AppTheme.textLight,
                        bg: AppTheme.darkSoft),
                  ],
                ),
              ),
              const Divider(color: AppTheme.border, height: 1),
            ],

            // ── Search ───────────────────────────────────────
            StagiairesSearchBar(
              onChanged: (v) => setState(() => _search = v),
            ),

            const Divider(color: AppTheme.border, height: 1),

            // ── Liste ────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? const StagiairesEmpty()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
                itemCount: filtered.length,
                itemBuilder: (_, i) =>
                    StagiaireCard(stagiaire: filtered[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Stat chip compact ─────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}