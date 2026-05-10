// lib/features/stagiaire/widgets/dashboard/tabs/rapport_tab.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/rapport_model.dart';
import '../../../logic/rapport_bloc.dart';
import '../../stagiaire_ui_tokens.dart';

class RapportTab extends StatelessWidget {
  const RapportTab({super.key});

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
              content: const Row(children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 10),
                Text('Rapport déposé avec succès',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    )),
              ]),
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
              content: Text(state.message,
                  style: const TextStyle(fontFamily: 'Poppins')),
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

              // ── Titre page ──────────────────────────────
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

              // ── Card statut ─────────────────────────────
              _StatusCard(rapport: rapport),

              const SizedBox(height: 10),

              // ── Zone upload ─────────────────────────────
              if (rapport == null && !isUploading)
                _UploadZone(
                  onUpload: (path, name) => context
                      .read<RapportBloc>()
                      .add(DeposerRapport(path, name)),
                ),

              // ── Uploading indicator ─────────────────────
              if (isUploading)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: StagiaireUiTokens.cardDecoration(),
                  child: const Row(children: [
                    CircularProgressIndicator(
                        color: AppTheme.primary, strokeWidth: 2),
                    SizedBox(width: 16),
                    Text(
                      'Envoi en cours...',
                      style: StagiaireUiTokens.cardSubtitle,
                    ),
                  ]),
                ),

              const SizedBox(height: 10),

              // ── Note info ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: StagiaireUiTokens.cardDecoration(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Votre rapport sera consulté par votre encadrant et le service RH. Assurez-vous qu\'il est complet avant de le soumettre.',
                            style: StagiaireUiTokens.cardSubtitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Card statut ─────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final RapportModel? rapport;
  const _StatusCard({this.rapport});

  @override
  Widget build(BuildContext context) {
    final estDepose = rapport != null;
    final iconColor = estDepose ? AppTheme.success : AppTheme.primary;
    final iconBg    = estDepose
        ? AppTheme.success.withOpacity(0.10)
        : AppTheme.primarySoft;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Row(children: [

        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            estDepose
                ? Icons.check_circle_outline_rounded
                : Icons.upload_file_rounded,
            color: iconColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                estDepose
                    ? 'Rapport déposé'
                    : 'Aucun rapport déposé',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: estDepose
                      ? AppTheme.success
                      : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                estDepose
                    ? 'Déposé le ${rapport!.dateDepot ?? ''} · En attente encadrant'
                    : 'Déposez votre rapport avant la fin du stage',
                style: StagiaireUiTokens.cardSubtitle,
              ),
            ],
          ),
        ),

        // Badge point coloré
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              estDepose ? 'Déposé' : 'En attente',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Zone upload ─────────────────────────────────────────────────────

class _UploadZone extends StatefulWidget {
  final void Function(String path, String name) onUpload;
  const _UploadZone({required this.onUpload});

  @override
  State<_UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<_UploadZone> {
  String? _fileName;
  String? _filePath;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // ── Fichier sélectionné ───────────────────────────
    if (_fileName != null && _filePath != null) {
      return Column(children: [

        Container(
          padding: const EdgeInsets.all(14),
          decoration: StagiaireUiTokens.cardDecoration(),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded,
                  color: AppTheme.error, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fileName!,
                    style: StagiaireUiTokens.cardTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Prêt à être soumis',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: StagiaireUiTokens.done,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(
                      () { _fileName = null; _filePath = null; }),
              child: Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.close_rounded,
                    color: AppTheme.textLight, size: 16),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () =>
                widget.onUpload(_filePath!, _fileName!),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18),
                SizedBox(width: 10),
                Text(
                  'Soumettre le rapport',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    // ── Zone de drop vide ─────────────────────────────
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.border,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Column(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              color: AppTheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Appuyez pour sélectionner',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Format PDF uniquement · Max 20 MB',
            style: StagiaireUiTokens.cardSubtitle,
          ),
        ]),
      ),
    );
  }
}