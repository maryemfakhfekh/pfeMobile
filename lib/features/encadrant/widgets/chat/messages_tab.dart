// lib/features/encadrant/widgets/chat/messages_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/encadrant_bloc.dart';
import '../../logic/encadrant_state.dart';
import 'conversation_card.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (ctx, state) {
        final stagiaires = state.stagiaires;

        return Column(
          children: [

            // ── Header ───────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${stagiaires.length} conversation${stagiaires.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFE2E8F0), height: 1),

            // ── Liste ────────────────────────────────────────
            Expanded(
              child: Container(
                color: Colors.white,
                child: stagiaires.isEmpty
                    ? const _MessagesEmpty()
                    : ListView.separated(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 80,
                  ),
                  itemCount: stagiaires.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFFE2E8F0),
                    height: 1,
                    indent: 76,
                  ),
                  itemBuilder: (_, i) => ConversationCard(
                    s: stagiaires[i],
                    index: i,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MessagesEmpty extends StatelessWidget {
  const _MessagesEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppTheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune conversation',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Les conversations apparaîtront ici',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}