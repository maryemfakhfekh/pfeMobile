// lib/features/encadrant/widgets/candidatures/candidatures_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/candidature_entretien_model.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_event.dart';
import '../../logic/encadrant_state.dart';
import 'entretien_questions_page.dart';

class CandidaturesTab extends StatefulWidget {
  const CandidaturesTab({super.key});

  @override
  State<CandidaturesTab> createState() => _CandidaturesTabState();
}

class _CandidaturesTabState extends State<CandidaturesTab> {
  @override
  void initState() {
    super.initState();
    context.read<EncadrantBloc>().add(EncadrantCandidaturesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Candidatures',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                      fontFamily: 'Poppins',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Candidats affectés à vos entretiens',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textLight,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Liste ────────────────────────────────────
            Expanded(
              child: BlocBuilder<EncadrantBloc, EncadrantState>(
                builder: (context, state) {
                  if (state.isLoadingCandidatures) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary),
                    );
                  }

                  if (state.error != null && state.candidatures.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded,
                              size: 48, color: AppTheme.textLight),
                          const SizedBox(height: 12),
                          const Text(
                            'Impossible de charger les candidatures',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => context
                                .read<EncadrantBloc>()
                                .add(EncadrantCandidaturesRequested()),
                            child: const Text('Réessayer',
                                style: TextStyle(color: AppTheme.primary)),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.candidatures.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              size: 36,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun entretien en attente',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Les candidats vous seront affectés\npar le RH',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textLight,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.primary,
                    onRefresh: () async {
                      context
                          .read<EncadrantBloc>()
                          .add(EncadrantCandidaturesRequested());
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: state.candidatures.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        return _CandidatCard(
                          candidat: state.candidatures[i],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

/// Formate "2026-05-15T10:30:00" → "15/05/2026 10:30"
String _formatDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final dt = DateTime.parse(raw);
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/${dt.year} $hour:$min';
  } catch (_) {
    // Retourne les 16 premiers chars si le parsing échoue (ex: "2026-05-15T10:30")
    return raw.length > 16 ? raw.substring(0, 16) : raw;
  }
}

// ─────────────────────────────────────────────────────────────
// Card candidat
// ─────────────────────────────────────────────────────────────

class _CandidatCard extends StatelessWidget {
  final CandidatureEntretienModel candidat;

  const _CandidatCard({required this.candidat});

  @override
  Widget build(BuildContext context) {
    final initiales = candidat.nomComplet
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    final dateFormatee = _formatDate(candidat.dateEntretien);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<EncadrantBloc>(),
              child: EntretienQuestionsPage(candidat: candidat),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border, width: 0.5),
          boxShadow: AppTheme.shadowLight,
        ),
        child: Row(
          children: [
            // Avatar initiales
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  initiales,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Infos — FIX: Expanded contient tout, les pills dans Wrap
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidat.nomComplet,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    candidat.sujetTitre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecond,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  // ✅ FIX : Wrap à la place de Row → les pills passent à la ligne
                  //          si elles dépassent la largeur disponible
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _Pill(label: candidat.filiere),
                      if (dateFormatee.isNotEmpty)
                        _Pill(
                          label: dateFormatee,
                          icon: Icons.calendar_today_rounded,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Flèche
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Pill / badge
// ─────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _Pill({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.darkSoft,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: AppTheme.textSecond),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecond,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}