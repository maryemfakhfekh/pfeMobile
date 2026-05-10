import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../logic/internship_bloc.dart';
import '../../logic/internship_state.dart';

class SubjectHeader extends StatelessWidget {
  const SubjectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: BlocBuilder<InternshipBloc, InternshipState>(
            builder: (context, state) {
              final count =
              state is SubjectsLoaded ? state.subjects.length : 0;
              final available = state is SubjectsLoaded
                  ? state.subjects.where((s) => s.estDisponible).length
                  : 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Offres de Stage",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.router.push(const ProfileRoute()),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppTheme.primarySoft,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.18),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppTheme.primary,
                            size: 21,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Trouvez le stage qui vous correspond",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecond,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Stats card ─────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.shadowSM,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.work_outline_rounded,
                            value: '$count',
                            label: 'Offres',
                            color: AppTheme.primary,
                            bg: AppTheme.primarySoft,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 38,
                          color: AppTheme.border,
                        ),
                        Expanded(
                          child: _buildStatTile(
                            icon: Icons.check_circle_outline_rounded,
                            value: '$available',
                            label: 'Disponibles',
                            color: AppTheme.success,
                            bg: const Color(0xFFF0FDF4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecond,
              ),
            ),
          ],
        ),
      ],
    );
  }
}