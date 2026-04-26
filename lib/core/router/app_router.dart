// Слой: core | Назначение: конфигурация GoRouter с редиректом по состоянию сессии

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../data/datasources/resume_local_datasource.dart';
import '../../data/datasources/resume_remote_datasource.dart';
import '../../data/repositories/resume_repository_local_impl.dart';
import '../../data/repositories/resume_repository_remote_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/resume_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/resume/resume_bloc.dart';
import '../../presentation/screens/analytics_screen.dart';
import '../../presentation/screens/company_home_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/my_applications_screen.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/resume_screen.dart';
import '../../presentation/screens/security_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/vacancy_details_screen.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppConstants.routeSplash,
    refreshListenable: _AuthStateListenable(authBloc),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthRoute = state.matchedLocation == AppConstants.routeLogin ||
          state.matchedLocation == AppConstants.routeRegister;
      final isSplash = state.matchedLocation == AppConstants.routeSplash;

      if (authState is AuthLoading || authState is AuthInitial) {
        return isSplash ? null : AppConstants.routeSplash;
      }

      if (authState is AuthAuthenticated) {
        final homeByRole = authState.user.role == UserRole.company
            ? AppConstants.routeCompanyHome
            : AppConstants.routeHome;

        if (isAuthRoute || isSplash) {
          return homeByRole;
        }

        if (authState.user.role == UserRole.company &&
            state.matchedLocation == AppConstants.routeHome) {
          return AppConstants.routeCompanyHome;
        }

        if (authState.user.role == UserRole.worker &&
            state.matchedLocation == AppConstants.routeCompanyHome) {
          return AppConstants.routeHome;
        }

        return null;
      }

      if (authState is AuthUnauthenticated) {
        return isAuthRoute ? null : AppConstants.routeLogin;
      }

      if (authState is AuthError) {
        return isAuthRoute ? null : AppConstants.routeLogin;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.routeHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeCompanyHome,
        builder: (context, state) => const CompanyHomeScreen(),
      ),
      GoRoute(
        path: AppConstants.routeAnalytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeMyApplications,
        builder: (context, state) => const MyApplicationsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeStatistics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeProfile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppConstants.routeResume,
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return const Scaffold(
              body: Center(child: Text('Нет доступа')),
            );
          }
          final user = authState.user;
          final useRemote =
              Firebase.apps.isNotEmpty && (user.authUid?.isNotEmpty ?? false);
          final ResumeRepository repository = useRemote
              ? ResumeRepositoryRemoteImpl(ResumeRemoteDatasource())
              : ResumeRepositoryLocalImpl(ResumeLocalDatasource());
          final documentKey =
              useRemote ? user.authUid! : 'local_${user.id}';

          return BlocProvider(
            create: (_) => ResumeBloc(
              repository: repository,
              documentKey: documentKey,
              seedName: user.name,
              seedEmail: user.email,
            )..add(const ResumeLoadRequested()),
            child: const ResumeScreen(),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeNotifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSecurity,
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppConstants.routeVacancyDetails,
        builder: (context, state) {
          final payload = state.extra;
          if (payload is Map<String, dynamic>) {
            return VacancyDetailsScreen(vacancy: payload);
          }
          return const VacancyDetailsScreen(vacancy: null);
        },
      ),
    ],
  );
}

// Уведомляет GoRouter об изменениях состояния AuthBloc
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._authBloc) {
    _authBloc.stream.listen((_) => notifyListeners());
  }

  final AuthBloc _authBloc;
}
