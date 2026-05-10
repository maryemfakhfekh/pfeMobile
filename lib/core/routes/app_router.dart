import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../features/auth/pages/profile_page.dart';
import '../../features/internship/data/models/sujet_model.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/internship/pages/subject_list_page.dart';
import '../../features/internship/pages/subject_detail_page.dart';
import '../../features/internship/pages/upload_cv_page.dart';
import '../../features/encadrant/pages/encadrant_home_page.dart';
import '../../features/encadrant/pages/encadrant_profile_page.dart';
import '../../features/encadrant/pages/mes_stagiaires_page.dart';
import '../../features/encadrant/pages/detail_stagiaire_page.dart';
import '../../features/encadrant/pages/rapport_detail_page.dart';
import '../../features/encadrant/pages/creer_tache_page.dart';
import '../../features/encadrant/pages/evaluation_page.dart';
import '../../features/encadrant/pages/encadrant_chat_page.dart';
import '../../features/encadrant/data/models/stagiaire_encadrant_model.dart';
import '../../features/stagiaire/pages/stagiaire_home_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),

    // Routes Candidat
    AutoRoute(page: SubjectListRoute.page),
    AutoRoute(page: SubjectDetailRoute.page),
    AutoRoute(page: UploadCvRoute.page),
    AutoRoute(page: ProfileRoute.page),

    // Routes Encadrant
    AutoRoute(page: EncadrantHomeRoute.page),
    AutoRoute(page: EncadrantProfileRoute.page),
    AutoRoute(page: MesStagiairesRoute.page),
    AutoRoute(page: DetailStagiaireRoute.page),
    AutoRoute(page: RapportDetailRoute.page),
    AutoRoute(page: CreerTacheRoute.page),
    AutoRoute(page: EvaluationRoute.page), // ✅ sans paramètre maintenant
    AutoRoute(page: EncadrantChatRoute.page),

    // Routes Stagiaire Actif
    AutoRoute(page: StagiaireHomeRoute.page),
  ];
}