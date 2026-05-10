// lib/features/encadrant/pages/encadrant_profile_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/encadrant_profile_model.dart';
import '../logic/encadrant_bloc.dart';
import '../widgets/profile/index.dart';

@RoutePage()
class EncadrantProfilePage extends StatefulWidget {
  const EncadrantProfilePage({super.key});

  @override
  State<EncadrantProfilePage> createState() => _EncadrantProfilePageState();
}

class _EncadrantProfilePageState extends State<EncadrantProfilePage> {
  final _storage = const FlutterSecureStorage();
  late EncadrantProfileModel _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final nomComplet =
          await _storage.read(key: 'nomComplet') ?? 'Non disponible';
      final email =
          await _storage.read(key: 'email') ?? 'Non disponible';
      final telephone =
          await _storage.read(key: 'telephone') ?? 'Non disponible';
      final dateNaissance =
          await _storage.read(key: 'dateNaissance') ?? 'Non disponible';
      final etablissement = await _storage.read(key: 'etablissement');

      _profile = EncadrantProfileModel(
        id: int.tryParse(
            await _storage.read(key: 'userId') ?? '0') ??
            0,
        nomComplet: nomComplet,
        email: email,
        telephone: telephone,
        dateNaissance: dateNaissance,
        etablissement: etablissement,
        stagairesCount:
        context.read<EncadrantBloc>().state.stagiaires.length,
        dateCreation: DateTime.now(),
      );

      setState(() => _isLoading = false);
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  String _getInitials(String nomComplet) {
    final parts = nomComplet
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.dark),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'Mon Profil',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppTheme.textDark),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar + nom + badge ───────────────
              ProfileAvatarHeader(
                nomComplet: _profile.nomComplet,
                initials: _getInitials(_profile.nomComplet),
              ),
              const SizedBox(height: 24),

              // ── Infos personnelles ─────────────────
              ProfileInfoCard(profile: _profile),
              const SizedBox(height: 24),

              // ── Statistiques ───────────────────────
              ProfileStatsCard(
                  stagairesCount: _profile.stagairesCount),
              const SizedBox(height: 24),

              // ── Boutons éditer / déconnexion ───────
              const ProfileActionButtons(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}