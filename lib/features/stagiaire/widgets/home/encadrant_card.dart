// lib/features/stagiaire/widgets/home/encadrant_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';

class EncadrantCard extends StatelessWidget {
  final EncadrantModel? encadrant;
  final VoidCallback?   onChatTap;

  const EncadrantCard({
    super.key,
    required this.encadrant,
    this.onChatTap,
  });

  String get _initials {
    if (encadrant == null) return '?';
    final parts = encadrant!.nomComplet.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return encadrant!.nomComplet.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (encadrant == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [

          Container(
            width: 48, height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  encadrant!.nomComplet,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  encadrant!.email,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Disponible',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final tel = encadrant!.telephone;
                  if (tel != null && tel.isNotEmpty) {
                    final uri = Uri.parse('tel:$tel');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  }
                },
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAFAF0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.phone_rounded, color: Color(0xFF16A34A), size: 18),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onChatTap,
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.primary, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}