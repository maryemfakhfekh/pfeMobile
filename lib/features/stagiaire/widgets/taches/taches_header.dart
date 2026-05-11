// lib/features/stagiaire/widgets/taches/taches_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TachesHeader extends StatelessWidget {
  final int              total;
  final bool             isDetailed;
  final ValueChanged<bool> onToggle;
  final VoidCallback     onRefresh;

  const TachesHeader({
    super.key,
    required this.total,
    required this.isDetailed,
    required this.onToggle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mes tâches',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '$total tâche${total > 1 ? 's' : ''} assignée${total > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onRefresh,
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF64748B),
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _TabBtn(
                  label:  'Détaillé',
                  active: isDetailed,
                  onTap:  () => onToggle(true),
                ),
                const SizedBox(width: 24),
                _TabBtn(
                  label:  'Liste',
                  active: !isDetailed,
                  onTap:  () => onToggle(false),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String       label;
  final bool         active;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? AppTheme.primary : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: active ? 60 : 0,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}