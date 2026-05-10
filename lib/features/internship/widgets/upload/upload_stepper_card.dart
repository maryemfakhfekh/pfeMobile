import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UploadStepperCard extends StatelessWidget {
  const UploadStepperCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: const Row(
        children: [
          _UploadStep(
            label: 'Sujet',
            stepNumber: '1',
            done: true,
            active: false,
          ),
          _UploadStepLine(done: true),
          _UploadStep(
            label: 'Détails',
            stepNumber: '2',
            done: true,
            active: false,
          ),
          _UploadStepLine(done: true),
          _UploadStep(
            label: 'CV',
            stepNumber: '3',
            done: false,
            active: true,
          ),
        ],
      ),
    );
  }
}

class _UploadStep extends StatelessWidget {
  final String label;
  final String stepNumber;
  final bool done;
  final bool active;

  const _UploadStep({
    required this.label,
    required this.stepNumber,
    required this.done,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? AppTheme.success
        : active
        ? AppTheme.primary
        : AppTheme.textLight;

    final bg = done
        ? const Color(0xFFF0FDF4)
        : active
        ? AppTheme.primarySoft
        : AppTheme.background;

    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, size: 15, color: color)
                : Text(
              stepNumber,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight:
            active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _UploadStepLine extends StatelessWidget {
  final bool done;
  const _UploadStepLine({required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: done ? AppTheme.success : AppTheme.border,
        ),
      ),
    );
  }
}