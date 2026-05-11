// lib/features/stagiaire/pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_model.dart';
import '../../chat/data/models/message_model.dart';
import '../../chat/logic/chat_bloc.dart';
import '../widgets/chat/chat_header.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/chat/chat_input.dart';
import '../widgets/chat/chat_date_divider.dart';

class ChatPage extends StatelessWidget {
  final StagiaireModel dossier;

  const ChatPage({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()
        ..add(LoadMessages(dossier.id, dossier.utilisateur.id)),
      child: _ChatView(dossier: dossier),
    );
  }
}

class _ChatView extends StatefulWidget {
  final StagiaireModel dossier;
  const _ChatView({required this.dossier});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(BuildContext ctx) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    final e = widget.dossier.encadrant;
    if (e == null) return;
    ctx.read<ChatBloc>().add(SendMessage(
      expediteurId:   widget.dossier.utilisateur.id,
      destinataireId: e.id,
      contenu:        text,
      myId:           widget.dossier.utilisateur.id,
    ));
  }

  bool _sameDay(String a, String b) {
    try {
      final da = DateTime.parse(a);
      final db = DateTime.parse(b);
      return da.year == db.year &&
          da.month == db.month &&
          da.day == db.day;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final e = widget.dossier.encadrant;

    return Column(children: [

      // ── Header ────────────────────────────────────────
      ChatHeader(encadrant: e),
      Container(height: 1, color: AppTheme.borderLight),

      // ── Messages ──────────────────────────────────────
      Expanded(
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (ctx, state) {
            if (state is ChatLoaded) _scrollToBottom();
          },
          builder: (ctx, state) {
            if (state is ChatLoading || state is ChatInitial) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppTheme.primary, strokeWidth: 2),
              );
            }

            if (state is ChatError) {
              return _ChatErrorView(
                onRetry: () => ctx.read<ChatBloc>().add(
                    LoadMessages(widget.dossier.id,
                        widget.dossier.utilisateur.id)),
              );
            }

            final msgs = state is ChatLoaded
                ? state.messages
                : state is ChatSending
                ? state.messages
                : <MessageModel>[];

            if (msgs.isEmpty) {
              return _ChatEmptyView(encadrantNom: e?.nomComplet);
            }

            return ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                final msg  = msgs[i];
                final prev = i > 0 ? msgs[i - 1] : null;
                final showDate = prev == null ||
                    !_sameDay(prev.dateEnvoi, msg.dateEnvoi);
                return Column(children: [
                  if (showDate) ChatDateDivider(dateStr: msg.dateEnvoi),
                  ChatBubble(message: msg, encadrant: e),
                ]);
              },
            );
          },
        ),
      ),

      // ── Input ──────────────────────────────────────────
      ChatInput(
        controller: _controller,
        onSend:     () => _send(context),
      ),
    ]);
  }
}

// ── Vues état vide / erreur ─────────────────────────────────────────

class _ChatEmptyView extends StatelessWidget {
  final String? encadrantNom;
  const _ChatEmptyView({this.encadrantNom});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Démarrez la conversation',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              )),
          const SizedBox(height: 5),
          Text(
            'Envoyez un message à ${encadrantNom ?? 'votre encadrant'}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppTheme.textSecond,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ChatErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.wifi_off_rounded,
                color: AppTheme.textLight, size: 24),
          ),
          const SizedBox(height: 14),
          const Text('Impossible de charger',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                fontSize: 14,
              )),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Réessayer',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}