// Слой: core | Назначение: глобальные константы приложения

class AppConstants {
  AppConstants._();

  // Ключи SharedPreferences
  static const String kSessionKey = 'session_user_id';
  static const String kSessionAuthUidKey = 'session_user_auth_uid';
  static const String kUserEmailKey = 'session_user_email';
  static const String kUserRoleKey = 'session_user_role';

  /// Предпочитаемый город (настройки): фильтр вакансий на главной по умолчанию.
  static const String kPreferredCityKey = 'settings_preferred_city';

  /// Ежедневные заходы в профиль: последний учтённый календарный день (yyyy-MM-dd).
  static const String kActivityLastOpenDayKey = 'profile_activity_last_day';
  /// Сколько дней подряд пользователь заходил (обновляется при открытии профиля).
  static const String kActivityStreakKey = 'profile_activity_streak';

  // Имя файла базы данных
  static const String kDatabaseName = 'app_database.sqlite';

  // Маршруты
  static const String routeSplash = '/splash';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeCompanyHome = '/company-home';
  static const String routeCreateVacancy = '/company/create-vacancy';
  static const String routeAnalytics = '/analytics';
  static const String routeVacancyDetails = '/vacancy-details';
  static const String routeMyApplications = '/my-applications';
  static const String routeStatistics = '/statistics';
  static const String routeProfile = '/profile';
  static const String routeEditProfile = '/edit-profile';
  static const String routeResume = '/resume';
  static const String routeNotifications = '/notifications';
  static const String routeSecurity = '/security';
  static const String routeSettings = '/settings';

  // Ограничения валидации
  static const int kMinPasswordLength = 6;
  static const int kMaxTitleLength = 100;
}
