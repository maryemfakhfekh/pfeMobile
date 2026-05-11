// lib/features/stagiaire/widgets/dashboard/notif_sheet.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/tache_model.dart';
import 'notif_section_label.dart';
import 'notif_item.dart';

class NotifSheet extends StatelessWidget {
  final List<TacheModel> taches;

  const NotifSheet({super.key, required this.taches});

  static void show(BuildContext context, List<TacheModel> taches) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => NotifSheet(taches: taches),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now             = DateTime.now();
    final seuilNouvelle   = now.subtract(const Duration(days: 3));

    final enRetard = taches.where((t) {
      if (t.statut == TacheStatut.terminee) return false;
      final due = DateTime.tryParse(t.dateEcheance);
      return due != null && due.isBefore(now);
    }).toList();

    final nouvelles = taches.where((t) {
      if (t.dateCreation == null) return false;
      final created = DateTime.tryParse(t.dateCreation!);
      return created != null && created.isAfter(seuilNouvelle);
    }).toList();

    final nouvellesSansDoublons = nouvelles
        .where((t) => !enRetard.any((r) => r.id == t.id))
        .toList();

    final totalNotifs = enRetard.length + nouvellesSansDoublons.length;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [

          // ── Header ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                if (totalNotifs > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$totalNotifs',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE2E8F0), height: 1),

          // ── Liste ─────────────────────────────────────
          Expanded(
            child: totalNotifs == 0
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 40, color: Color(0xFFCBD5E1)),
                  SizedBox(height: 12),
                  Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            )
                : ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              children: [
                if (enRetard.isNotEmpty) ...[
                  NotifSectionLabel(
                    label: 'En retard',
                    color: AppTheme.error,
                    icon:  Icons.warning_amber_rounded,
                  ),
                  const SizedBox(height: 8),
                  ...enRetard.map((t) => NotifItem(
                    icon:      Icons.schedule_rounded,
                    iconColor: AppTheme.error,
                    iconBg:    const Color(0xFFFEF2F2),
                    title:     t.titre,
                    subtitle:  'Échéance dépassée · ${t.dateEcheance}',
                  )),
                  const SizedBox(height: 16),
                ],
                if (nouvellesSansDoublons.isNotEmpty) ...[
                  NotifSectionLabel(
                    label: 'Nouvelles tâches',
                    color: AppTheme.primary,
                    icon:  Icons.add_task_rounded,
                  ),
                  const SizedBox(height: 8),
                  ...nouvellesSansDoublons.map((t) => NotifItem(
                    icon:      Icons.task_alt_rounded,
                    iconColor: AppTheme.primary,
                    iconBg:    AppTheme.primarySoft,
                    title:     t.titre,
                    subtitle:  'Assignée le ${t.dateCreation ?? ''}',
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}