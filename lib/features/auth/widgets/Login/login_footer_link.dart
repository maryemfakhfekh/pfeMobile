import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoginFooterLink extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onAction;

  const LoginFooterLink({
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
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textLight,
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}