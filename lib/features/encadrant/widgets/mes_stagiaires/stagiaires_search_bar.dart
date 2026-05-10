// lib/features/encadrant/widgets/mes_stagiaires/stagiaires_search_bar.dart

import 'package:flutter/material.dart';

class StagiairesSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const StagiairesSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF0F172A),
          ),
          decoration: const InputDecoration(
            hintText: 'Rechercher un stagiaire...',
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}