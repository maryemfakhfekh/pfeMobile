// lib/features/stagiaire/pages/stagiaire_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/stagiaire_bloc.dart';
import 'candidature_pending_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StagiaireBloc, StagiaireState>(
      builder: (context, state) {
        if (state is StagiaireLoading || state is StagiaireInitial) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }
        if (state is StagiaireLoaded) {
          return StaigaireDashboardPage(dossier: state.dossier);
        }
        // StagiaireError ou autre → page en attente
        return const CandidaturePendingPage();
      },
    );
  }
}