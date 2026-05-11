// lib/features/stagiaire/widgets/home/home_loading.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      ),
    );
  }
}