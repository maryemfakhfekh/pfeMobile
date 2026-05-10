import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RoleChip extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const RoleChip({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFDF2EC) : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppTheme.primary : const Color(0xFFEEEEEE),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône dans son carré
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFFAECE7)
                      : const Color(0xFFF5F5F3),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: selected ? AppTheme.primary : const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 7),
              // Nom du rôle
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: selected
                      ? const Color(0xFF993C1D)
                      : const Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 2),
              // Description courte
              Text(
                description,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  color: selected
                      ? const Color(0xFFD85A30)
                      : const Color(0xFFBBBBBB),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}