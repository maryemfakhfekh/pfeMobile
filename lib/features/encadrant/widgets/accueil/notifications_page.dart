// lib/features/encadrant/pages/notifications_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotifItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String titre;
  final String sousTitre;
  final String temps;
  final bool isUnread;
  final VoidCallback? onTap;

  const NotifItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.titre,
    required this.sousTitre,
    required this.temps,
    this.isUnread = true,
    this.onTap,
  });
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Remplace par tes vraies données depuis le BLoC
  final List<NotifItem> _notifs = const [
    NotifItem(
      icon: Icons.access_time_rounded,
      iconColor: Color(0xFFA32D2D),
      iconBg: Color(0xFFFCEBEB),
      titre: 'Tâche en retard — Lina Tounsi',
      sousTitre: 'Contrôleur REST · due il y a 3 jours',
      temps: 'Il y a 3h',
      isUnread: true,
    ),
    NotifItem(
      icon: Icons.description_outlined,
      iconColor: Color(0xFF854F0B),
      iconBg: Color(0xFFFAEEDA),
      titre: 'Rapport non soumis — Samy Ben Salah',
      sousTitre: 'Semaine du 5 mai · en attente',
      temps: 'Il y a 5h',
      isUnread: true,
    ),
    NotifItem(
      icon: Icons.check_circle_outline_rounded,
      iconColor: Color(0xFF854F0B),
      iconBg: Color(0xFFFAEEDA),
      titre: 'Entretien à marquer réalisé',
      sousTitre: 'Rania Meddeb · en attente de votre commentaire',
      temps: 'Il y a 1j',
      isUnread: true,
    ),
    NotifItem(
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF0F6E56),
      iconBg: Color(0xFFE1F5EE),
      titre: 'Amine Khelil a atteint 95%',
      sousTitre: 'Fin de stage dans 12 jours · pensez à l\'évaluation',
      temps: 'Il y a 1j',
      isUnread: false,
    ),
    NotifItem(
      icon: Icons.upload_file_rounded,
      iconColor: Color(0xFF185FA5),
      iconBg: Color(0xFFE6F1FB),
      titre: 'Rapport uploadé — Samy Ben Salah',
      sousTitre: 'Semaine 18 · rapport disponible',
      temps: 'Il y a 2j',
      isUnread: false,
    ),
  ];

  int get _unreadCount => _notifs.where((n) => n.isUnread).length;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // ── AppBar custom ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(8, top + 8, 16, 12),
            child: Row(
              children: [
                // Retour
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: Color(0xFF0F172A)),
                ),
                const Expanded(
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                // Badge non lus
                if (_unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_unreadCount non lues',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA32D2D),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Liste ─────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              physics: const BouncingScrollPhysics(),
              itemCount: _notifs.length,
              itemBuilder: (context, index) {
                final n = _notifs[index];
                return _NotifRow(item: n);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _NotifRow extends StatelessWidget {
  final NotifItem item;

  const _NotifRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: item.isUnread ? Colors.white : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isUnread
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFF1F5F9),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 18),
                ),
                const SizedBox(width: 12),

                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titre,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: item.isUnread
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.sousTitre,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.temps,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Point non lu
                if (item.isUnread) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE24B4A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}