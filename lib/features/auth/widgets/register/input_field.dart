import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

const Color _iconColor = Color(0xFFCBD5E1);

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? errorText;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.errorText,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.label,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label optionnel au-dessus du champ
        if (widget.label != null) ...[
          Text(
            widget.label!.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFAAAAAA),
              letterSpacing: 0.8,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,           // ← fond blanc simple
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: hasError
                  ? AppTheme.error
                  : _isFocused
                  ? AppTheme.primary  // ← orange au focus
                  : AppTheme.border,  // ← gris neutre au repos
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? AppTheme.primary : _iconColor,
                size: 19,
              ),
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: widget.suffixIcon,
              )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 11,
                  color: AppTheme.error,
                ),
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