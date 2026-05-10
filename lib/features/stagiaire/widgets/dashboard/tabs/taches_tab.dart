// lib/features/stagiaire/widgets/dashboard/tabs/taches_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../../../logic/tache_bloc.dart';
import '../../stagiaire_ui_tokens.dart';
import '../taches/tache_card.dart';

class TachesTab extends StatelessWidget {
  const TachesTab({super.key});

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

  int _count(List<TacheModel> t, TacheStatut s) =>
      t.where((x) => x.statut == s).length;

  Map<String, List<TacheModel>> _groupByPeriod(List<TacheModel> taches) {
    final now    = DateTime.now();
    final groups = <String, List<TacheModel>>{
      'CETTE SEMAINE': [],
      'CE MOIS':       [],
      'PLUS TARD':     [],
    };
    for (final t in taches) {
      final due  = DateTime.tryParse(t.dateEcheance);
      if (due == null) { groups['PLUS TARD']!.add(t); continue; }
      final diff = due.difference(now).inDays;
      if (diff <= 7)       groups['CETTE SEMAINE']!.add(t);
      else if (diff <= 30) groups['CE MOIS']!.add(t);
      else                 groups['PLUS TARD']!.add(t);
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
          return _ErrorView(
            onRetry: () =>
                context.read<TacheBloc>().add(LoadTaches()),
          );
        }

        final taches    = state is TacheLoaded
            ? state.taches : <TacheModel>[];
        final terminees = _count(taches, TacheStatut.terminee);
        final enCours   = _count(taches, TacheStatut.enCours);
        final aFaire    = _count(taches, TacheStatut.aFaire);

        return Column(
          children: [
            _Header(
              total:      taches.length,
              terminees:  terminees,
              enCours:    enCours,
              aFaire:     aFaire,
              isDetailed: _isDetailed,
              onToggle:   (v) => setState(() => _isDetailed = v),
              onRefresh:  () =>
                  context.read<TacheBloc>().add(LoadTaches()),
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

  // ── Vue détaillée ───────────────────────────────────────
  Widget _buildDetailed(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return const _EmptyView();
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
            // ── Label groupe ─────────────────────────────
            Padding(
              padding: EdgeInsets.only(
                  bottom: 10, top: i == 0 ? 0 : 22),
              child: Row(children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textLight,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${list.length}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecond,
                    ),
                  ),
                ),
              ]),
            ),
            // ── Groupe cards ─────────────────────────────
            Container(
              decoration: StagiaireUiTokens.cardDecoration(),
              child: Column(
                children: list.asMap().entries.map((e) {
                  final idx = e.key;
                  final t   = e.value;
                  return Column(children: [
                    TacheCard(
                      tache:        t,
                      isDetailed:   true,
                      onTap:        () => _showDetails(ctx, t),
                      onStatutChange: (s) => ctx
                          .read<TacheBloc>()
                          .add(UpdateStatutTache(t.id, s)),
                    ),
                    if (idx < list.length - 1)
                      Container(
                        height: 1,
                        color: AppTheme.border,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16),
                      ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Vue liste ───────────────────────────────────────────
  Widget _buildList(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return const _EmptyView();
    return Column(children: [
      // En-tête colonnes
      Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10),
        child: const Row(children: [
          Expanded(
            flex: 5,
            child: Text('Tâche',
                style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                )),
          ),
          Text('Priorité',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLight,
              )),
          SizedBox(width: 16),
          Text('Statut',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLight,
              )),
          SizedBox(width: 16),
        ]),
      ),
      Container(height: 1, color: AppTheme.border),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 40),
          itemCount:       taches.length,
          separatorBuilder: (_, __) =>
              Container(height: 1, color: AppTheme.border),
          itemBuilder: (context, i) => TacheCard(
            tache:      taches[i],
            isDetailed: false,
            onTap:      () => _showDetails(ctx, taches[i]),
            onStatutChange: (s) => ctx
                .read<TacheBloc>()
                .add(UpdateStatutTache(taches[i].id, s)),
          ),
        ),
      ),
    ]);
  }

  // ── Bottom sheet détails ────────────────────────────────
  void _showDetails(BuildContext ctx, TacheModel tache) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24)),
      ),
      builder: (bsCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          mainAxisSize:      MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              tache.titre,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),

            if (tache.description != null) ...[
              const SizedBox(height: 8),
              Text(
                tache.description!,
                style: StagiaireUiTokens.cardSubtitle.copyWith(
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],

            const SizedBox(height: 16),

            if (tache.dateEcheance.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppTheme.textLight),
                  const SizedBox(width: 8),
                  Text(
                    'Échéance : ${tache.dateEcheance}',
                    style: StagiaireUiTokens.cardSubtitle
                        .copyWith(fontSize: 13),
                  ),
                ]),
              ),

            const SizedBox(height: 16),

            // Boutons statut
            Row(children: [
              _StatutBtn(
                ctx: ctx, bsCtx: bsCtx, tache: tache,
                statut: TacheStatut.aFaire,   label: 'À faire',
              ),
              const SizedBox(width: 8),
              _StatutBtn(
                ctx: ctx, bsCtx: bsCtx, tache: tache,
                statut: TacheStatut.enCours,  label: 'En cours',
              ),
              const SizedBox(width: 8),
              _StatutBtn(
                ctx: ctx, bsCtx: bsCtx, tache: tache,
                statut: TacheStatut.terminee, label: 'Terminée',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Widgets extraits ────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int  total, terminees, enCours, aFaire;
  final bool isDetailed;
  final ValueChanged<bool> onToggle;
  final VoidCallback        onRefresh;

  const _Header({
    required this.total,
    required this.terminees,
    required this.enCours,
    required this.aFaire,
    required this.isDetailed,
    required this.onToggle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Titre + refresh
          Row(children: [
            const Expanded(
              child: Text(
                'Mes tâches',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Compteur total
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$total tâches',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecond,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.refresh_rounded,
                    color: AppTheme.textSecond, size: 18),
              ),
            ),
          ]),

          const SizedBox(height: 14),

          // Stats chips (alignées sur image 3)
          Row(children: [
            _StatChip(
              value: '$terminees',
              label: 'Terminées',
              color: StagiaireUiTokens.done,
              bg:    StagiaireUiTokens.done.withOpacity(0.10),
            ),
            const SizedBox(width: 8),
            _StatChip(
              value: '$enCours',
              label: 'En cours',
              color: StagiaireUiTokens.inProgress,
              bg:    AppTheme.primarySoft,
            ),
            const SizedBox(width: 8),
            _StatChip(
              value: '$aFaire',
              label: 'À faire',
              color: AppTheme.textSecond,
              bg:    AppTheme.background,
            ),
          ]),

          const SizedBox(height: 12),

          // Toggle Détaillé / Liste
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToggleBtn(
                  label:  'Détaillé',
                  active: isDetailed,
                  onTap:  () => onToggle(true),
                ),
                _ToggleBtn(
                  label:  'Liste',
                  active: !isDetailed,
                  onTap:  () => onToggle(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value, label;
  final Color  color, bg;
  const _StatChip({
    required this.value, required this.label,
    required this.color, required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(value,
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 13,
              fontWeight: FontWeight.w800, color: color,
            )),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.7),
            )),
      ]),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String   label;
  final bool     active;
  final VoidCallback onTap;
  const _ToggleBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppTheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: active ? AppTheme.shadowSM : null,
        ),
        child: Text(label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active
                  ? AppTheme.textPrimary
                  : AppTheme.textLight,
            )),
      ),
    );
  }
}

class _StatutBtn extends StatelessWidget {
  final BuildContext ctx, bsCtx;
  final TacheModel   tache;
  final TacheStatut  statut;
  final String       label;
  const _StatutBtn({
    required this.ctx,   required this.bsCtx,
    required this.tache, required this.statut,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tache.statut == statut;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ctx.read<TacheBloc>()
              .add(UpdateStatutTache(tache.id, statut));
          Navigator.pop(bsCtx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.textPrimary
                : AppTheme.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? Colors.white
                  : AppTheme.textSecond,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.wifi_off_rounded,
                color: AppTheme.textLight, size: 24),
          ),
          const SizedBox(height: 14),
          const Text(
            'Impossible de charger les tâches',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppTheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.checklist_rounded,
                color: AppTheme.textLight, size: 28),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune tâche assignée',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Votre encadrant n\'a pas encore\ncréé de tâches pour vous',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textLight,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}