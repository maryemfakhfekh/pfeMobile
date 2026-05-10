import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart'; // EncadrantModel est probablement ici
import '../../stagiaire_ui_tokens.dart';

class EncadrantsListCard extends StatelessWidget {
  final List<EncadrantModel> encadrants;
  const EncadrantsListCard({super.key, required this.encadrants});

  @override
  Widget build(BuildContext context) {
    if (encadrants.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: StagiaireUiTokens.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text('Encadrants', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 20, thickness: 0.5, color: AppTheme.border),
          ...encadrants.map((e) => _EncadrantItem(encadrant: e)),
        ],
      ),
    );
  }
}

class _EncadrantItem extends StatelessWidget {
  final EncadrantModel encadrant;
  const _EncadrantItem({required this.encadrant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(encadrant.nomComplet, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          // specialite supprimée
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 14, color: AppTheme.textLight),
              const SizedBox(width: 6),
              Text(encadrant.email, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.border)),
            child: const Text('Contacter'),
          ),
        ],
      ),
    );
  }
}