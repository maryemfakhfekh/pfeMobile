// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CreerTacheRoute.name: (routeData) {
      final args = routeData.argsAs<CreerTacheRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreerTachePage(
          key: args.key,
          stagiaire: args.stagiaire,
        ),
      );
    },
    DetailStagiaireRoute.name: (routeData) {
      final args = routeData.argsAs<DetailStagiaireRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: DetailStagiairePage(
          key: args.key,
          stagiaire: args.stagiaire,
        ),
      );
    },
    EncadrantChatRoute.name: (routeData) {
      final args = routeData.argsAs<EncadrantChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EncadrantChatPage(
          key: args.key,
          stagiaire: args.stagiaire,
        ),
      );
    },
    EncadrantHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EncadrantHomePage(),
      );
    },
    EncadrantProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EncadrantProfilePage(),
      );
    },
    EvaluationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EvaluationPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MesStagiairesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MesStagiairesPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfilePage(),
      );
    },
    RapportDetailRoute.name: (routeData) {
      final args = routeData.argsAs<RapportDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RapportDetailPage(
          key: args.key,
          stagiaire: args.stagiaire,
        ),
      );
    },
    RegisterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    StagiaireHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const StagiaireHomePage(),
      );
    },
    SubjectDetailRoute.name: (routeData) {
      final args = routeData.argsAs<SubjectDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SubjectDetailPage(
          key: args.key,
          sujet: args.sujet,
        ),
      );
    },
    SubjectListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SubjectListPage(),
      );
    },
    UploadCvRoute.name: (routeData) {
      final args = routeData.argsAs<UploadCvRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UploadCvPage(
          key: args.key,
          sujetId: args.sujetId,
        ),
      );
    },
  };
}

/// generated route for
/// [CreerTachePage]
class CreerTacheRoute extends PageRouteInfo<CreerTacheRouteArgs> {
  CreerTacheRoute({
    Key? key,
    required StagiaireEncadrantModel stagiaire,
    List<PageRouteInfo>? children,
  }) : super(
          CreerTacheRoute.name,
          args: CreerTacheRouteArgs(
            key: key,
            stagiaire: stagiaire,
          ),
          initialChildren: children,
        );

  static const String name = 'CreerTacheRoute';

  static const PageInfo<CreerTacheRouteArgs> page =
      PageInfo<CreerTacheRouteArgs>(name);
}

class CreerTacheRouteArgs {
  const CreerTacheRouteArgs({
    this.key,
    required this.stagiaire,
  });

  final Key? key;

  final StagiaireEncadrantModel stagiaire;

  @override
  String toString() {
    return 'CreerTacheRouteArgs{key: $key, stagiaire: $stagiaire}';
  }
}

/// generated route for
/// [DetailStagiairePage]
class DetailStagiaireRoute extends PageRouteInfo<DetailStagiaireRouteArgs> {
  DetailStagiaireRoute({
    Key? key,
    required StagiaireEncadrantModel stagiaire,
    List<PageRouteInfo>? children,
  }) : super(
          DetailStagiaireRoute.name,
          args: DetailStagiaireRouteArgs(
            key: key,
            stagiaire: stagiaire,
          ),
          initialChildren: children,
        );

  static const String name = 'DetailStagiaireRoute';

  static const PageInfo<DetailStagiaireRouteArgs> page =
      PageInfo<DetailStagiaireRouteArgs>(name);
}

class DetailStagiaireRouteArgs {
  const DetailStagiaireRouteArgs({
    this.key,
    required this.stagiaire,
  });

  final Key? key;

  final StagiaireEncadrantModel stagiaire;

  @override
  String toString() {
    return 'DetailStagiaireRouteArgs{key: $key, stagiaire: $stagiaire}';
  }
}

/// generated route for
/// [EncadrantChatPage]
class EncadrantChatRoute extends PageRouteInfo<EncadrantChatRouteArgs> {
  EncadrantChatRoute({
    Key? key,
    required StagiaireEncadrantModel stagiaire,
    List<PageRouteInfo>? children,
  }) : super(
          EncadrantChatRoute.name,
          args: EncadrantChatRouteArgs(
            key: key,
            stagiaire: stagiaire,
          ),
          initialChildren: children,
        );

  static const String name = 'EncadrantChatRoute';

  static const PageInfo<EncadrantChatRouteArgs> page =
      PageInfo<EncadrantChatRouteArgs>(name);
}

