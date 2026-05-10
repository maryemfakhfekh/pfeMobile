// lib/features/stagiaire/widgets/dashboard/tabs/profil_tab.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../../../data/models/tache_model.dart';
import '../../../logic/tache_bloc.dart';
import '../../stagiaire_ui_tokens.dart';

class ProfilTab extends StatelessWidget {
  final StagiaireModel dossier;
  const ProfilTab({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TacheBloc>()..add(LoadTaches()),
      child: _ProfilContent(dossier: dossier),
    );
  }
}

class _ProfilContent extends StatelessWidget {
  final StagiaireModel dossier;
  const _ProfilContent({required this.dossier});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TacheBloc, TacheState>(
      builder: (context, state) {
        final taches    = state is TacheLoaded
            ? state.taches : <TacheModel>[];
        final total     = taches.length;
        final terminees = taches
            .where((t) => t.statut == TacheStatut.terminee)
            .length;
        final pct = total > 0
            ? '${(terminees / total * 100).toInt()}%'
            : '0%';

        final u = dossier.utilisateur;
        final s = dossier.sujet;
        final e = dossier.encadrant;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── Avatar rond dark navy (comme image 4) ──
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppTheme.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _initials(u.nomComplet),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                u.nomComplet,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 6),

              // Badge rôle (comme "Encadrant Technique" image 4)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.20),
                  ),
                ),
                child: Text(
                  '${u.cycle?.nom ?? 'Stagiaire'} · ${u.filiere?.nom ?? ''}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Infos personnelles ──────────────────────
              _SectionCard(
                title: 'Informations personnelles',
                children: [
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Nom complet',
                    value: u.nomComplet,
                  ),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: u.email,
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Téléphone',
                    value: u.telephone ?? 'Non renseigné',
                  ),
                  _InfoRow(
                    icon: Icons.school_outlined,
                    label: 'Établissement',
                    value: u.etablissement ?? 'Non spécifié',
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Sujet de stage ──────────────────────────
              _SectionCard(
                title: 'Mon stage',
                children: [
                  _InfoRow(
                    icon: Icons.work_outline_rounded,
                    label: 'Sujet',
                    value: s.titre.trim(),
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Début',
                    value: dossier.dateDebut,
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Vue d'ensemble ──────────────────────────
              _SectionCard(
                title: 'Vue d\'ensemble',
                children: [
                  _StatRow(
                    icon:  Icons.checklist_rounded,
                    label: 'Tâches assignées',
                    value: '$total',
                  ),
                  _StatRow(
                    icon:  Icons.check_circle_outline_rounded,
                    label: 'Tâches terminées',
                    value: '$terminees',
                  ),
                  _StatRow(
                    icon:  Icons.trending_up_rounded,
                    label: 'Progression',
                    value: pct,
                    isLast: true,
                  ),
                ],
              ),

              // ── Mon Encadrant ───────────────────────────
              if (e != null) ...[
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Mon Encadrant',
                  children: [
                    Row(children: [
                      Container(
                        width: 42, height: 42,
                        decoration: const BoxDecoration(
                          color: AppTheme.textPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _initials(e.nomComplet),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.nomComplet,
                              style: StagiaireUiTokens.cardTitle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              e.email,
                              style: StagiaireUiTokens.cardSubtitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Badge disponible
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: StagiaireUiTokens.done
                              .withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                color: StagiaireUiTokens.done,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Disponible',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: StagiaireUiTokens.done,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // ── Bouton Éditer ───────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Éditer le profil',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Bouton Déconnexion ──────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () async {
                    const storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    if (context.mounted) {
                      context.router.replace(const LoginRoute());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: BorderSide(
                      color: AppTheme.error.withOpacity(0.25),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    backgroundColor: AppTheme.surface,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Se déconnecter',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Widgets privés ──────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String        title;
  final List<Widget>  children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: StagiaireUiTokens.cardDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: StagiaireUiTokens.sectionTitle),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  final bool     isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: StagiaireUiTokens.statLabel
                        .copyWith(fontSize: 11)),
                Text(value,
                    style: StagiaireUiTokens.cardTitle
                        .copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ]),
        if (!isLast)
          Container(
            height: 1,
            color: AppTheme.border,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  final bool     isLast;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: StagiaireUiTokens.cardSubtitle
                    .copyWith(fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          Text(value, style: StagiaireUiTokens.cardTitle),
        ]),
        if (!isLast)
          Container(
            height: 1,
            color: AppTheme.border,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
      ],
    );
  }
}