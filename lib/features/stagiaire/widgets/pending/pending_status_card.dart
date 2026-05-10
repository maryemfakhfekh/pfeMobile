// lib/features/stagiaire/widgets/pending/pending_status_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingStatusCard extends StatefulWidget {
  const PendingStatusCard({super.key});

  @override
  State<PendingStatusCard> createState() => _PendingStatusCardState();
}

class _PendingStatusCardState extends State<PendingStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        children: [

          // ── Icône animée ──────────────────────────────
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) =>
                Transform.scale(scale: _pulse.value, child: child),
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.warning.withOpacity(0.3),
                    width: 2),
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: AppTheme.warning,
                size: 32,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Titre ─────────────────────────────────────
          const Text(
            'Candidature en cours d\'examen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Votre dossier a bien été reçu.\nLe service RH l\'examine actuellement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppTheme.textSecond,
              fontSize: 12,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),
          Container(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 16),

          // ── Étapes ────────────────────────────────────
          _step(
            icon:   Icons.check_circle_rounded,
            color:  AppTheme.success,
            label:  'Candidature déposée',
            done:   true,
          ),
          const SizedBox(height: 12),
          _step(
            icon:   Icons.radio_button_checked_rounded,
            color:  AppTheme.warning,
            label:  'Examen par le service RH',
            active: true,
          ),
          const SizedBox(height: 12),
          _step(
            icon:   Icons.radio_button_unchecked_rounded,
            color:  AppTheme.textLight,
            label:  'Décision finale',
          ),
        ],
      ),
    );
  }

  Widget _step({
    required IconData icon,
    required Color    color,
    required String   label,
    bool done   = false,
    bool active = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: done
                  ? AppTheme.textPrimary
                  : active
                  ? AppTheme.warning
                  : AppTheme.textLight,
              fontSize: 13,
              fontWeight: done || active
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
        if (active)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'En cours',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: AppTheme.warning,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}