class EncadrantChatRouteArgs {
  const EncadrantChatRouteArgs({
    this.key,
    required this.stagiaire,
  });

  final Key? key;

  final StagiaireEncadrantModel stagiaire;

  @override
  String toString() {
    return 'EncadrantChatRouteArgs{key: $key, stagiaire: $stagiaire}';
  }
}

/// generated route for
/// [EncadrantHomePage]
class EncadrantHomeRoute extends PageRouteInfo<void> {
  const EncadrantHomeRoute({List<PageRouteInfo>? children})
      : super(
          EncadrantHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'EncadrantHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EncadrantProfilePage]
class EncadrantProfileRoute extends PageRouteInfo<void> {
  const EncadrantProfileRoute({List<PageRouteInfo>? children})
      : super(
          EncadrantProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EncadrantProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EvaluationPage]
class EvaluationRoute extends PageRouteInfo<void> {
  const EvaluationRoute({List<PageRouteInfo>? children})
      : super(
          EvaluationRoute.name,
          initialChildren: children,
        );

  static const String name = 'EvaluationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MesStagiairesPage]
class MesStagiairesRoute extends PageRouteInfo<void> {
  const MesStagiairesRoute({List<PageRouteInfo>? children})
      : super(
          MesStagiairesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MesStagiairesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RapportDetailPage]
class RapportDetailRoute extends PageRouteInfo<RapportDetailRouteArgs> {
  RapportDetailRoute({
    Key? key,
    required StagiaireEncadrantModel stagiaire,
    List<PageRouteInfo>? children,
  }) : super(
          RapportDetailRoute.name,
          args: RapportDetailRouteArgs(
            key: key,
            stagiaire: stagiaire,
          ),
          initialChildren: children,
        );

  static const String name = 'RapportDetailRoute';

  static const PageInfo<RapportDetailRouteArgs> page =
      PageInfo<RapportDetailRouteArgs>(name);
}

class RapportDetailRouteArgs {
  const RapportDetailRouteArgs({
    this.key,
    required this.stagiaire,
  });

  final Key? key;

  final StagiaireEncadrantModel stagiaire;

  @override
  String toString() {
    return 'RapportDetailRouteArgs{key: $key, stagiaire: $stagiaire}';
  }
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StagiaireHomePage]
class StagiaireHomeRoute extends PageRouteInfo<void> {
  const StagiaireHomeRoute({List<PageRouteInfo>? children})
      : super(
          StagiaireHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'StagiaireHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SubjectDetailPage]
class SubjectDetailRoute extends PageRouteInfo<SubjectDetailRouteArgs> {
  SubjectDetailRoute({
    Key? key,
    required SujetModel sujet,
    List<PageRouteInfo>? children,
  }) : super(
          SubjectDetailRoute.name,
          args: SubjectDetailRouteArgs(
            key: key,
            sujet: sujet,
          ),
          initialChildren: children,
        );

  static const String name = 'SubjectDetailRoute';

  static const PageInfo<SubjectDetailRouteArgs> page =
      PageInfo<SubjectDetailRouteArgs>(name);
}

class SubjectDetailRouteArgs {
  const SubjectDetailRouteArgs({
    this.key,
    required this.sujet,
  });

  final Key? key;

  final SujetModel sujet;

  @override
  String toString() {
    return 'SubjectDetailRouteArgs{key: $key, sujet: $sujet}';
  }
}

/// generated route for
/// [SubjectListPage]
class SubjectListRoute extends PageRouteInfo<void> {
  const SubjectListRoute({List<PageRouteInfo>? children})
      : super(
          SubjectListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SubjectListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UploadCvPage]
class UploadCvRoute extends PageRouteInfo<UploadCvRouteArgs> {
  UploadCvRoute({
    Key? key,
    required int sujetId,
    List<PageRouteInfo>? children,
  }) : super(
          UploadCvRoute.name,
          args: UploadCvRouteArgs(
            key: key,
            sujetId: sujetId,
          ),
          initialChildren: children,
        );

  static const String name = 'UploadCvRoute';

  static const PageInfo<UploadCvRouteArgs> page =
      PageInfo<UploadCvRouteArgs>(name);
}

class UploadCvRouteArgs {
  const UploadCvRouteArgs({
    this.key,
    required this.sujetId,
  });

  final Key? key;

  final int sujetId;

  @override
  String toString() {
    return 'UploadCvRouteArgs{key: $key, sujetId: $sujetId}';
  }
}
