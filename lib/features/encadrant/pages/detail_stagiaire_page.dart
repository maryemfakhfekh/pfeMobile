import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';
import '../logic/encadrant_event.dart';
import '../logic/encadrant_state.dart';
import '../widgets/detail_stagiaire/index.dart';

@RoutePage()
class DetailStagiairePage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  const DetailStagiairePage({super.key, required this.stagiaire});

  @override
  State<DetailStagiairePage> createState() => _DetailStagiairePageState();
}

class _DetailStagiairePageState extends State<DetailStagiairePage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    context.read<EncadrantBloc>()
        .add(EncadrantTachesRequested(widget.stagiaire.id));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.stagiaire;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: BlocBuilder<EncadrantBloc, EncadrantState>(
        builder: (ctx, state) {
          final taches   = state.tachesByStagiaire[s.id] ?? [];
          final eval     = state.evaluationsByStagiaire[s.id];
          final termines = taches.where((t) => t.statut == StatutTacheEncadrant.termine).length;
          final progress = taches.isEmpty ? 0.0 : termines / taches.length;

          return Column(children: [
            StagiaireDetailHeader(stagiaire: s),
            StagiaireProfilCard(
              stagiaire: s,
              progress: progress,
              totalTaches: taches.length,
              evaluation: eval,
            ),
            DetailTabBar(controller: _tab),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  TachesTabView(stagiaire: s, taches: taches),
                  RapportTabView(stagiaireId: s.id),  // ✅ virgule ajoutée + s.id au lieu de stagiaire.id
                  InfosTabView(stagiaire: s),
                ],
              ),
            ),
          ]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.push(CreerTacheRoute(stagiaire: s)),
        backgroundColor: AppTheme.primary,
        elevation: 2,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white, size: 18),
        label: const Text('Nouvelle tâche',
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14,
                fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }
}