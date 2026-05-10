import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const InfoCard({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
      boxShadow: AppTheme.shadowSM,
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleMedium!
                .copyWith(color: AppTheme.textDark)),
        const SizedBox(height: 12),
        ...rows,
      ],
    ),
  );
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: AppTheme.darkSoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        child: Icon(icon, size: 15, color: AppTheme.dark),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            Text(value,
                style: Theme.of(context).textTheme.titleSmall!
                    .copyWith(color: AppTheme.textDark)),
          ],
        ),
      ),
    ]),
  );
}