// lib/features/encadrant/widgets/profile/profile_avatar_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileAvatarHeader extends StatelessWidget {
  final String nomComplet;
  final String initials;

  const ProfileAvatarHeader({
    super.key,
    required this.nomComplet,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _Avatar(initials: initials),
          const SizedBox(height: 16),
          Text(
            nomComplet,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: AppTheme.textDark),
          ),
          const SizedBox(height: 8),
          const _RoleBadge(),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.dark,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: AppTheme.shadowMD,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: const Text(
        'Encadrant Technique',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: AppTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}