// lib/features/encadrant/widgets/profile/profile_action_buttons.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/logic/auth_bloc.dart';
import '../../../auth/logic/auth_event.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EditButton(),
        const SizedBox(height: 12),
        _LogoutButton(),
      ],
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Édition du profil — À implémenter'),
            ),
          );
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Éditer le profil'),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
        label: const Text(
          'Se déconnecter',
          style: TextStyle(color: AppTheme.error),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.error,
          side: const BorderSide(color: AppTheme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Se déconnecter',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: AppTheme.textDark),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppTheme.dark),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
              context.router.replaceAll([const LoginRoute()]);
            },
            child: const Text(
              'Déconnexion',
              style: TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}