// lib/features/encadrant/widgets/evaluation/evaluation_submit_button.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EvaluationSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const EvaluationSubmitButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isLoading ? AppTheme.border : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: AppTheme.primary, strokeWidth: 2),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_rounded,
                  size: 16, color: AppTheme.textSecond),
              const SizedBox(width: 8),
              Text(
                "Envoyer l'évaluation",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: AppTheme.textSecond),
              ),
            ],
          ),
        ),
      ),
    );
  }
}