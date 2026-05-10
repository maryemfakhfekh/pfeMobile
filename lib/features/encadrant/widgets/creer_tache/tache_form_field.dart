import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TacheLabel extends StatelessWidget {
  final String title;
  final bool required;
  const TacheLabel({super.key, required this.title, this.required = false});

  @override
  Widget build(BuildContext context) => Row(children: [
    Text(title,
        style: Theme.of(context).textTheme.titleSmall!
            .copyWith(color: AppTheme.textDark)),
    if (required) ...[
      const SizedBox(width: 3),
      const Text('*', style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.error)),
    ],
  ]);
}

class TacheTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;
  const TacheTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppTheme.textLight, size: 18) : null,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: maxLines > 1 ? 14 : 0),
      ),
    );
  }
}