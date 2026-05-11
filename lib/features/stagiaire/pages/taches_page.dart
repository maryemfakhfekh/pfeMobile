// lib/features/stagiaire/pages/taches_page.dart

// lib/features/stagiaire/pages/taches_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';         // ← 3 niveaux
import '../../../core/theme/app_theme.dart';       // ← 3 niveaux
import '../data/models/tache_model.dart';          // ← 1 niveau
import '../logic/tache_bloc.dart';                 // ← 1 niveau
import '../widgets/taches/tache_card.dart';        // ← 1 niveau
import '../widgets/taches/taches_header.dart';     // ← 1 niveau
import '../widgets/taches/tache_detail_sheet.dart';// ← 1 niveau
import '../widgets/taches/taches_empty_error.dart';// ← 1 niveau

class TachesPage extends StatelessWidget {
  const TachesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TacheBloc>()..add(LoadTaches()),
      child: const _TachesView(),
    );
  }
}

class _TachesView extends StatefulWidget {
  const _TachesView();

  @override
  State<_TachesView> createState() => _TachesViewState();
}

class _TachesViewState extends State<_TachesView> {
  bool _isDetailed = true;

  Map<String, List<TacheModel>> _groupByPeriod(List<TacheModel> taches) {
    final now    = DateTime.now();
    final groups = <String, List<TacheModel>>{
      'Cette semaine': [],
      'Ce mois':       [],
      'Plus tard':     [],
    };
    for (final t in taches) {
      final due = DateTime.tryParse(t.dateEcheance);
      if (due == null) { groups['Plus tard']!.add(t); continue; }
      final diff = due.difference(now).inDays;
      if (diff <= 7)       groups['Cette semaine']!.add(t);
      else if (diff <= 30) groups['Ce mois']!.add(t);
      else                 groups['Plus tard']!.add(t);
    }
    groups.removeWhere((_, v) => v.isEmpty);
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TacheBloc, TacheState>(
      builder: (context, state) {
        if (state is TacheLoading || state is TacheInitial) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppTheme.primary, strokeWidth: 2),
          );
        }

        if (state is TacheError) {
          return TachesErrorView(
            onRetry: () => context.read<TacheBloc>().add(LoadTaches()),
          );
        }

        final taches =
        state is TacheLoaded ? state.taches : <TacheModel>[];

        return Column(
          children: [
            TachesHeader(
              total:      taches.length,
              isDetailed: _isDetailed,
              onToggle:   (v) => setState(() => _isDetailed = v),
              onRefresh:  () => context.read<TacheBloc>().add(LoadTaches()),
            ),
            Expanded(
              child: _isDetailed
                  ? _buildDetailed(context, taches)
                  : _buildList(context, taches),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailed(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return const TachesEmptyView();
    final groups = _groupByPeriod(taches);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final title = groups.keys.elementAt(i);
        final list  = groups.values.elementAt(i);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Label groupe ──────────────────────────────
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: i == 0 ? 0 : 20),
              child: Row(children: [
                Text(title,
                    style: const TextStyle(fontFamily: 'Poppins',
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A))),
                const SizedBox(width: 8),
                Expanded(child: Container(
                    height: 0.5, color: const Color(0xFFE2E8F0))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${list.length}',
                      style: const TextStyle(fontFamily: 'Poppins',
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ]),
            ),

            // ── Cards groupe ──────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), width: 0.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03),
                      blurRadius: 4, offset: const Offset(0, 1)),
                ],
              ),
              child: Column(
                children: list.asMap().entries.map((e) {
                  final idx = e.key;
                  final t   = e.value;
                  return Column(children: [
                    TacheCard(
                      tache:          t,
                      isDetailed:     true,
                      onTap:          () => TacheDetailSheet.show(ctx, t),
                      onStatutChange: (s) => ctx.read<TacheBloc>()
                          .add(UpdateStatutTache(t.id, s)),
                    ),
                    if (idx < list.length - 1)
                      const Divider(color: Color(0xFFE2E8F0),
                          height: 1, indent: 16, endIndent: 16),
                  ]);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return const TachesEmptyView();

    return Column(children: [
      // ── En-tête colonnes ────────────────────────────────
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Row(children: [
          Expanded(flex: 5,
              child: Text('Tâche',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                      fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)))),
          Text('Priorité',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
          SizedBox(width: 16),
          Text('Statut',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
          SizedBox(width: 16),
        ]),
      ),
      const Divider(color: Color(0xFFE2E8F0), height: 1),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 40),
          itemCount: taches.length,
          separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          itemBuilder: (context, i) => TacheCard(
            tache:          taches[i],
            isDetailed:     false,
            onTap:          () => TacheDetailSheet.show(ctx, taches[i]),
            onStatutChange: (s) => ctx.read<TacheBloc>()
                .add(UpdateStatutTache(taches[i].id, s)),
          ),
        ),
      ),
    ]);
  }
}