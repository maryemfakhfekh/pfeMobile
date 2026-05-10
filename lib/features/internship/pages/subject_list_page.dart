import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/list/subject_header.dart';
import '../widgets/list/subject_card.dart';
import '../widgets/list/state_widgets.dart';
import '../logic/internship_bloc.dart';
import '../logic/internship_event.dart';
import '../logic/internship_state.dart';
import '../data/models/sujet_model.dart';

@RoutePage()
class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900))
      ..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InternshipBloc>().add(LoadSubjects());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SujetModel> _applyFilters(List<SujetModel> subjects) {
    return subjects.where((s) {
      return _searchQuery.isEmpty ||
          s.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const SubjectHeader(),

          // ── Divider ───────────────────────────────────
          Container(height: 1, color: AppTheme.border),

          // ── Search bar ────────────────────────────────
          _buildSearchBar(),

          // ── Liste ─────────────────────────────────────
          Expanded(child: _buildListSection()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Rechercher un stage...',
            hintStyle: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppTheme.textLight,
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(
                Icons.close_rounded,
                color: AppTheme.textLight,
                size: 18,
              ),
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildListSection() {
    return BlocBuilder<InternshipBloc, InternshipState>(
      builder: (context, state) {

        if (state is InternshipLoading) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppTheme.primary,
                  strokeWidth: 2,
                ),
                SizedBox(height: 16),
                Text(
                  "Chargement des offres...",
                  style: TextStyle(
                    color: AppTheme.textSecond,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is InternshipError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () =>
                context.read<InternshipBloc>().add(LoadSubjects()),
          );
        }

        if (state is SubjectsLoaded) {
          final filtered = _applyFilters(state.subjects);
          if (filtered.isEmpty) return const EmptyStateWidget();

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  (index * 0.08).clamp(0.0, 0.9),
                  1.0,
                  curve: Curves.easeOut,
                ),
              );
              return SubjectCard(
                sujet: filtered[index],
                index: index,
                animation: animation,
              );
            },
          );
        }
        return const EmptyStateWidget();
      },
    );
  }
}