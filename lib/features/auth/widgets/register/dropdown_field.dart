import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

const Color _iconColor = Color(0xFFCBD5E1);

class DropdownField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const DropdownField({
    super.key,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.value,
    this.errorText,
    // iconColor et iconBg supprimés
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: hasError ? AppTheme.error : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: const TextStyle(
                  color: Color(0xFFCCCCCC),
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: _iconColor, size: 20),
              borderRadius: BorderRadius.circular(11),
              padding: const EdgeInsets.only(left: 4, right: 8),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
                fontFamily: 'Poppins',
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
                  .toList(),
              onChanged: onChanged,
              selectedItemBuilder: (context) => items
                  .map((item) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 5),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 11, color: AppTheme.error),
                const SizedBox(width: 4),
                Text(
                  errorText!,
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