import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthFooter extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onAction;

  const AuthFooter({
    super.key,
    required this.question,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppTheme.textSecond),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}