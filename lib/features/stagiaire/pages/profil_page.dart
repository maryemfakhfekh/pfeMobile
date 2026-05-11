// lib/features/stagiaire/pages/profil_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_model.dart';
import '../logic/stagiaire_bloc.dart';
import '../widgets/profil/profil_avatar.dart';
import '../widgets/profil/profil_info_card.dart';
import '../widgets/profil/profil_encadrant_card.dart';
import '../widgets/profil/profil_actions.dart';
import '../widgets/profil/edit_profil_sheet.dart';

class ProfilPage extends StatelessWidget {
  final StagiaireModel dossier;

  const ProfilPage({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StagiaireBloc, StagiaireState>(
      listener: (context, state) {
        if (state is ProfilUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Profil mis à jour',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600)),
              ]),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (state is ProfilUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Erreur : ${state.message}',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                      maxLines: 2),
                ),
              ]),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        // Résoudre le dossier depuis n'importe quel état
        final StagiaireModel d = switch (state) {
          StagiaireLoaded()   => state.dossier,
          ProfilUpdating()    => state.dossier,
          ProfilUpdated()     => state.dossier,
          ProfilUpdateError() => state.dossier,
          _                   => dossier,
        };

        final isUpdating = state is ProfilUpdating;
        final u = d.utilisateur;
        final e = d.encadrant;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── Avatar + nom + badge ──────────────────
              ProfilAvatar(
                nomComplet:  u.nomComplet,
                cycleName:   u.cycle?.nom,
                filiereName: u.filiere?.nom,
              ),

              const SizedBox(height: 24),

              // ── Infos personnelles ────────────────────
              ProfilInfoCard(utilisateur: u),

              // ── Encadrant ─────────────────────────────
              if (e != null) ...[
                const SizedBox(height: 12),
                ProfilEncadrantCard(encadrant: e),
              ],

              const SizedBox(height: 28),

              // ── Boutons éditer + déconnexion ──────────
              ProfilActions(
                isUpdating: isUpdating,
                onEditTap:  () => EditProfilSheet.show(context, d),
              ),
            ],
          ),
        );
      },
    );
  }
}