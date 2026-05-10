import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TacheSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;
  const TacheSubmitButton({super.key, required this.isLoading, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLoading
              ? AppTheme.primary.withOpacity(0.6)
              : AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: isLoading ? [] : AppTheme.shadowOrange,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5))
              : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_task_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Créer la tâche',
                    style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 15,
                        fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
        ),
      ),
    );
  }
}