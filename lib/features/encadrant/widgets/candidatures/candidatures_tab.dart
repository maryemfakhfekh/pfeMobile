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
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (context, state) {
        final candidatures = state.candidatures;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Candidatures',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    candidatures.isEmpty
                        ? 'Candidats affectés à vos entretiens'
                        : '${candidatures.length} entretien${candidatures.length > 1 ? 's' : ''} en attente',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFE2E8F0), height: 1),

            // ── Contenu ─────────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.white,
                child: () {
                  if (state.isLoadingCandidatures) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary, strokeWidth: 2),
                    );
                  }

                  if (state.error != null && candidatures.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.wifi_off_rounded,
                                size: 28, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Impossible de charger',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Vérifiez votre connexion',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => context
                                .read<EncadrantBloc>()
                                .add(EncadrantCandidaturesRequested()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Réessayer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (candidatures.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              size: 30,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aucun entretien en attente',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Les candidats vous seront\naffectés par le RH',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.primary,
                    onRefresh: () async => context
                        .read<EncadrantBloc>()
                        .add(EncadrantCandidaturesRequested()),
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                          16, 14, 16, bottomInset + 100),
                      itemCount: candidatures.length,
                      itemBuilder: (context, i) => _CandidatCard(
                        candidat: candidatures[i],
                      ),
                    ),
                  );
                }(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

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
        margin: const EdgeInsets.only(bottom: 10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Bordure gauche orange ──────────────────
              Container(
                width: 3,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),

              // ── Contenu ───────────────────────────────
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      // Avatar
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppTheme.primarySoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            initiales,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Infos
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              candidat.nomComplet,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              candidat.sujetTitre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (candidat.filiere.isNotEmpty)
                                  _Pill(label: candidat.filiere),
                                if (dateFormatee.isNotEmpty)
                                  _Pill(
                                    label: dateFormatee,
                                    icon: Icons.calendar_today_rounded,
                                    highlight: true,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Flèche
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.primarySoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Pill
// ─────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool highlight;

  const _Pill({
    required this.label,
    this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppTheme.primary : const Color(0xFF64748B);
    final bg = highlight
        ? AppTheme.primarySoft
        : const Color(0xFFF1F5F9);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}