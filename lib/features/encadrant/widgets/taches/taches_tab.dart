// lib/features/encadrant/widgets/taches/taches_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';
import '../../data/models/tache_encadrant_model.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';
import '../../logic/encadrant_state.dart';
import 'tache_dialog.dart';
import 'tache_empty.dart';
import 'tache_encadrant_card.dart';

class TachesTab extends StatefulWidget {
  const TachesTab({super.key});

  @override
  State<TachesTab> createState() => _TachesTabState();
}

class _TachesTabState extends State<TachesTab> {

  @override
  void initState() {
    super.initState();
    _charger();
  }

  void _charger() {
    final bloc = context.read<EncadrantBloc>();
    if (bloc.state.stagiaires.isEmpty) {
      bloc.add(EncadrantStagiairesRequested());
    } else {
      for (final s in bloc.state.stagiaires) {
        bloc.add(EncadrantTachesRequested(s.id));
      }
    }
  }

  void _openForm(BuildContext ctx, List<StagiaireEncadrantModel> stagiaires) {
    if (stagiaires.isEmpty) return;
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: TacheDialog(
          stagiaire: stagiaires.first,
          stagiaires: stagiaires,
          onClose: () => Navigator.pop(ctx),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, TacheEncadrantModel tache) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG)),
        title: Text('Supprimer ?',
            style: Theme.of(ctx)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppTheme.textDark)),
        content: Text('"${tache.titre}"',
            style: Theme.of(ctx).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: AppTheme.dark)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ctx.read<EncadrantBloc>().add(EncadrantTacheDeleted(
                  stagiaireId: tache.stagiaireId, tacheId: tache.id));
            },
            child: const Text('Supprimer',
                style: TextStyle(
                    color: AppTheme.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return BlocListener<EncadrantBloc, EncadrantState>(
      listenWhen: (p, c) => p.stagiaires.length != c.stagiaires.length,
      listener: (ctx, state) {
        for (final s in state.stagiaires) {
          ctx.read<EncadrantBloc>().add(EncadrantTachesRequested(s.id));
        }
      },
      child: BlocBuilder<EncadrantBloc, EncadrantState>(
        builder: (ctx, state) {
          final stagiaires = state.stagiaires;
          final List<TacheEncadrantModel> taches = state
              .tachesByStagiaire.values
              .expand((l) => l)
              .toList();

          final nbFaire   = taches.where((t) => t.statut == StatutTacheEncadrant.aFaire).length;
          final nbCours   = taches.where((t) => t.statut == StatutTacheEncadrant.enCours).length;
          final nbTermine = taches.where((t) => t.statut == StatutTacheEncadrant.termine).length;

          return Column(
            children: [

              // ── Header ──────────────────────────────────────
              Container(
                color: AppTheme.surface,
                padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gestion des Tâches',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${taches.length} tâche${taches.length > 1 ? 's' : ''} au total',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openForm(ctx, stagiaires),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: AppTheme.shadowOrange,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded,
                                color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Nouvelle',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bandeau info ────────────────────────────────
              Container(
                color: const Color(0xFFFFF8F3),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 9),
                child: Row(children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Le statut des tâches est mis à jour par le stagiaire.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppTheme.primary.withOpacity(0.8),
                      ),
                    ),
                  ),
                ]),
              ),

              const Divider(color: AppTheme.border, height: 1),

              // ── Stats compactes ─────────────────────────────
              if (taches.isNotEmpty) ...[
                Container(
                  color: AppTheme.background,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      _StatChip(
                          label: 'À faire',
                          count: nbFaire,
                          color: AppTheme.textLight,
                          bg: AppTheme.darkSoft),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: 'En cours',
                          count: nbCours,
                          color: AppTheme.primary,
                          bg: AppTheme.primarySoft),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: 'Terminé',
                          count: nbTermine,
                          color: AppTheme.success,
                          bg: AppTheme.successSoft),
                    ],
                  ),
                ),
                const Divider(color: AppTheme.border, height: 1),
              ],

              // ── Liste ───────────────────────────────────────
              Expanded(
                child: state.isLoading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primary, strokeWidth: 2))
                    : taches.isEmpty
                    ? const TacheEmpty()
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
                  itemCount: taches.length,
                  itemBuilder: (_, i) {
                    final stagiaire = stagiaires
                        .where((s) => s.id == taches[i].stagiaireId)
                        .firstOrNull;
                    return TacheEncadrantCard(
                      tache: taches[i],
                      stagiaire: stagiaire,
                      onDelete: () => _confirmDelete(ctx, taches[i]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Stat chip compact ─────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bg;

  const _StatChip({
    required this.label,
    required this.count,
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
              width: 8, height: 8,
              decoration: BoxDecoration(
                  color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
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