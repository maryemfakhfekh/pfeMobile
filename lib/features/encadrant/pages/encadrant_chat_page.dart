// lib/features/encadrant/pages/encadrant_chat_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../../chat/logic/chat_bloc.dart';
import '../widgets/chat/index.dart';

@RoutePage()
class EncadrantChatPage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  const EncadrantChatPage({super.key, required this.stagiaire});

  @override
  State<EncadrantChatPage> createState() => _EncadrantChatPageState();
}

class _EncadrantChatPageState extends State<EncadrantChatPage> {
  int _encadrantUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await const FlutterSecureStorage().read(key: 'userId') ?? '0';
    if (mounted) setState(() => _encadrantUserId = int.tryParse(id) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    if (_encadrantUserId == 0) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: CircularProgressIndicator(
              color: AppTheme.primary, strokeWidth: 2),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<ChatBloc>()
        ..add(LoadMessages(widget.stagiaire.id, _encadrantUserId)),
      child: _ChatView(
        stagiaire: widget.stagiaire,
        encadrantUserId: _encadrantUserId,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Vue principale : orchestrateur des widgets
// ─────────────────────────────────────────────────────────────
class _ChatView extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;
  final int encadrantUserId;
  const _ChatView({required this.stagiaire, required this.encadrantUserId});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

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

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatBloc>().add(SendMessage(
      expediteurId: widget.encadrantUserId,
      destinataireId: widget.stagiaire.utilisateurId,
      contenu: text,
      myId: widget.encadrantUserId,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          ChatAppBar(stagiaire: widget.stagiaire),
          Container(height: 1, color: AppTheme.borderLight),

          // ── Liste des messages ───────────────────────────────
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (_, state) {
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
                  return ChatErrorState(
                    onRetry: () => ctx.read<ChatBloc>().add(
                      LoadMessages(
                        widget.stagiaire.id,
                        widget.encadrantUserId,
                      ),
                    ),
                  );
                }

                final msgs = state is ChatLoaded
                    ? state.messages
                    : state is ChatSending
                    ? state.messages
                    : <dynamic>[];

                if (msgs.isEmpty) {
                  return ChatEmptyState(
                      nomComplet: widget.stagiaire.nomComplet);
                }

                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final msg = msgs[i];
                    final prev = i > 0 ? msgs[i - 1] : null;
                    final showDate = prev == null ||
                        !isSameDay(prev.dateEnvoi, msg.dateEnvoi);

                    return Column(
                      children: [
                        if (showDate)
                          ChatDateDivider(dateStr: msg.dateEnvoi as String),
                        ChatBubble(
                          message: msg,
                          stagiaire: widget.stagiaire,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // ── Saisie ───────────────────────────────────────────
          ChatInputBar(
            controller: _controller,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}