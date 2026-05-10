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
        return Column(children: [
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.fromLTRB(20, top + 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Messages',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: AppTheme.textDark)),
                Text('${stagiaires.length} conversation(s)',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Container(height: 1, color: AppTheme.borderLight),
          Expanded(
            child: stagiaires.isEmpty
                ? const _MessagesEmpty()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              itemCount: stagiaires.length,
              itemBuilder: (_, i) => ConversationCard(s: stagiaires[i]),
            ),
          ),
        ]);
      },
    );
  }
}

class _MessagesEmpty extends StatelessWidget {
  const _MessagesEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primarySoft,
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          ),
          child: const Icon(Icons.chat_bubble_outline_rounded,
              color: AppTheme.primary, size: 28),
        ),
        const SizedBox(height: 14),
        Text('Aucun stagiaire affecté',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        Text('Les conversations apparaîtront ici',
            style: Theme.of(context).textTheme.bodySmall),
      ]),
    );
  }
}