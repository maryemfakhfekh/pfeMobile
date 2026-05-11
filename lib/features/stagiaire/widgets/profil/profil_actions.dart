// lib/features/stagiaire/widgets/profil/profil_actions.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilActions extends StatelessWidget {
  final bool         isUpdating;
  final VoidCallback onEditTap;

  const ProfilActions({
    super.key,
    required this.isUpdating,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // ── Bouton Éditer ─────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isUpdating ? null : onEditTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              disabledBackgroundColor: AppTheme.primary.withOpacity(0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: isUpdating
                ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, size: 18),
                SizedBox(width: 8),
                Text('Éditer le profil',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Bouton Déconnexion ────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => _confirmLogout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: BorderSide(color: AppTheme.error.withOpacity(0.30)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              backgroundColor: AppTheme.error.withOpacity(0.04),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 18),
                SizedBox(width: 8),
                Text('Se déconnecter',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: const Text('Se déconnecter ?',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppTheme.textPrimary)),
        content: const Text(
            'Vous serez redirigé vers la page de connexion.',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppTheme.textSecond)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecond)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Déconnecter',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error)),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      if (context.mounted) {
        context.router.replace(const LoginRoute());
      }
    }
  }
}