import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/di/injection.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/internship/logic/internship_bloc.dart';
import 'features/encadrant/logic/encadrant_bloc.dart';
import 'features/stagiaire/logic/stagiaire_bloc.dart';
import 'features/stagiaire/logic/tache_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<InternshipBloc>(
          create: (context) => sl<InternshipBloc>(),
        ),
        BlocProvider<EncadrantBloc>(
          create: (context) => sl<EncadrantBloc>(),
        ),
        BlocProvider<StagiaireBloc>(
          create: (context) => sl<StagiaireBloc>(),
        ),
        BlocProvider<TacheBloc>(
          create: (context) => sl<TacheBloc>(),
        ),

      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ASM Stages',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.config(),
      ),
    );
  }
}