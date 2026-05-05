// Слой: core | Назначение: конфигурация GoRouter с редиректом по состоянию сессии

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_safe_scaffold.dart';
import '../../l10n/app_localizations.dart';
import '../../data/datasources/resume_local_datasource.dart';
import '../../data/datasources/resume_remote_datasource.dart';
import '../../data/datasources/company_profile_remote_datasource.dart';
import '../../data/repositories/company_profile_repository_remote_impl.dart';
import '../../data/repositories/resume_repository_local_impl.dart';
import '../../data/repositories/resume_repository_remote_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/company_profile_repository.dart';
import '../../domain/repositories/resume_repository.dart';
import '../../domain/usecases/update_account_profile_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/company_profile/company_profile_bloc.dart';
import '../../presentation/blocs/resume/resume_bloc.dart';
import '../../presentation/screens/analytics_screen.dart';
import '../../presentation/screens/company_home_screen.dart';
import '../../presentation/screens/company/create_vacancy_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/my_applications_screen.dart';
import '../../presentation/screens/notifications_screen.dart';
import '../../presentation/blocs/profile_edit/profile_edit_cubit.dart';
import '../../presentation/screens/edit_profile_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/resume_screen.dart';
import '../../presentation/screens/security_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/vacancy_details_screen.dart';

/// Custom Page Route с кросс-фейд анимацией
class _FadeTransitionPage<T> extends Page<T> {
  const _FadeTransitionPage({required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(Tween<double>(begin: 0, end: 1)),
          child: child,
        );
      },
    );
  }
}

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
        final homeByRole = authState.user.activeContext == UserRole.company
            ? AppConstants.routeCompanyHome
            : AppConstants.routeHome;

        if (isAuthRoute || isSplash) {
          return homeByRole;
        }

        if (authState.user.activeContext == UserRole.company &&
            state.matchedLocation == AppConstants.routeHome) {
          return AppConstants.routeCompanyHome;
        }

        if (authState.user.activeContext == UserRole.worker &&
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
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        pageBuilder: (context, state) {
          final extra = state.extra;
          return _FadeTransitionPage(
            child: RegisterScreen(
              initialRole: extra is UserRole ? extra : null,
            ),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeHome,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeCompanyHome,
        redirect: (context, state) {
          final s = authBloc.state;
          if (s is AuthInitial || s is AuthLoading) {
            return null;
          }
          if (s is! AuthAuthenticated) {
            return AppConstants.routeLogin;
          }
          if (s.user.activeContext != UserRole.company) {
            return AppConstants.routeHome;
          }
          return null;
        },
        pageBuilder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated ||
              (authState.user.authUid?.isEmpty ?? true)) {
            return _FadeTransitionPage(
              child: const CompanyHomeScreen(),
            );
          }
          final String uid = authState.user.authUid!;
          final CompanyProfileRepository repository =
              CompanyProfileRepositoryRemoteImpl(
            CompanyProfileRemoteDatasource(),
          );
          return _FadeTransitionPage(
            child: BlocProvider(
              create: (_) => CompanyProfileBloc(repository: repository)
                ..add(CompanyProfileLoadRequested(uid)),
              child: const CompanyHomeScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeCreateVacancy,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const CreateVacancyScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeAnalytics,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const AnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeMyApplications,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const MyApplicationsScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeStatistics,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const AnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeProfile,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeEditProfile,
        pageBuilder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return _FadeTransitionPage(
              child: Builder(
                builder: (ctx) => AppSafeScaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(ctx).routerNoAccess),
                  ),
                ),
              ),
            );
          }
          return _FadeTransitionPage(
            child: BlocProvider(
              create: (_) => ProfileEditCubit(
                UpdateAccountProfileUseCase(
                  context.read<AuthRepository>(),
                ),
              ),
              child: const EditProfileScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeResume,
        pageBuilder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return _FadeTransitionPage(
              child: Builder(
                builder: (ctx) => AppSafeScaffold(
                  body: Center(
                    child: Text(AppLocalizations.of(ctx).routerNoAccess),
                  ),
                ),
              ),
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

          return _FadeTransitionPage(
            child: BlocProvider(
              create: (_) => ResumeBloc(
                repository: repository,
                documentKey: documentKey,
                seedName: user.name,
                seedEmail: user.email,
              )..add(const ResumeLoadRequested()),
              child: const ResumeScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppConstants.routeNotifications,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeSecurity,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const SecurityScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        pageBuilder: (context, state) => _FadeTransitionPage(
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeVacancyDetails,
        pageBuilder: (context, state) {
          final payload = state.extra;
          if (payload is int) {
            return _FadeTransitionPage(
              child: VacancyDetailsScreen(vacancyId: payload),
            );
          }
          return _FadeTransitionPage(
            child: Builder(
              builder: (ctx) => AppSafeScaffold(
                body: Center(
                  child: Text(AppLocalizations.of(ctx).routerInvalidVacancyId),
                ),
              ),
            ),
          );
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
