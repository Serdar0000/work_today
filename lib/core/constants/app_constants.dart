// Слой: core | Назначение: глобальные константы приложения

class AppConstants {
  AppConstants._();

  // Ключи SharedPreferences
  static const String kSessionKey = 'session_user_id';
  static const String kUserEmailKey = 'session_user_email';
  static const String kUserRoleKey = 'session_user_role';

  // Имя файла базы данных
  static const String kDatabaseName = 'app_database.sqlite';

  // Маршруты
  static const String routeSplash = '/splash';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeCompanyHome = '/company-home';
  static const String routeAnalytics = '/analytics';
  static const String routeVacancyDetails = '/vacancy-details';
  static const String routeMyApplications = '/my-applications';
  static const String routeStatistics = '/statistics';
  static const String routeProfile = '/profile';
  static const String routeResume = '/resume';
  static const String routeNotifications = '/notifications';

  // Ограничения валидации
  static const int kMinPasswordLength = 6;
  static const int kMaxTitleLength = 100;
}
