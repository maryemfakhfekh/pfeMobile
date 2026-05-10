import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sujet_model.dart';

class SubjectDetailHeader extends StatelessWidget {
  final SujetModel sujet;
  final IconData domainIcon;

  const SubjectDetailHeader({
    super.key,
    required this.sujet,
    required this.domainIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Top row ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(),
                  _AvailabilityBadge(estDisponible: sujet.estDisponible),
                ],
              ),

              const SizedBox(height: 20),

              // ── Titre ─────────────────────────────────
              Text(
                sujet.titre,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // ── Badges ────────────────────────────────
              Row(
                children: [
                  _buildBadge(
                    icon: domainIcon,
                    label: sujet.filiereCible,
                    color: AppTheme.primary,
                    bg: AppTheme.primarySoft,
                  ),
                  const SizedBox(width: 8),
                  _buildBadge(
                    icon: Icons.workspace_premium_rounded,
                    label: sujet.cycleCible,
                    color: AppTheme.textSecond,
                    bg: AppTheme.background,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bouton retour ─────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppTheme.textPrimary,
          size: 18,
        ),
      ),
    );
  }
}

// ── Badge disponibilité ───────────────────────────────────────────
class _AvailabilityBadge extends StatelessWidget {
  final bool estDisponible;
  const _AvailabilityBadge({required this.estDisponible});

  @override
  Widget build(BuildContext context) {
    final color = estDisponible ? AppTheme.success : AppTheme.error;
    final bg    = estDisponible
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFFEF2F2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            estDisponible ? 'DISPONIBLE' : 'COMPLET',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}