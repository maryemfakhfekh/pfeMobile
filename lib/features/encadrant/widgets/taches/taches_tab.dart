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
    final bottomInset = MediaQuery.of(context).padding.bottom;

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
                color: Colors.white,
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
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${taches.length} tâche${taches.length > 1 ? 's' : ''} au total',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Bouton + rond ──────────────────────
                    GestureDetector(
                      onTap: () => _openForm(ctx, stagiaires),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: AppTheme.shadowOrange,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 24,
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

              const Divider(color: Color(0xFFE2E8F0), height: 1),

              // ── Stats ────────────────────────────────────────
              if (taches.isNotEmpty) ...[
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: [
                      _StatCard(
                        label: 'À faire',
                        value: '$nbFaire',
                        valueColor: const Color(0xFF64748B),
                        bg: const Color(0xFFF1F5F9),
                        dotColor: const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'En cours',
                        value: '$nbCours',
                        valueColor: AppTheme.primary,
                        bg: const Color(0xFFFFF4ED),
                        dotColor: AppTheme.primary,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Terminé',
                        value: '$nbTermine',
                        valueColor: const Color(0xFF16A34A),
                        bg: const Color(0xFFEAFAF0),
                        dotColor: const Color(0xFF16A34A),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
              ],

              // ── Liste ───────────────────────────────────────
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: state.isLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary, strokeWidth: 2))
                      : taches.isEmpty
                      ? const TacheEmpty()
                      : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        16, 14, 16, bottomInset + 100),
                    itemCount: taches.length,
                    itemBuilder: (_, i) {
                      final stagiaire = stagiaires
                          .where((s) =>
                      s.id == taches[i].stagiaireId)
                          .firstOrNull;
                      return TacheEncadrantCard(
                        tache: taches[i],
                        stagiaire: stagiaire,
                        onDelete: () =>
                            _confirmDelete(ctx, taches[i]),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
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