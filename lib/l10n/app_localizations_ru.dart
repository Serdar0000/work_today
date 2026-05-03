// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'EasyShift';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get appearanceSection => 'Внешний вид';

  @override
  String get themeSectionTitle => 'Тема оформления';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageRussian => 'ru Русский';

  @override
  String get cityTitle => 'Город';

  @override
  String get cityAlmaty => 'Алматы';

  @override
  String get dataStorageSection => 'Данные и хранилище';

  @override
  String get offlineModeTitle => 'Офлайн-режим';

  @override
  String get offlineModeSubtitle => 'Сохранять данные для офлайн';

  @override
  String get autoUpdateTitle => 'Автообновление';

  @override
  String get autoUpdateSubtitle => 'Обновлять данные автоматически';

  @override
  String get appCacheTitle => 'Кэш приложения';

  @override
  String get appCacheSize => '—';

  @override
  String get clearCacheButton => 'Очистить кэш';

  @override
  String get aboutSection => 'О приложении';

  @override
  String get appName => 'EasyShift';

  @override
  String get appVersion => 'Версия 1.0.0';

  @override
  String get termsOfService => 'Пользовательское соглашение';

  @override
  String get bottomNavVacancies => 'Вакансии';

  @override
  String get bottomNavApplications => 'Отклики';

  @override
  String get bottomNavStats => 'Статистика';

  @override
  String get bottomNavProfile => 'Профиль';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonRetry => 'Повторить';

  @override
  String errorWithMessage(Object message) {
    return 'Ошибка: $message';
  }

  @override
  String get authLogoutTitle => 'Выйти из аккаунта?';

  @override
  String get authLogoutMessage =>
      'Сессия будет завершена. Чтобы снова открыть приложение под своим логином, потребуется войти.';

  @override
  String get authLogoutCancel => 'Отмена';

  @override
  String get authLogoutConfirm => 'Выйти';

  @override
  String get loginPickRoleSubtitle =>
      'Выберите, как вы хотите использовать приложение';

  @override
  String get loginWorkerTitle => 'Соискатель';

  @override
  String get loginWorkerSubtitle => 'Ищите работу и откликайтесь на вакансии';

  @override
  String get loginWorkerTag1 => 'Поиск вакансий';

  @override
  String get loginWorkerTag2 => 'Отслеживание откликов';

  @override
  String get loginCompanyTitle => 'Компания';

  @override
  String get loginCompanySubtitle =>
      'Размещайте вакансии и находите сотрудников';

  @override
  String get loginCompanyTag1 => 'Создание вакансий';

  @override
  String get loginCompanyTag2 => 'Поиск кандидатов';

  @override
  String get loginChangeRoleFooter =>
      'Вы всегда можете изменить роль в настройках';

  @override
  String get loginContinue => 'Продолжить';

  @override
  String get loginScreenTitle => 'Вход';

  @override
  String get loginCredentialsTitle => 'Вход в EasyShift';

  @override
  String loginCredentialsBody(Object role) {
    return 'Роль: $role. При входе она сохранится в профиле — можно менять при каждом входе. Откроется экран для выбранного типа аккаунта.';
  }

  @override
  String get loginChangeRole => 'Изменить роль';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginGoogle => 'Войти через Google';

  @override
  String get loginRegisterLink => 'Нет аккаунта? Регистрация';

  @override
  String get roleWorker => 'Соискатель';

  @override
  String get roleCompany => 'Компания';

  @override
  String get homeOnlineTooltip => 'Онлайн';

  @override
  String get homeOfflineTooltip => 'Оффлайн';

  @override
  String get homeAccountTooltip => 'Аккаунт';

  @override
  String get homeOfflineBanner =>
      'Оффлайн: нет интернета. Данные могут быть из кэша.';

  @override
  String get homeSearchHint => 'Поиск вакансий и компаний';

  @override
  String get homeSortLabel => 'Сортировка';

  @override
  String get homeSortByDate => 'По дате';

  @override
  String get homeSortByCity => 'По городу';

  @override
  String get homeCityHeader => 'Город';

  @override
  String get homeVacanciesNotFound => 'Вакансии не найдены';

  @override
  String homeVacanciesError(Object message) {
    return 'Ошибка загрузки вакансий: $message';
  }

  @override
  String get homeCompanyUnknown => 'Компания не указана';

  @override
  String get homeSalaryNotSpecified => 'Зарплата не указана';

  @override
  String get homeCityUnknown => 'Город не указан';

  @override
  String get homeScheduleUnknown => 'График не указан';

  @override
  String get homeHotVacancy => 'Горячая';

  @override
  String get homeFilterAll => 'Все';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileLoginPrompt => 'Войдите в аккаунт, чтобы увидеть профиль.';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileSwitchCompany => 'Войти как компания';

  @override
  String get profileLogout => 'Выйти из аккаунта';

  @override
  String get profileResume => 'Моё резюме';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileSecurity => 'Безопасность';

  @override
  String get profileSettings => 'Настройки';

  @override
  String get profileHelp => 'Помощь';

  @override
  String get profileResumeBadge => 'Заполнено';

  @override
  String get profileNotificationsBadge => '3';

  @override
  String get profileActivityTitle => 'Активность';

  @override
  String get profileActivityHint =>
      'Заходите в раздел «Профиль» каждый день — мы считаем дни подряд.';

  @override
  String get profileActivityStreakLabel => 'Серия дней';

  @override
  String profileActivityLoadError(Object error) {
    return 'Не удалось обновить: $error';
  }

  @override
  String profileStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String get securityTitle => 'Безопасность';

  @override
  String get securityAccountLocal =>
      'Локальный режим: пароль хранится только на устройстве.';

  @override
  String get securityAccountEmailPassword =>
      'Аккаунт с email и паролем. Можно сменить пароль ниже.';

  @override
  String get securityAccountGoogle =>
      'Вход через Google. Пароль приложения не используется — управление доступом в Google-аккаунте.';

  @override
  String securityPasswordHint(Object min) {
    return 'Для смены укажите текущий пароль и новый (не короче $min символов).';
  }

  @override
  String get securityChangePassword => 'Сменить пароль';

  @override
  String get securityResetEmail => 'Письмо для сброса пароля на email';

  @override
  String get securityEmailProfileTitle => 'Email и имя';

  @override
  String get securityEmailProfileSubtitle =>
      'Редактирование профиля и смена email (с подтверждением).';

  @override
  String get security2faTitle => 'Двухфакторная аутентификация';

  @override
  String get security2faSubtitle =>
      'Пока недоступно. Позже подключим SMS или приложение-аутентификатор.';

  @override
  String get securityBiometricsTitle => 'Биометрия';

  @override
  String get securityBiometricsSubtitle =>
      'Вход по отпечатку или Face ID — в планах.';

  @override
  String get securitySoonChip => 'Скоро';

  @override
  String get securitySessionsTitle => 'Сеансы';

  @override
  String get securitySessionsBody =>
      'Список устройств в приложении недоступен: Firebase не отдаёт активные сеансы в клиенте. Вы можете выйти из аккаунта на этом устройстве.';

  @override
  String get securitySessionsLogout => 'Выйти из аккаунта';

  @override
  String get securityNewPasswordTitle => 'Новый пароль';

  @override
  String get securityPasswordUpdated => 'Пароль обновлён';

  @override
  String get securityNoEmailForReset => 'Нет email для сброса';

  @override
  String get securityResetEmailSent =>
      'Письмо со ссылкой отправлено на ваш email';

  @override
  String get vacancyDetailsTitle => 'Детали вакансии';

  @override
  String get vacancyNotFound => 'Вакансия не найдена';

  @override
  String get vacancyDescriptionHeading => 'Описание';

  @override
  String get vacancyNoDescription => 'Описание пока не добавлено';

  @override
  String get vacancyNoCategory => 'Без категории';

  @override
  String get vacancyApply => 'Откликнуться';

  @override
  String get vacancyBack => 'Назад к списку';

  @override
  String get vacancyNeedLogin => 'Нужно войти в аккаунт';

  @override
  String get vacancyWorkerOnly => 'Отклик доступен только соискателю';

  @override
  String get vacancyUidMissing => 'UID пользователя не найден';

  @override
  String get vacancyApplySent => 'Отклик отправлен';

  @override
  String get editProfileSaved => 'Профиль сохранён';

  @override
  String get editProfileTitle => 'Редактировать профиль';

  @override
  String get editProfileSave => 'Сохранить';

  @override
  String get editProfileSaving => 'Сохранение…';

  @override
  String get editProfileEmailHint =>
      'При смене email Firebase может отправить письмо подтверждения на новый адрес; вход по старому email действует до завершения подтверждения.';

  @override
  String get settingsCityNotSelected => 'Не выбран';

  @override
  String get settingsCityAllCitiesHint => 'На главной — фильтр «Все города»';

  @override
  String get settingsClearCacheConfirmTitle => 'Очистить кэш';

  @override
  String get settingsClearCacheConfirmBody =>
      'Будут удалены временные файлы, кэш изображений и локальные данные (кроме сессии входа): черновики в настройках, серия «Активность», локальное резюме в офлайн-режиме и т.п.';

  @override
  String get settingsClearCacheAction => 'Очистить';

  @override
  String get settingsClearingCache => 'Очистка…';

  @override
  String settingsCacheCleared(Object size) {
    return 'Кэш очищено (~$size)';
  }

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get registerHeadline => 'Создать аккаунт';

  @override
  String get registerSubtitleWorker =>
      'Регистрация как соискатель. Фото или логотип можно добавить позже в профиле.';

  @override
  String get registerSubtitleCompany =>
      'Регистрация как компания. Фото или логотип можно добавить позже в профиле.';

  @override
  String get registerNameLabel => 'Имя';

  @override
  String get registerNameHint => 'Как к вам обращаться';

  @override
  String get registerConfirmPassword => 'Подтверждение пароля';

  @override
  String get registerSubmit => 'Создать аккаунт';

  @override
  String get editProfilePrimarySection => 'Основное';

  @override
  String get editProfileNameLabel => 'Имя';

  @override
  String get fieldEmail => 'Email';

  @override
  String homeSalaryRangeFormatted(Object from, Object to, Object currency) {
    return '$from — $to $currency';
  }

  @override
  String homeSalaryFromFormatted(Object from, Object currency) {
    return 'от $from $currency';
  }

  @override
  String get homeCurrencyTenge => 'тг';

  @override
  String get profileLabelWorkerShort => 'соискатель';

  @override
  String get profileLabelCompanyShort => 'компания';

  @override
  String get profileSummaryNotFilled => 'Профили не оформлены';

  @override
  String get profileSummaryWorkerOnly => 'Соискатель';

  @override
  String get profileSummaryCompanyOnly => 'Компания';

  @override
  String profileSummaryDual(Object worker, Object company, Object active) {
    return 'Профили: $worker · $company · сейчас: $active';
  }

  @override
  String get securityAccountSectionTitle => 'Аккаунт';

  @override
  String get securityPasswordSectionTitle => 'Пароль';

  @override
  String get securityCurrentPasswordLabel => 'Текущий пароль';

  @override
  String get securityNewPasswordFieldLabel => 'Новый пароль';

  @override
  String get securityConfirmNewPasswordLabel => 'Повторите новый пароль';

  @override
  String securityNewPasswordHelper(Object min) {
    return 'Не короче $min символов';
  }

  @override
  String get securityValidatorCurrentPassword => 'Введите текущий пароль';

  @override
  String get securityValidatorNewPassword => 'Введите новый пароль';

  @override
  String get securityValidatorPasswordTooShort => 'Слишком короткий пароль';

  @override
  String get securityValidatorPasswordsMismatch => 'Пароли не совпадают';

  @override
  String get resumeSkillDialogTitle => 'Навык';

  @override
  String get resumeSaved => 'Резюме сохранено';

  @override
  String get resumeShowToCompanies => 'Показывать резюме компаниям';

  @override
  String get resumeNotSpecified => 'Не указан';

  @override
  String get resumeSectionAbout => 'О себе';

  @override
  String get resumeSectionSkills => 'Навыки';

  @override
  String resumeLineCity(Object city) {
    return 'Город: $city';
  }

  @override
  String resumeLinePhone(Object phone) {
    return 'Телефон: $phone';
  }

  @override
  String resumeLineEmail(Object email) {
    return 'Email: $email';
  }

  @override
  String get createVacancyTitle => 'Новая вакансия';

  @override
  String get createVacancyCategory => 'Категория';

  @override
  String get createVacancyOpenings => 'Количество мест';

  @override
  String get createVacancyFillRequired =>
      'Заполните название, категорию и город';

  @override
  String get createVacancySubmitted => 'Вакансия отправлена на публикацию';

  @override
  String get routerNoAccess => 'Нет доступа';

  @override
  String get routerInvalidVacancyId => 'Некорректный идентификатор вакансии';

  @override
  String get analyticsWorkerOnly => 'Статистика доступна соискателю';

  @override
  String get companyCandidatesAllStages => 'Все стадии';

  @override
  String get companySectionCompanyOnly => 'Раздел доступен компании';

  @override
  String get companyFilter => 'Фильтр';

  @override
  String get companyCandidateNoResume => 'У кандидата нет привязанного резюме';

  @override
  String get companyResumeNotFound => 'Резюме не найдено';

  @override
  String companyOpenResumeError(Object message) {
    return 'Не удалось открыть резюме: $message';
  }

  @override
  String get companyStatisticsCompanyOnly => 'Статистика доступна компании';

  @override
  String companyStatisticsVacanciesError(Object message) {
    return 'Ошибка статистики: $message';
  }

  @override
  String companyStatisticsApplicationsError(Object message) {
    return 'Ошибка откликов: $message';
  }

  @override
  String companyVacanciesViewApplications(Object count) {
    return 'Смотреть отклики ($count)';
  }

  @override
  String get companyHomeEditProfileSoon => 'Редактирование профиля — скоро';

  @override
  String get companyHomeCreateVacancy => '+ Создать';

  @override
  String get myApplicationsEditTitle => 'Редактировать отклик';

  @override
  String get myApplicationsWorkerOnly => 'Отклики доступны в режиме соискателя';

  @override
  String get myApplicationsChange => 'Изменить';

  @override
  String get myApplicationsDelete => 'Удалить';

  @override
  String companyFeatureSoon(Object feature) {
    return '$feature — скоро';
  }

  @override
  String companyProfileError(Object message) {
    return 'Ошибка профиля: $message';
  }

  @override
  String get companyProfileNotFound => 'Профиль компании не найден';

  @override
  String get companySwitchToWorker => 'Войти как соискатель';

  @override
  String get resumeSkillHint => 'Например: Курьер';

  @override
  String get resumeWorkExperienceNewTitle => 'Опыт работы';

  @override
  String get resumeWorkExperienceEditTitle => 'Редактировать опыт';

  @override
  String get resumeFieldPosition => 'Должность';

  @override
  String get resumeFieldCompany => 'Компания';

  @override
  String get resumePeriodFrom => 'Период с';

  @override
  String get resumePeriodFromHint => 'Март 2025';

  @override
  String get resumePeriodTo => 'Период по (пусто — по наст. время)';

  @override
  String get resumePeriodEmptyHint => 'Оставьте пустым';

  @override
  String get resumeFieldDescription => 'Описание';

  @override
  String get resumeLanguageNewTitle => 'Язык';

  @override
  String get resumeLanguageEditTitle => 'Редактировать язык';

  @override
  String get resumeFieldLanguageName => 'Язык';

  @override
  String get resumeLanguageLevelLabel => 'Уровень';

  @override
  String get resumePresentTime => 'Настоящее время';

  @override
  String get resumeLoadFailed => 'Не удалось загрузить резюме';

  @override
  String get resumeScreenTitle => 'Моё резюме';

  @override
  String get resumeAboutHint => 'Расскажите о себе…';

  @override
  String get resumeFieldCity => 'Город';

  @override
  String get resumeCityNotSpecified => 'Не указан';

  @override
  String get resumeVisibilitySubtitle =>
      'Если выключено, кабинет компании не увидит ваше резюме в общей ленте.';

  @override
  String get resumeEditTooltip => 'Изменить';

  @override
  String get resumeDeleteTooltip => 'Удалить';

  @override
  String get resumeHeadlineFieldHint => 'Соискатель';

  @override
  String get resumeSectionWorkExperience => 'Опыт работы';

  @override
  String get resumeSectionLanguages => 'Языки';

  @override
  String get resumeSectionVisibility => 'Видимость';

  @override
  String get resumeSectionPersonal => 'Личные данные';

  @override
  String get resumeFieldFullName => 'ФИО';

  @override
  String get resumeFieldPhone => 'Телефон';

  @override
  String get resumeFieldBirthDate => 'Дата рождения';

  @override
  String get resumeFieldBirthDateHint => '15.05.1998';

  @override
  String get resumeFieldDesiredPosition => 'Желаемая позиция';

  @override
  String get myApplicationsTitle => 'Мои отклики';

  @override
  String myApplicationsCount(Object count) {
    return '$count заявок';
  }

  @override
  String get myApplicationsEmpty => 'Пока нет откликов';

  @override
  String get myApplicationsUntitledVacancy => 'Без названия вакансии';

  @override
  String get myApplicationsStatusLabel => 'Статус';

  @override
  String get myApplicationsNoteLabel => 'Заметка';

  @override
  String get createVacancyStepIntro => 'Укажите название и категорию вакансии';

  @override
  String get createVacancyTitleLabel => 'Название вакансии';

  @override
  String get createVacancyTitleHint => 'Например: Курьер на вечерние смены';

  @override
  String get createVacancySalaryFromLabel => 'Зарплата от (тг)';

  @override
  String get createVacancySalaryToLabel => 'Зарплата до (тг)';

  @override
  String get createVacancyScheduleLabel => 'График';

  @override
  String get createVacancyCitySectionTitle => 'Город';

  @override
  String get createVacancyCityFieldLabel => 'Город вакансии';

  @override
  String get createVacancyCityHint => 'Выберите город';

  @override
  String get createVacancyDescriptionLabel => 'Описание';

  @override
  String get createVacancySubmitButton => 'Создать вакансию';

  @override
  String get createVacancySubmitting => 'Сохранение...';

  @override
  String createVacancyOpeningsSuffix(Object slots) {
    return 'Количество мест: $slots';
  }

  @override
  String get companyDefaultName => 'Компания';

  @override
  String get myApplicationsUpdatedPrefix => 'Обновлено:';

  @override
  String get companyShellVacanciesTitle => 'Мои вакансии';

  @override
  String get companyShellCandidatesTitle => 'Все кандидаты';

  @override
  String get companyShellStatisticsTitle => 'Статистика';

  @override
  String get companyShellProfileTitle => 'Профиль компании';

  @override
  String get companyEditProfileTooltip => 'Редактировать';

  @override
  String get companyMenuEditProfile => 'Редактировать профиль';

  @override
  String get companyMenuTeam => 'Команда';

  @override
  String get companyMenuHelp => 'Помощь';

  @override
  String get companyNavVacancies => 'Вакансии';

  @override
  String get companyNavCandidates => 'Кандидаты';

  @override
  String get companyNavStatistics => 'Статистика';

  @override
  String get companyNavCompany => 'Компания';

  @override
  String get companyVacancyFilterActive => 'Активные';

  @override
  String get companyVacancyFilterPaused => 'На паузе';
}
