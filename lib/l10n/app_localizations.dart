import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'EasyShift'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// No description provided for @appearanceSection.
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get appearanceSection;

  /// No description provided for @themeSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Тема оформления'**
  String get themeSectionTitle;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Темная'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @languageTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get languageTitle;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'ru Русский'**
  String get languageRussian;

  /// No description provided for @cityTitle.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get cityTitle;

  /// No description provided for @cityAlmaty.
  ///
  /// In ru, this message translates to:
  /// **'Алматы'**
  String get cityAlmaty;

  /// No description provided for @dataStorageSection.
  ///
  /// In ru, this message translates to:
  /// **'Данные и хранилище'**
  String get dataStorageSection;

  /// No description provided for @offlineModeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Офлайн-режим'**
  String get offlineModeTitle;

  /// No description provided for @offlineModeSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Сохранять данные для офлайн'**
  String get offlineModeSubtitle;

  /// No description provided for @autoUpdateTitle.
  ///
  /// In ru, this message translates to:
  /// **'Автообновление'**
  String get autoUpdateTitle;

  /// No description provided for @autoUpdateSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Обновлять данные автоматически'**
  String get autoUpdateSubtitle;

  /// No description provided for @appCacheTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кэш приложения'**
  String get appCacheTitle;

  /// No description provided for @appCacheSize.
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get appCacheSize;

  /// No description provided for @clearCacheButton.
  ///
  /// In ru, this message translates to:
  /// **'Очистить кэш'**
  String get clearCacheButton;

  /// No description provided for @aboutSection.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get aboutSection;

  /// No description provided for @appName.
  ///
  /// In ru, this message translates to:
  /// **'EasyShift'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия 1.0.0'**
  String get appVersion;

  /// No description provided for @termsOfService.
  ///
  /// In ru, this message translates to:
  /// **'Пользовательское соглашение'**
  String get termsOfService;

  /// No description provided for @bottomNavVacancies.
  ///
  /// In ru, this message translates to:
  /// **'Вакансии'**
  String get bottomNavVacancies;

  /// No description provided for @bottomNavApplications.
  ///
  /// In ru, this message translates to:
  /// **'Отклики'**
  String get bottomNavApplications;

  /// No description provided for @bottomNavStats.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get bottomNavStats;

  /// No description provided for @bottomNavProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get bottomNavProfile;

  /// No description provided for @commonCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get commonAdd;

  /// No description provided for @commonRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get commonRetry;

  /// No description provided for @errorWithMessage.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @authLogoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта?'**
  String get authLogoutTitle;

  /// No description provided for @authLogoutMessage.
  ///
  /// In ru, this message translates to:
  /// **'Сессия будет завершена. Чтобы снова открыть приложение под своим логином, потребуется войти.'**
  String get authLogoutMessage;

  /// No description provided for @authLogoutCancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get authLogoutCancel;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get authLogoutConfirm;

  /// No description provided for @loginPickRoleSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите, как вы хотите использовать приложение'**
  String get loginPickRoleSubtitle;

  /// No description provided for @loginWorkerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Соискатель'**
  String get loginWorkerTitle;

  /// No description provided for @loginWorkerSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Ищите работу и откликайтесь на вакансии'**
  String get loginWorkerSubtitle;

  /// No description provided for @loginWorkerTag1.
  ///
  /// In ru, this message translates to:
  /// **'Поиск вакансий'**
  String get loginWorkerTag1;

  /// No description provided for @loginWorkerTag2.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживание откликов'**
  String get loginWorkerTag2;

  /// No description provided for @loginCompanyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get loginCompanyTitle;

  /// No description provided for @loginCompanySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Размещайте вакансии и находите сотрудников'**
  String get loginCompanySubtitle;

  /// No description provided for @loginCompanyTag1.
  ///
  /// In ru, this message translates to:
  /// **'Создание вакансий'**
  String get loginCompanyTag1;

  /// No description provided for @loginCompanyTag2.
  ///
  /// In ru, this message translates to:
  /// **'Поиск кандидатов'**
  String get loginCompanyTag2;

  /// No description provided for @loginChangeRoleFooter.
  ///
  /// In ru, this message translates to:
  /// **'Вы всегда можете изменить роль в настройках'**
  String get loginChangeRoleFooter;

  /// No description provided for @loginContinue.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get loginContinue;

  /// No description provided for @loginScreenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход'**
  String get loginScreenTitle;

  /// No description provided for @loginCredentialsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход в EasyShift'**
  String get loginCredentialsTitle;

  /// No description provided for @loginCredentialsBody.
  ///
  /// In ru, this message translates to:
  /// **'Роль: {role}. При входе она сохранится в профиле — можно менять при каждом входе. Откроется экран для выбранного типа аккаунта.'**
  String loginCredentialsBody(Object role);

  /// No description provided for @loginChangeRole.
  ///
  /// In ru, this message translates to:
  /// **'Изменить роль'**
  String get loginChangeRole;

  /// No description provided for @loginPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginSubmit;

  /// No description provided for @loginGoogle.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Google'**
  String get loginGoogle;

  /// No description provided for @loginRegisterLink.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта? Регистрация'**
  String get loginRegisterLink;

  /// No description provided for @roleWorker.
  ///
  /// In ru, this message translates to:
  /// **'Соискатель'**
  String get roleWorker;

  /// No description provided for @roleCompany.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get roleCompany;

  /// No description provided for @homeOnlineTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get homeOnlineTooltip;

  /// No description provided for @homeOfflineTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Оффлайн'**
  String get homeOfflineTooltip;

  /// No description provided for @homeAccountTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get homeAccountTooltip;

  /// No description provided for @homeOfflineBanner.
  ///
  /// In ru, this message translates to:
  /// **'Оффлайн: нет интернета. Данные могут быть из кэша.'**
  String get homeOfflineBanner;

  /// No description provided for @homeSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск вакансий и компаний'**
  String get homeSearchHint;

  /// No description provided for @homeSortLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сортировка'**
  String get homeSortLabel;

  /// No description provided for @homeSortByDate.
  ///
  /// In ru, this message translates to:
  /// **'По дате'**
  String get homeSortByDate;

  /// No description provided for @homeSortByCity.
  ///
  /// In ru, this message translates to:
  /// **'По городу'**
  String get homeSortByCity;

  /// No description provided for @homeCityHeader.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get homeCityHeader;

  /// No description provided for @homeVacanciesNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Вакансии не найдены'**
  String get homeVacanciesNotFound;

  /// No description provided for @homeVacanciesError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки вакансий: {message}'**
  String homeVacanciesError(Object message);

  /// No description provided for @homeCompanyUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Компания не указана'**
  String get homeCompanyUnknown;

  /// No description provided for @homeSalaryNotSpecified.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата не указана'**
  String get homeSalaryNotSpecified;

  /// No description provided for @homeCityUnknown.
  ///
  /// In ru, this message translates to:
  /// **'Город не указан'**
  String get homeCityUnknown;

  /// No description provided for @homeScheduleUnknown.
  ///
  /// In ru, this message translates to:
  /// **'График не указан'**
  String get homeScheduleUnknown;

  /// No description provided for @homeHotVacancy.
  ///
  /// In ru, this message translates to:
  /// **'Горячая'**
  String get homeHotVacancy;

  /// No description provided for @homeFilterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get homeFilterAll;

  /// No description provided for @profileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// No description provided for @profileLoginPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Войдите в аккаунт, чтобы увидеть профиль.'**
  String get profileLoginPrompt;

  /// No description provided for @profileEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get profileEdit;

  /// No description provided for @profileSwitchCompany.
  ///
  /// In ru, this message translates to:
  /// **'Войти как компания'**
  String get profileSwitchCompany;

  /// No description provided for @profileLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get profileLogout;

  /// No description provided for @profileResume.
  ///
  /// In ru, this message translates to:
  /// **'Моё резюме'**
  String get profileResume;

  /// No description provided for @profileNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get profileNotifications;

  /// No description provided for @profileSecurity.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность'**
  String get profileSecurity;

  /// No description provided for @profileSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get profileSettings;

  /// No description provided for @profileHelp.
  ///
  /// In ru, this message translates to:
  /// **'Помощь'**
  String get profileHelp;

  /// No description provided for @profileResumeBadge.
  ///
  /// In ru, this message translates to:
  /// **'Заполнено'**
  String get profileResumeBadge;

  /// No description provided for @profileNotificationsBadge.
  ///
  /// In ru, this message translates to:
  /// **'3'**
  String get profileNotificationsBadge;

  /// No description provided for @profileActivityTitle.
  ///
  /// In ru, this message translates to:
  /// **'Активность'**
  String get profileActivityTitle;

  /// No description provided for @profileActivityHint.
  ///
  /// In ru, this message translates to:
  /// **'Заходите в раздел «Профиль» каждый день — мы считаем дни подряд.'**
  String get profileActivityHint;

  /// No description provided for @profileActivityStreakLabel.
  ///
  /// In ru, this message translates to:
  /// **'Серия дней'**
  String get profileActivityStreakLabel;

  /// No description provided for @profileActivityLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось обновить: {error}'**
  String profileActivityLoadError(Object error);

  /// No description provided for @profileStreakDays.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дней}}'**
  String profileStreakDays(int count);

  /// No description provided for @securityTitle.
  ///
  /// In ru, this message translates to:
  /// **'Безопасность'**
  String get securityTitle;

  /// No description provided for @securityAccountLocal.
  ///
  /// In ru, this message translates to:
  /// **'Локальный режим: пароль хранится только на устройстве.'**
  String get securityAccountLocal;

  /// No description provided for @securityAccountEmailPassword.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт с email и паролем. Можно сменить пароль ниже.'**
  String get securityAccountEmailPassword;

  /// No description provided for @securityAccountGoogle.
  ///
  /// In ru, this message translates to:
  /// **'Вход через Google. Пароль приложения не используется — управление доступом в Google-аккаунте.'**
  String get securityAccountGoogle;

  /// No description provided for @securityPasswordHint.
  ///
  /// In ru, this message translates to:
  /// **'Для смены укажите текущий пароль и новый (не короче {min} символов).'**
  String securityPasswordHint(Object min);

  /// No description provided for @securityChangePassword.
  ///
  /// In ru, this message translates to:
  /// **'Сменить пароль'**
  String get securityChangePassword;

  /// No description provided for @securityResetEmail.
  ///
  /// In ru, this message translates to:
  /// **'Письмо для сброса пароля на email'**
  String get securityResetEmail;

  /// No description provided for @securityEmailProfileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Email и имя'**
  String get securityEmailProfileTitle;

  /// No description provided for @securityEmailProfileSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование профиля и смена email (с подтверждением).'**
  String get securityEmailProfileSubtitle;

  /// No description provided for @security2faTitle.
  ///
  /// In ru, this message translates to:
  /// **'Двухфакторная аутентификация'**
  String get security2faTitle;

  /// No description provided for @security2faSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Пока недоступно. Позже подключим SMS или приложение-аутентификатор.'**
  String get security2faSubtitle;

  /// No description provided for @securityBiometricsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Биометрия'**
  String get securityBiometricsTitle;

  /// No description provided for @securityBiometricsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход по отпечатку или Face ID — в планах.'**
  String get securityBiometricsSubtitle;

  /// No description provided for @securitySoonChip.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get securitySoonChip;

  /// No description provided for @securitySessionsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сеансы'**
  String get securitySessionsTitle;

  /// No description provided for @securitySessionsBody.
  ///
  /// In ru, this message translates to:
  /// **'Список устройств в приложении недоступен: Firebase не отдаёт активные сеансы в клиенте. Вы можете выйти из аккаунта на этом устройстве.'**
  String get securitySessionsBody;

  /// No description provided for @securitySessionsLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get securitySessionsLogout;

  /// No description provided for @securityNewPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get securityNewPasswordTitle;

  /// No description provided for @securityPasswordUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Пароль обновлён'**
  String get securityPasswordUpdated;

  /// No description provided for @securityNoEmailForReset.
  ///
  /// In ru, this message translates to:
  /// **'Нет email для сброса'**
  String get securityNoEmailForReset;

  /// No description provided for @securityResetEmailSent.
  ///
  /// In ru, this message translates to:
  /// **'Письмо со ссылкой отправлено на ваш email'**
  String get securityResetEmailSent;

  /// No description provided for @vacancyDetailsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Детали вакансии'**
  String get vacancyDetailsTitle;

  /// No description provided for @vacancyNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Вакансия не найдена'**
  String get vacancyNotFound;

  /// No description provided for @vacancyDescriptionHeading.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get vacancyDescriptionHeading;

  /// No description provided for @vacancyNoDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание пока не добавлено'**
  String get vacancyNoDescription;

  /// No description provided for @vacancyNoCategory.
  ///
  /// In ru, this message translates to:
  /// **'Без категории'**
  String get vacancyNoCategory;

  /// No description provided for @vacancyApply.
  ///
  /// In ru, this message translates to:
  /// **'Откликнуться'**
  String get vacancyApply;

  /// No description provided for @vacancyBack.
  ///
  /// In ru, this message translates to:
  /// **'Назад к списку'**
  String get vacancyBack;

  /// No description provided for @vacancyNeedLogin.
  ///
  /// In ru, this message translates to:
  /// **'Нужно войти в аккаунт'**
  String get vacancyNeedLogin;

  /// No description provided for @vacancyWorkerOnly.
  ///
  /// In ru, this message translates to:
  /// **'Отклик доступен только соискателю'**
  String get vacancyWorkerOnly;

  /// No description provided for @vacancyUidMissing.
  ///
  /// In ru, this message translates to:
  /// **'UID пользователя не найден'**
  String get vacancyUidMissing;

  /// No description provided for @vacancyApplySent.
  ///
  /// In ru, this message translates to:
  /// **'Отклик отправлен'**
  String get vacancyApplySent;

  /// No description provided for @editProfileSaved.
  ///
  /// In ru, this message translates to:
  /// **'Профиль сохранён'**
  String get editProfileSaved;

  /// No description provided for @editProfileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get editProfileTitle;

  /// No description provided for @editProfileSave.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get editProfileSave;

  /// No description provided for @editProfileSaving.
  ///
  /// In ru, this message translates to:
  /// **'Сохранение…'**
  String get editProfileSaving;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'При смене email Firebase может отправить письмо подтверждения на новый адрес; вход по старому email действует до завершения подтверждения.'**
  String get editProfileEmailHint;

  /// No description provided for @settingsCityNotSelected.
  ///
  /// In ru, this message translates to:
  /// **'Не выбран'**
  String get settingsCityNotSelected;

  /// No description provided for @settingsCityAllCitiesHint.
  ///
  /// In ru, this message translates to:
  /// **'На главной — фильтр «Все города»'**
  String get settingsCityAllCitiesHint;

  /// No description provided for @settingsClearCacheConfirmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Очистить кэш'**
  String get settingsClearCacheConfirmTitle;

  /// No description provided for @settingsClearCacheConfirmBody.
  ///
  /// In ru, this message translates to:
  /// **'Будут удалены временные файлы, кэш изображений и локальные данные (кроме сессии входа): черновики в настройках, серия «Активность», локальное резюме в офлайн-режиме и т.п.'**
  String get settingsClearCacheConfirmBody;

  /// No description provided for @settingsClearCacheAction.
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get settingsClearCacheAction;

  /// No description provided for @settingsClearingCache.
  ///
  /// In ru, this message translates to:
  /// **'Очистка…'**
  String get settingsClearingCache;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In ru, this message translates to:
  /// **'Кэш очищено (~{size})'**
  String settingsCacheCleared(Object size);

  /// No description provided for @registerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registerTitle;

  /// No description provided for @registerHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? Войти'**
  String get registerHaveAccount;

  /// No description provided for @registerHeadline.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get registerHeadline;

  /// No description provided for @registerSubtitleWorker.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация как соискатель. Фото или логотип можно добавить позже в профиле.'**
  String get registerSubtitleWorker;

  /// No description provided for @registerSubtitleCompany.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация как компания. Фото или логотип можно добавить позже в профиле.'**
  String get registerSubtitleCompany;

  /// No description provided for @registerNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Как к вам обращаться'**
  String get registerNameHint;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение пароля'**
  String get registerConfirmPassword;

  /// No description provided for @registerSubmit.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get registerSubmit;

  /// No description provided for @editProfilePrimarySection.
  ///
  /// In ru, this message translates to:
  /// **'Основное'**
  String get editProfilePrimarySection;

  /// No description provided for @editProfileNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get editProfileNameLabel;

  /// No description provided for @fieldEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @homeSalaryRangeFormatted.
  ///
  /// In ru, this message translates to:
  /// **'{from} — {to} {currency}'**
  String homeSalaryRangeFormatted(Object from, Object to, Object currency);

  /// No description provided for @homeSalaryFromFormatted.
  ///
  /// In ru, this message translates to:
  /// **'от {from} {currency}'**
  String homeSalaryFromFormatted(Object from, Object currency);

  /// No description provided for @homeCurrencyTenge.
  ///
  /// In ru, this message translates to:
  /// **'тг'**
  String get homeCurrencyTenge;

  /// No description provided for @profileLabelWorkerShort.
  ///
  /// In ru, this message translates to:
  /// **'соискатель'**
  String get profileLabelWorkerShort;

  /// No description provided for @profileLabelCompanyShort.
  ///
  /// In ru, this message translates to:
  /// **'компания'**
  String get profileLabelCompanyShort;

  /// No description provided for @profileSummaryNotFilled.
  ///
  /// In ru, this message translates to:
  /// **'Профили не оформлены'**
  String get profileSummaryNotFilled;

  /// No description provided for @profileSummaryWorkerOnly.
  ///
  /// In ru, this message translates to:
  /// **'Соискатель'**
  String get profileSummaryWorkerOnly;

  /// No description provided for @profileSummaryCompanyOnly.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get profileSummaryCompanyOnly;

  /// No description provided for @profileSummaryDual.
  ///
  /// In ru, this message translates to:
  /// **'Профили: {worker} · {company} · сейчас: {active}'**
  String profileSummaryDual(Object worker, Object company, Object active);

  /// No description provided for @securityAccountSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get securityAccountSectionTitle;

  /// No description provided for @securityPasswordSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get securityPasswordSectionTitle;

  /// No description provided for @securityCurrentPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пароль'**
  String get securityCurrentPasswordLabel;

  /// No description provided for @securityNewPasswordFieldLabel.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get securityNewPasswordFieldLabel;

  /// No description provided for @securityConfirmNewPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Повторите новый пароль'**
  String get securityConfirmNewPasswordLabel;

  /// No description provided for @securityNewPasswordHelper.
  ///
  /// In ru, this message translates to:
  /// **'Не короче {min} символов'**
  String securityNewPasswordHelper(Object min);

  /// No description provided for @securityValidatorCurrentPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите текущий пароль'**
  String get securityValidatorCurrentPassword;

  /// No description provided for @securityValidatorNewPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите новый пароль'**
  String get securityValidatorNewPassword;

  /// No description provided for @securityValidatorPasswordTooShort.
  ///
  /// In ru, this message translates to:
  /// **'Слишком короткий пароль'**
  String get securityValidatorPasswordTooShort;

  /// No description provided for @securityValidatorPasswordsMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get securityValidatorPasswordsMismatch;

  /// No description provided for @resumeSkillDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Навык'**
  String get resumeSkillDialogTitle;

  /// No description provided for @resumeSaved.
  ///
  /// In ru, this message translates to:
  /// **'Резюме сохранено'**
  String get resumeSaved;

  /// No description provided for @resumeShowToCompanies.
  ///
  /// In ru, this message translates to:
  /// **'Показывать резюме компаниям'**
  String get resumeShowToCompanies;

  /// No description provided for @resumeNotSpecified.
  ///
  /// In ru, this message translates to:
  /// **'Не указан'**
  String get resumeNotSpecified;

  /// No description provided for @resumeSectionAbout.
  ///
  /// In ru, this message translates to:
  /// **'О себе'**
  String get resumeSectionAbout;

  /// No description provided for @resumeSectionSkills.
  ///
  /// In ru, this message translates to:
  /// **'Навыки'**
  String get resumeSectionSkills;

  /// No description provided for @resumeLineCity.
  ///
  /// In ru, this message translates to:
  /// **'Город: {city}'**
  String resumeLineCity(Object city);

  /// No description provided for @resumeLinePhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон: {phone}'**
  String resumeLinePhone(Object phone);

  /// No description provided for @resumeLineEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email: {email}'**
  String resumeLineEmail(Object email);

  /// No description provided for @createVacancyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая вакансия'**
  String get createVacancyTitle;

  /// No description provided for @createVacancyCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get createVacancyCategory;

  /// No description provided for @createVacancyOpenings.
  ///
  /// In ru, this message translates to:
  /// **'Количество мест'**
  String get createVacancyOpenings;

  /// No description provided for @createVacancyFillRequired.
  ///
  /// In ru, this message translates to:
  /// **'Заполните название, категорию и город'**
  String get createVacancyFillRequired;

  /// No description provided for @createVacancySubmitted.
  ///
  /// In ru, this message translates to:
  /// **'Вакансия отправлена на публикацию'**
  String get createVacancySubmitted;

  /// No description provided for @routerNoAccess.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа'**
  String get routerNoAccess;

  /// No description provided for @routerInvalidVacancyId.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный идентификатор вакансии'**
  String get routerInvalidVacancyId;

  /// No description provided for @analyticsWorkerOnly.
  ///
  /// In ru, this message translates to:
  /// **'Статистика доступна соискателю'**
  String get analyticsWorkerOnly;

  /// No description provided for @companyCandidatesAllStages.
  ///
  /// In ru, this message translates to:
  /// **'Все стадии'**
  String get companyCandidatesAllStages;

  /// No description provided for @companySectionCompanyOnly.
  ///
  /// In ru, this message translates to:
  /// **'Раздел доступен компании'**
  String get companySectionCompanyOnly;

  /// No description provided for @companyFilter.
  ///
  /// In ru, this message translates to:
  /// **'Фильтр'**
  String get companyFilter;

  /// No description provided for @companyCandidateNoResume.
  ///
  /// In ru, this message translates to:
  /// **'У кандидата нет привязанного резюме'**
  String get companyCandidateNoResume;

  /// No description provided for @companyResumeNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Резюме не найдено'**
  String get companyResumeNotFound;

  /// No description provided for @companyResumeViewerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Резюме кандидата'**
  String get companyResumeViewerTitle;

  /// No description provided for @companyResumePreviewExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Это сохранённое резюме соискателя. Пустые разделы он в анкете не заполнил.'**
  String get companyResumePreviewExplanation;

  /// No description provided for @companyOpenResumeError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось открыть резюме: {message}'**
  String companyOpenResumeError(Object message);

  /// No description provided for @companyStatisticsCompanyOnly.
  ///
  /// In ru, this message translates to:
  /// **'Статистика доступна компании'**
  String get companyStatisticsCompanyOnly;

  /// No description provided for @companyStatisticsVacanciesError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка статистики: {message}'**
  String companyStatisticsVacanciesError(Object message);

  /// No description provided for @companyStatisticsApplicationsError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка откликов: {message}'**
  String companyStatisticsApplicationsError(Object message);

  /// No description provided for @companyVacanciesViewApplications.
  ///
  /// In ru, this message translates to:
  /// **'Смотреть отклики ({count})'**
  String companyVacanciesViewApplications(Object count);

  /// No description provided for @companyHomeEditProfileSoon.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование профиля — скоро'**
  String get companyHomeEditProfileSoon;

  /// No description provided for @companyHomeCreateVacancy.
  ///
  /// In ru, this message translates to:
  /// **'+ Создать'**
  String get companyHomeCreateVacancy;

  /// No description provided for @myApplicationsEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать отклик'**
  String get myApplicationsEditTitle;

  /// No description provided for @myApplicationsWorkerOnly.
  ///
  /// In ru, this message translates to:
  /// **'Отклики доступны в режиме соискателя'**
  String get myApplicationsWorkerOnly;

  /// No description provided for @myApplicationsChange.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get myApplicationsChange;

  /// No description provided for @myApplicationsDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get myApplicationsDelete;

  /// No description provided for @companyFeatureSoon.
  ///
  /// In ru, this message translates to:
  /// **'{feature} — скоро'**
  String companyFeatureSoon(Object feature);

  /// No description provided for @companyProfileError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка профиля: {message}'**
  String companyProfileError(Object message);

  /// No description provided for @companyProfileNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Профиль компании не найден'**
  String get companyProfileNotFound;

  /// No description provided for @companySwitchToWorker.
  ///
  /// In ru, this message translates to:
  /// **'Войти как соискатель'**
  String get companySwitchToWorker;

  /// No description provided for @resumeSkillHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: Курьер'**
  String get resumeSkillHint;

  /// No description provided for @resumeWorkExperienceNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Опыт работы'**
  String get resumeWorkExperienceNewTitle;

  /// No description provided for @resumeWorkExperienceEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать опыт'**
  String get resumeWorkExperienceEditTitle;

  /// No description provided for @resumeFieldPosition.
  ///
  /// In ru, this message translates to:
  /// **'Должность'**
  String get resumeFieldPosition;

  /// No description provided for @resumeFieldCompany.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get resumeFieldCompany;

  /// No description provided for @resumePeriodFrom.
  ///
  /// In ru, this message translates to:
  /// **'Период с'**
  String get resumePeriodFrom;

  /// No description provided for @resumePeriodFromHint.
  ///
  /// In ru, this message translates to:
  /// **'Март 2025'**
  String get resumePeriodFromHint;

  /// No description provided for @resumePeriodTo.
  ///
  /// In ru, this message translates to:
  /// **'Период по (пусто — по наст. время)'**
  String get resumePeriodTo;

  /// No description provided for @resumePeriodEmptyHint.
  ///
  /// In ru, this message translates to:
  /// **'Оставьте пустым'**
  String get resumePeriodEmptyHint;

  /// No description provided for @resumeFieldDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get resumeFieldDescription;

  /// No description provided for @resumeLanguageNewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get resumeLanguageNewTitle;

  /// No description provided for @resumeLanguageEditTitle.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать язык'**
  String get resumeLanguageEditTitle;

  /// No description provided for @resumeFieldLanguageName.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get resumeFieldLanguageName;

  /// No description provided for @resumeLanguageLevelLabel.
  ///
  /// In ru, this message translates to:
  /// **'Уровень'**
  String get resumeLanguageLevelLabel;

  /// No description provided for @resumePresentTime.
  ///
  /// In ru, this message translates to:
  /// **'Настоящее время'**
  String get resumePresentTime;

  /// No description provided for @resumeLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить резюме'**
  String get resumeLoadFailed;

  /// No description provided for @resumeScreenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Моё резюме'**
  String get resumeScreenTitle;

  /// No description provided for @resumeAboutHint.
  ///
  /// In ru, this message translates to:
  /// **'Расскажите о себе…'**
  String get resumeAboutHint;

  /// No description provided for @resumeFieldCity.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get resumeFieldCity;

  /// No description provided for @resumeCityNotSpecified.
  ///
  /// In ru, this message translates to:
  /// **'Не указан'**
  String get resumeCityNotSpecified;

  /// No description provided for @resumeVisibilitySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Если выключено, кабинет компании не увидит ваше резюме в общей ленте.'**
  String get resumeVisibilitySubtitle;

  /// No description provided for @resumeEditTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get resumeEditTooltip;

  /// No description provided for @resumeDeleteTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get resumeDeleteTooltip;

  /// No description provided for @resumeHeadlineFieldHint.
  ///
  /// In ru, this message translates to:
  /// **'Соискатель'**
  String get resumeHeadlineFieldHint;

  /// No description provided for @resumeSectionWorkExperience.
  ///
  /// In ru, this message translates to:
  /// **'Опыт работы'**
  String get resumeSectionWorkExperience;

  /// No description provided for @resumeSectionLanguages.
  ///
  /// In ru, this message translates to:
  /// **'Языки'**
  String get resumeSectionLanguages;

  /// No description provided for @resumeSectionVisibility.
  ///
  /// In ru, this message translates to:
  /// **'Видимость'**
  String get resumeSectionVisibility;

  /// No description provided for @resumeSectionPersonal.
  ///
  /// In ru, this message translates to:
  /// **'Личные данные'**
  String get resumeSectionPersonal;

  /// No description provided for @resumeFieldFullName.
  ///
  /// In ru, this message translates to:
  /// **'ФИО'**
  String get resumeFieldFullName;

  /// No description provided for @resumeFieldPhone.
  ///
  /// In ru, this message translates to:
  /// **'Телефон'**
  String get resumeFieldPhone;

  /// No description provided for @resumeFieldBirthDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата рождения'**
  String get resumeFieldBirthDate;

  /// No description provided for @resumeFieldBirthDateHint.
  ///
  /// In ru, this message translates to:
  /// **'15.05.1998'**
  String get resumeFieldBirthDateHint;

  /// No description provided for @resumeFieldDesiredPosition.
  ///
  /// In ru, this message translates to:
  /// **'Желаемая позиция'**
  String get resumeFieldDesiredPosition;

  /// No description provided for @myApplicationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои отклики'**
  String get myApplicationsTitle;

  /// No description provided for @myApplicationsCount.
  ///
  /// In ru, this message translates to:
  /// **'{count} заявок'**
  String myApplicationsCount(Object count);

  /// No description provided for @myApplicationsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет откликов'**
  String get myApplicationsEmpty;

  /// No description provided for @myApplicationsUntitledVacancy.
  ///
  /// In ru, this message translates to:
  /// **'Без названия вакансии'**
  String get myApplicationsUntitledVacancy;

  /// No description provided for @myApplicationsStatusLabel.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get myApplicationsStatusLabel;

  /// No description provided for @myApplicationsNoteLabel.
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get myApplicationsNoteLabel;

  /// No description provided for @createVacancyStepIntro.
  ///
  /// In ru, this message translates to:
  /// **'Укажите название и категорию вакансии'**
  String get createVacancyStepIntro;

  /// No description provided for @createVacancyTitleLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название вакансии'**
  String get createVacancyTitleLabel;

  /// No description provided for @createVacancyTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: Курьер на вечерние смены'**
  String get createVacancyTitleHint;

  /// No description provided for @createVacancySalaryFromLabel.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата от (тг)'**
  String get createVacancySalaryFromLabel;

  /// No description provided for @createVacancySalaryToLabel.
  ///
  /// In ru, this message translates to:
  /// **'Зарплата до (тг)'**
  String get createVacancySalaryToLabel;

  /// No description provided for @createVacancyScheduleLabel.
  ///
  /// In ru, this message translates to:
  /// **'График'**
  String get createVacancyScheduleLabel;

  /// No description provided for @createVacancyCitySectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Город'**
  String get createVacancyCitySectionTitle;

  /// No description provided for @createVacancyCityFieldLabel.
  ///
  /// In ru, this message translates to:
  /// **'Город вакансии'**
  String get createVacancyCityFieldLabel;

  /// No description provided for @createVacancyCityHint.
  ///
  /// In ru, this message translates to:
  /// **'Выберите город'**
  String get createVacancyCityHint;

  /// No description provided for @createVacancyDescriptionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get createVacancyDescriptionLabel;

  /// No description provided for @createVacancySubmitButton.
  ///
  /// In ru, this message translates to:
  /// **'Создать вакансию'**
  String get createVacancySubmitButton;

  /// No description provided for @createVacancySubmitting.
  ///
  /// In ru, this message translates to:
  /// **'Сохранение...'**
  String get createVacancySubmitting;

  /// No description provided for @createVacancyOpeningsSuffix.
  ///
  /// In ru, this message translates to:
  /// **'Количество мест: {slots}'**
  String createVacancyOpeningsSuffix(Object slots);

  /// No description provided for @companyDefaultName.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get companyDefaultName;

  /// No description provided for @myApplicationsUpdatedPrefix.
  ///
  /// In ru, this message translates to:
  /// **'Обновлено:'**
  String get myApplicationsUpdatedPrefix;

  /// No description provided for @companyShellVacanciesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои вакансии'**
  String get companyShellVacanciesTitle;

  /// No description provided for @companyShellCandidatesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Все кандидаты'**
  String get companyShellCandidatesTitle;

  /// No description provided for @companyShellStatisticsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get companyShellStatisticsTitle;

  /// No description provided for @companyShellProfileTitle.
  ///
  /// In ru, this message translates to:
  /// **'Профиль компании'**
  String get companyShellProfileTitle;

  /// No description provided for @companyEditProfileTooltip.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get companyEditProfileTooltip;

  /// No description provided for @companyMenuEditProfile.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get companyMenuEditProfile;

  /// No description provided for @companyMenuTeam.
  ///
  /// In ru, this message translates to:
  /// **'Команда'**
  String get companyMenuTeam;

  /// No description provided for @companyMenuHelp.
  ///
  /// In ru, this message translates to:
  /// **'Помощь'**
  String get companyMenuHelp;

  /// No description provided for @companyNavVacancies.
  ///
  /// In ru, this message translates to:
  /// **'Вакансии'**
  String get companyNavVacancies;

  /// No description provided for @companyNavCandidates.
  ///
  /// In ru, this message translates to:
  /// **'Кандидаты'**
  String get companyNavCandidates;

  /// No description provided for @companyNavStatistics.
  ///
  /// In ru, this message translates to:
  /// **'Статистика'**
  String get companyNavStatistics;

  /// No description provided for @companyNavCompany.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get companyNavCompany;

  /// No description provided for @companyVacancyFilterActive.
  ///
  /// In ru, this message translates to:
  /// **'Активные'**
  String get companyVacancyFilterActive;

  /// No description provided for @companyVacancyFilterPaused.
  ///
  /// In ru, this message translates to:
  /// **'На паузе'**
  String get companyVacancyFilterPaused;

  /// No description provided for @companyVacanciesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск вакансий…'**
  String get companyVacanciesSearchHint;

  /// No description provided for @companyVacanciesEmptyFilter.
  ///
  /// In ru, this message translates to:
  /// **'Нет вакансий по фильтру'**
  String get companyVacanciesEmptyFilter;

  /// No description provided for @companyVacanciesActiveSummary.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} активная вакансия} few{{count} активные вакансии} many{{count} активных вакансий} other{{count} активных вакансий}}'**
  String companyVacanciesActiveSummary(int count);

  /// No description provided for @companyApplicationsShort.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} отклик} few{{count} отклика} many{{count} откликов} other{{count} откликов}}'**
  String companyApplicationsShort(int count);

  /// No description provided for @companyVacancyCardStatusActive.
  ///
  /// In ru, this message translates to:
  /// **'Активна'**
  String get companyVacancyCardStatusActive;

  /// No description provided for @companyVacancyCardStatusPaused.
  ///
  /// In ru, this message translates to:
  /// **'На паузе'**
  String get companyVacancyCardStatusPaused;

  /// No description provided for @companyStatisticsFirestoreHint.
  ///
  /// In ru, this message translates to:
  /// **'Аналитика по реальным данным Firestore'**
  String get companyStatisticsFirestoreHint;

  /// No description provided for @companyCandidatesSearchHint.
  ///
  /// In ru, this message translates to:
  /// **'Поиск кандидатов…'**
  String get companyCandidatesSearchHint;

  /// No description provided for @companyCandidatesStatTotal.
  ///
  /// In ru, this message translates to:
  /// **'Всего откликов'**
  String get companyCandidatesStatTotal;

  /// No description provided for @companyCandidatesStatNew.
  ///
  /// In ru, this message translates to:
  /// **'Новых'**
  String get companyCandidatesStatNew;

  /// No description provided for @companyCandidatesEmptyQuery.
  ///
  /// In ru, this message translates to:
  /// **'Нет кандидатов по запросу'**
  String get companyCandidatesEmptyQuery;

  /// No description provided for @resumePreviewNoName.
  ///
  /// In ru, this message translates to:
  /// **'Без имени'**
  String get resumePreviewNoName;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
