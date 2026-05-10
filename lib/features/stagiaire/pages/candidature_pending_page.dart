// lib/features/stagiaire/pages/candidature_pending_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/pending/pending_status_card.dart';
import '../widgets/pending/pending_info_card.dart';

class CandidaturePendingPage extends StatefulWidget {
  const CandidaturePendingPage({super.key});

  @override
  State<CandidaturePendingPage> createState() =>
      _CandidaturePendingPageState();
}

class _CandidaturePendingPageState extends State<CandidaturePendingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600))
      ..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [

          // ── Header ─────────────────────────────────────
          Container(
            color: AppTheme.background,
            padding: EdgeInsets.fromLTRB(18, topPadding + 14, 18, 14),
            child: Row(
              children: [

                // Icône ASM
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: AppTheme.primary, size: 20),
                ),

                const SizedBox(width: 14),

                // Titre
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mon Dossier',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        'Suivi de votre candidature',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppTheme.textSecond,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge EN ATTENTE
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'EN ATTENTE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppTheme.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Contenu ────────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _anim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                child: Column(
                  children: [

                    // Card statut animée
                    const PendingStatusCard(),
                    const SizedBox(height: 10),

                    // Card info candidature
                    const PendingInfoCard(),
                    const SizedBox(height: 10),

                    // Note email
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.shadowSM,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: AppTheme.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Vous recevrez un email dès que le RH aura pris une décision.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppTheme.textSecond,
                                fontSize: 12,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}