// lib/features/stagiaire/pages/stagiaire_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../data/models/stagiaire_model.dart';
import '../logic/stagiaire_bloc.dart';
import '../widgets/home/home_loading.dart';
import '../widgets/home/home_error.dart';
import 'stagiaire_dashboard_page.dart';

@RoutePage()
class StagiaireHomePage extends StatelessWidget {
  const StagiaireHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StagiaireBloc>()..add(LoadDossier()),
      child: const _StagiaireHomeView(),
    );
  }
}

class _StagiaireHomeView extends StatelessWidget {
  const _StagiaireHomeView();

  StagiaireModel? _dossier(StagiaireState state) => switch (state) {
    StagiaireLoaded()   => state.dossier,
    ProfilUpdating()    => state.dossier,
    ProfilUpdated()     => state.dossier,
    ProfilUpdateError() => state.dossier,
    _                   => null,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StagiaireBloc, StagiaireState>(
      builder: (context, state) {
        if (state is StagiaireLoading || state is StagiaireInitial) {
          return const HomeLoading();
        }

        final dossier = _dossier(state);
        if (dossier != null) {
          return StaigaireDashboardPage(dossier: dossier);
        }

        return const HomeError();
      },
    );
  }
}