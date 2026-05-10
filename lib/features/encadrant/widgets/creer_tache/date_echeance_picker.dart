import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DateEcheancePicker extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback onClear;
  const DateEcheancePicker({
    super.key,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  String? get _formatted => value == null ? null :
  '${value!.day.toString().padLeft(2, '0')}/'
      '${value!.month.toString().padLeft(2, '0')}/'
      '${value!.year}';

  @override
  Widget build(BuildContext context) {
    final hasDate = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: hasDate ? AppTheme.primary : AppTheme.border,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_rounded,
              size: 17,
              color: hasDate ? AppTheme.primary : AppTheme.textLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _formatted ?? "Choisir une date d'échéance",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: hasDate ? AppTheme.textPrimary : AppTheme.textLight,
                fontWeight: hasDate ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
          if (hasDate)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close_rounded,
                  size: 16, color: AppTheme.textLight),
            ),
        ]),
      ),
    );
  }
}