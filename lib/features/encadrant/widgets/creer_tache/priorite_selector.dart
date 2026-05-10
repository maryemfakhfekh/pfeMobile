// lib/features/encadrant/widgets/creer_tache/priorite_selector.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/tache_encadrant_model.dart';

class PrioriteSelector extends StatelessWidget {
  final PrioriteTache value;
  final ValueChanged<PrioriteTache> onChanged;
  const PrioriteSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Color _color(PrioriteTache p) => switch (p) {
    PrioriteTache.haute    => AppTheme.error,
    PrioriteTache.critique => const Color(0xFF7C3AED), // violet
    PrioriteTache.moyenne  => AppTheme.primary,
    PrioriteTache.basse    => AppTheme.success,
  };

  Color _bg(PrioriteTache p) => switch (p) {
    PrioriteTache.haute    => const Color(0xFFFEF2F2),
    PrioriteTache.critique => const Color(0xFFF5F3FF), // violet soft
    PrioriteTache.moyenne  => AppTheme.primarySoft,
    PrioriteTache.basse    => AppTheme.successSoft,
  };

  IconData _icon(PrioriteTache p) => switch (p) {
    PrioriteTache.haute    => Icons.keyboard_double_arrow_up_rounded,
    PrioriteTache.critique => Icons.priority_high_rounded,
    PrioriteTache.moyenne  => Icons.drag_handle_rounded,
    PrioriteTache.basse    => Icons.keyboard_double_arrow_down_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PrioriteTache.values.map((p) {
        final selected = value == p;
        final isLast   = p == PrioriteTache.basse;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(right: isLast ? 0 : 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? _bg(p) : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(
                  color: selected ? _color(p) : AppTheme.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(children: [
                Icon(
                  _icon(p),
                  color: selected ? _color(p) : AppTheme.textLight,
                  size: 18,
                ),
                const SizedBox(height: 3),
                Text(
                  p.uiLabel,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? _color(p) : AppTheme.textSecond,
                  ),
                ),
              ]),
            ),
          ),
        );
      }).toList(),
    );
  }
}