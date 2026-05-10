import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoginField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;

  const LoginField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.errorText,
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  final FocusNode _focus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label au-dessus
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        // Champ
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? AppTheme.error
                  : _isFocused
                  ? AppTheme.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: Color(0xFFBEC5D0),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        // Message erreur
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 5),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 11, color: AppTheme.error),
                const SizedBox(width: 4),
                Text(
                  widget.errorText!,
                  style: const TextStyle(
                    color: AppTheme.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}