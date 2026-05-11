// lib/features/stagiaire/widgets/taches/taches_empty_error.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TachesEmptyView extends StatelessWidget {
  const TachesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.checklist_rounded,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune tâche assignée',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Votre encadrant n\'a pas encore\ncréé de tâches pour vous',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF94A3B8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class TachesErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const TachesErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.wifi_off_rounded,
                color: Color(0xFF64748B), size: 28),
          ),
          const SizedBox(height: 14),
          const Text(
            'Impossible de charger',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}