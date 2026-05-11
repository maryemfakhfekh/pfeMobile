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
          color: isLoading
              ? AppTheme.primary.withOpacity(0.6)
              : AppTheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isLoading ? [] : AppTheme.shadowOrange,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded,
                  size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Envoyer l'évaluation",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}