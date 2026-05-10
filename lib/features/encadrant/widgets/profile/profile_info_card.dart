// lib/features/encadrant/widgets/profile/profile_info_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/encadrant_profile_model.dart';
import 'profile_info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  final EncadrantProfileModel profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations Personnelles',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppTheme.textDark),
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile.email,
          ),
          const Divider(color: AppTheme.border, height: 24),
          ProfileInfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: profile.telephone,
          ),
          const Divider(color: AppTheme.border, height: 24),
          ProfileInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date de Naissance',
            value: profile.dateNaissance,
          ),
          const Divider(color: AppTheme.border, height: 24),
          ProfileInfoRow(
            icon: Icons.school_outlined,
            label: 'Établissement',
            value: profile.etablissement ?? 'Non spécifié',
          ),
        ],
      ),
    );
  }
}