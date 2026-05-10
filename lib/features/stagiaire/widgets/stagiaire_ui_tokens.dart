import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StagiaireUiTokens {
  StagiaireUiTokens._();

  // ── Espacements ───────────────────────────────────────
  static const double pageHPadding  = 20.0;
  static const double sectionGap    = 24.0;
  static const double cardPadding   = 16.0;
  static const double itemGap       = 12.0;

  // ── Stat cards (comme les 4 cards Encadrant) ──────────
  static const double statCardRadius = 16.0;
  static const double statIconSize   = 20.0;

  // ── Couleurs sémantiques ──────────────────────────────
  static const Color done      = Color(0xFF22C55E); // vert
  static const Color inProgress= Color(0xFFE87722); // orange primary
  static const Color late      = Color(0xFFEF4444); // rouge
  static const Color assigned  = Color(0xFF3B82F6); // bleu

  // ── Décoration carte standard ─────────────────────────
  static BoxDecoration cardDecoration({double radius = 16.0}) {
    return BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppTheme.border, width: 0.5),
      boxShadow: AppTheme.shadowLight,
    );
  }

  // ── Décoration carte colorée (ex: avancement orange) ──
  static BoxDecoration accentCardDecoration({double radius = 16.0}) {
    return BoxDecoration(
      color: AppTheme.primary,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primary.withOpacity(0.30),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // ── Badge statut tâche ────────────────────────────────
  static BoxDecoration badgeDecoration(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
    );
  }

  // ── TextStyles ────────────────────────────────────────
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppTheme.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppTheme.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppTheme.textSecond,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppTheme.textSecond,
  );

  static const TextStyle badgeText = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}