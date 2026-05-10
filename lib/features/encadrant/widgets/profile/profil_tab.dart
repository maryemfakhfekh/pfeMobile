// lib/features/encadrant/widgets/profile/profil_tab.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/logic/auth_bloc.dart';
import '../../../auth/logic/auth_event.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_state.dart';
import 'profile_avatar_header.dart';
import 'profile_info_row.dart';

class ProfilTab extends StatefulWidget {
  final String nomComplet;
  const ProfilTab({super.key, required this.nomComplet});

  @override
  State<ProfilTab> createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  String _email     = '';
  String _telephone = '';
  String _role      = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    const s = FlutterSecureStorage();
    final email     = await s.read(key: 'email')     ?? '';
    final telephone = await s.read(key: 'telephone') ?? 'Non renseigné';
    final role      = await s.read(key: 'role')      ?? 'ENCADRANT';
    if (mounted) {
      setState(() {
        _email     = email;
        _telephone = telephone;
        _role      = role;
      });
    }
  }

  String _initials(String n) {
    final p = n.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (p.length >= 2) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return n.length >= 2 ? n.substring(0, 2).toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final nom = widget.nomComplet.isEmpty ? 'Encadrant' : widget.nomComplet;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (ctx, state) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, top + 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Mon Profil',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: AppTheme.textDark),
            ),
            const SizedBox(height: 20),

            // ── Avatar header ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                boxShadow: AppTheme.shadowSM,
                border: Border.all(color: AppTheme.border),
              ),
              child: ProfileAvatarHeader(
                nomComplet: nom,
                initials: _initials(nom),
              ),
            ),

            const SizedBox(height: 16),

            // ── Informations ─────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                boxShadow: AppTheme.shadowSM,
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informations personnelles',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 14),
                  ProfileInfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Nom complet',
                    value: nom,
                  ),
                  const Divider(color: AppTheme.border, height: 24),
                  ProfileInfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: _email,
                  ),
                  const Divider(color: AppTheme.border, height: 24),
                  ProfileInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Téléphone',
                    value: _telephone,
                  ),
                  const Divider(color: AppTheme.border, height: 24),
                  ProfileInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Rôle',
                    value: _role,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Déconnexion ───────────────────────────────
            GestureDetector(
              onTap: () => _confirmLogout(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border: Border.all(color: AppTheme.error.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: AppTheme.error, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Se déconnecter',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG)),
        title: Text(
          'Se déconnecter ?',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: AppTheme.textDark),
        ),
        content: Text(
          'Vous serez redirigé vers la page de connexion.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: AppTheme.dark)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
              context.router.replaceAll([const LoginRoute()]);
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(
                  color: AppTheme.error, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}