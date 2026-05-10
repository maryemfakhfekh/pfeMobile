// lib/features/encadrant/widgets/chat/chat_app_bar.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_encadrant_model.dart';

class ChatAppBar extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;

  const ChatAppBar({super.key, required this.stagiaire});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.fromLTRB(
        12,
        MediaQuery.of(context).padding.top + 10,
        16,
        12,
      ),
      child: Row(
        children: [
          _BackButton(context),
          const SizedBox(width: 10),
          _AvatarWithStatus(initials: stagiaire.initials),
          const SizedBox(width: 10),
          Expanded(
            child: _UserInfo(nomComplet: stagiaire.nomComplet),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.back(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.darkSoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: AppTheme.dark,
        ),
      ),
    );
  }
}

class _AvatarWithStatus extends StatelessWidget {
  final String initials;
  const _AvatarWithStatus({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppTheme.dark,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppTheme.success,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String nomComplet;
  const _UserInfo({required this.nomComplet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nomComplet,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppTheme.textDark),
        ),
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'En ligne',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppTheme.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}