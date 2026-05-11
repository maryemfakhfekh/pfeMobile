// lib/features/stagiaire/widgets/dashboard/dashboard_header.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';

class DashboardHeader extends StatelessWidget {
  final StagiaireModel dossier;
  final VoidCallback?  onProfilTap;
  final VoidCallback?  onNotifTap;
  final int            notifCount;

  const DashboardHeader({
    super.key,
    required this.dossier,
    this.onProfilTap,
    this.onNotifTap,
    this.notifCount = 0,
  });

  String get _initials {
    final parts = dossier.utilisateur.nomComplet.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return dossier.utilisateur.nomComplet.substring(0, 2).toUpperCase();
  }

  String get _prenom =>
      dossier.utilisateur.nomComplet.trim().split(' ').first;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ── Greeting ───────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour,',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppTheme.textSecond,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _prenom,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // ── Bouton notif ───────────────────────────────
          GestureDetector(
            onTap: onNotifTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                ),
                if (notifCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.background,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          notifCount > 9 ? '9+' : '$notifCount',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ── Avatar ─────────────────────────────────────
          GestureDetector(
            onTap: onProfilTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppTheme.textPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}