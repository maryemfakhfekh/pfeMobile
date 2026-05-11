// lib/features/stagiaire/pages/rapport_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/rapport_model.dart';
import '../logic/rapport_bloc.dart';
import '../widgets/stagiaire_ui_tokens.dart';
import '../widgets/rapport/rapport_status_card.dart';
import '../widgets/rapport/rapport_upload_zone.dart';
import '../widgets/rapport/rapport_uploading_indicator.dart';
import '../widgets/rapport/rapport_info_card.dart';

class RapportPage extends StatelessWidget {
  const RapportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RapportBloc>()..add(LoadRapport()),
      child: const _RapportView(),
    );
  }
}

class _RapportView extends StatelessWidget {
  const _RapportView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RapportBloc, RapportState>(
      listener: (context, state) {
        if (state is RapportUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Rapport déposé avec succès',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        if (state is RapportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RapportLoading || state is RapportInitial) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppTheme.primary, strokeWidth: 2),
          );
        }

        final rapport = state is RapportLoaded
            ? state.rapport
            : state is RapportUploadSuccess
            ? state.rapport
            : null;
        final isUploading = state is RapportUploading;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Titre ────────────────────────────────────
              const Text(
                'Rapport de stage',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Déposez votre rapport final en PDF',
                style: StagiaireUiTokens.cardSubtitle,
              ),

              const SizedBox(height: 16),

              // ── Statut ───────────────────────────────────
              RapportStatusCard(rapport: rapport),

              const SizedBox(height: 10),

              // ── Upload zone ──────────────────────────────
              if (rapport == null && !isUploading)
                RapportUploadZone(
                  onUpload: (path, name) => context
                      .read<RapportBloc>()
                      .add(DeposerRapport(path, name)),
                ),

              // ── Uploading ────────────────────────────────
              if (isUploading)
                const RapportUploadingIndicator(),

              const SizedBox(height: 10),

              // ── Info ─────────────────────────────────────
              const RapportInfoCard(),
            ],
          ),
        );
      },
    );
  }
}