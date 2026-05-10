// lib/features/stagiaire/widgets/dashboard/tabs/chat_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../../../../../features/chat/logic/chat_bloc.dart'; // ✅ corrigé

class ChatTab extends StatelessWidget {
  final StagiaireModel dossier;
  const ChatTab({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()
        ..add(LoadMessages(
          dossier.id,
          dossier.utilisateur.id,
        )),
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

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final e = widget.dossier.encadrant;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Column(
      children: [

        // ── Header ──────────────────────────────────────
        Container(
          color: AppTheme.surface,
          padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 12),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: const BoxDecoration(
                      color: AppTheme.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        e != null ? _initials(e.nomComplet) : '?',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 1, right: 1,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.surface, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e?.nomComplet ?? 'Encadrant',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.circle, size: 7, color: AppTheme.success),
                        SizedBox(width: 4),
                        Text(
                          'En ligne',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: AppTheme.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: AppTheme.textSecond, size: 18),
              ),
            ],
          ),
        ),

        Container(height: 1, color: AppTheme.borderLight),

        // ── Messages ─────────────────────────────────────
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
                        onTap: () => ctx.read<ChatBloc>().add(
                            LoadMessages(widget.dossier.id,
                                widget.dossier.utilisateur.id)),
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

              final msgs = state is ChatLoaded
                  ? state.messages
                  : state is ChatSending
                  ? state.messages
                  : <dynamic>[];

              if (msgs.isEmpty) {
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
                        child: const Icon(
                            Icons.chat_bubble_outline_rounded,
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
                        'Envoyez un message à ${e?.nomComplet ?? 'votre encadrant'}',
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

              return ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                itemCount: msgs.length,
                itemBuilder: (_, i) {
                  final msg  = msgs[i];
                  final prev = i > 0 ? msgs[i - 1] : null;
                  final showDate = prev == null ||
                      !_sameDay(prev.dateEnvoi, msg.dateEnvoi);
                  return Column(
                    children: [
                      if (showDate) _buildDateDivider(msg.dateEnvoi),
                      _buildBubble(msg, e),
                    ],
                  );
                },
              );
            },
          ),
        ),

        // ── Input ────────────────────────────────────────
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Écrire un message...',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppTheme.textLight,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(context),
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(context),
                child: Container(
                  width: 42, height: 42,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(dynamic msg, dynamic e) {
    final isMine = msg.isMine as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                  color: AppTheme.textPrimary, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  e != null ? _initials(e.nomComplet) : '?',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMine ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft:     const Radius.circular(16),
                      topRight:    const Radius.circular(16),
                      bottomLeft:  Radius.circular(isMine ? 16 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 16),
                    ),
                    boxShadow: isMine ? null : AppTheme.shadowSM,
                  ),
                  child: Text(
                    msg.contenu as String,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: isMine ? Colors.white : AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(msg.dateEnvoi as String),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      color: AppTheme.textLight),
                ),
              ],
            ),
          ),
          if (isMine) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String dateStr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _formatDate(dateStr),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: AppTheme.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        ],
      ),
    );
  }

  bool _sameDay(String a, String b) {
    try {
      final da = DateTime.parse(a);
      final db = DateTime.parse(b);
      return da.year == db.year &&
          da.month == db.month &&
          da.day == db.day;
    } catch (_) { return false; }
  }

  String _formatDate(String dateStr) {
    try {
      final d   = DateTime.parse(dateStr);
      final now = DateTime.now();
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        return "Aujourd'hui";
      }
      final y = now.subtract(const Duration(days: 1));
      if (d.year == y.year && d.month == y.month && d.day == y.day) {
        return 'Hier';
      }
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) { return dateStr; }
  }

  String _formatTime(String dateStr) {
    try {
      final d = DateTime.parse(dateStr);
      return '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}';
    } catch (_) { return ''; }
  }
}