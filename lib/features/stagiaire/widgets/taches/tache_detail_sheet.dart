// lib/features/stagiaire/widgets/taches/tache_detail_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/tache_model.dart';
import '../../logic/tache_bloc.dart';

class TacheDetailSheet extends StatelessWidget {
  final TacheModel tache;

  const TacheDetailSheet({super.key, required this.tache});

  static Future<void> show(BuildContext context, TacheModel tache) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<TacheBloc>(),
        child: TacheDetailSheet(tache: tache),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 16, 20,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ── Titre ──────────────────────────────────────
          Text(
            tache.titre,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),

          // ── Description ────────────────────────────────
          if (tache.description != null) ...[
            const SizedBox(height: 8),
            Text(
              tache.description!,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Date échéance ──────────────────────────────
          if (tache.dateEcheance.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), width: 0.5),
              ),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Text(
                  'Échéance : ${tache.dateEcheance}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ]),
            ),

          const SizedBox(height: 20),

          // ── Boutons statut ─────────────────────────────
          Row(children: [
            _StatutBtn(
              tache:  tache,
              statut: TacheStatut.aFaire,
              label:  'À faire',
            ),
            const SizedBox(width: 8),
            _StatutBtn(
              tache:  tache,
              statut: TacheStatut.enCours,
              label:  'En cours',
            ),
            const SizedBox(width: 8),
            _StatutBtn(
              tache:  tache,
              statut: TacheStatut.terminee,
              label:  'Terminée',
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatutBtn extends StatelessWidget {
  final TacheModel  tache;
  final TacheStatut statut;
  final String      label;

  const _StatutBtn({
    required this.tache,
    required this.statut,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tache.statut == statut;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<TacheBloc>().add(UpdateStatutTache(tache.id, statut));
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF1E293B)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}