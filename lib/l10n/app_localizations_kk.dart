// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'EasyShift';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get appearanceSection => 'Сыртқы түрі';

  @override
  String get themeSectionTitle => 'Тақырып';

  @override
  String get themeLight => 'Жарық';

  @override
  String get themeDark => 'Қараңғы';

  @override
  String get themeSystem => 'Жүйе бойынша';

  @override
  String get languageTitle => 'Тіл';

  @override
  String get languageRussian => 'Орыс тілі';

  @override
  String get cityTitle => 'Қала';

  @override
  String get cityAlmaty => 'Алматы';

  @override
  String get dataStorageSection => 'Деректер және сақтау';

  @override
  String get offlineModeTitle => 'Офлайн режим';

  @override
  String get offlineModeSubtitle => 'Офлайн үшін деректерді сақтау';

  @override
  String get autoUpdateTitle => 'Автожаңарту';

  @override
  String get autoUpdateSubtitle => 'Деректерді автоматты жаңарту';

  @override
  String get appCacheTitle => 'Қолданба кэші';

  @override
  String get appCacheSize => '—';

  @override
  String get clearCacheButton => 'Кэшті тазалау';

  @override
  String get aboutSection => 'Қолданба туралы';

  @override
  String get appName => 'EasyShift';

  @override
  String get appVersion => 'Нұсқа 1.0.0';

  @override
  String get termsOfService => 'Пайдалану шарттары';

  @override
  String get bottomNavVacancies => 'Бос орындар';

  @override
  String get bottomNavApplications => 'Өтінімдер';

  @override
  String get bottomNavStats => 'Статистика';

  @override
  String get bottomNavProfile => 'Профиль';

  @override
  String get commonCancel => 'Болдырмау';

  @override
  String get commonSave => 'Сақтау';

  @override
  String get commonAdd => 'Қосу';

  @override
  String get commonRetry => 'Қайталау';

  @override
  String errorWithMessage(Object message) {
    return 'Қате: $message';
  }

  @override
  String get authLogoutTitle => 'Шығасыз ба?';

  @override
  String get authLogoutMessage =>
      'Сессия аяқталады. Қолданбаны қайта ашқанда кіру қажет болады.';

  @override
  String get authLogoutCancel => 'Болдырмау';

  @override
  String get authLogoutConfirm => 'Шығу';

  @override
  String get loginPickRoleSubtitle =>
      'Қолданбаны қалай пайдаланғыңыз келетінін таңдаңыз';

  @override
  String get loginWorkerTitle => 'Жұмыс іздеуші';

  @override
  String get loginWorkerSubtitle =>
      'Жұмыс табыңыз және бос орындарға өтінім жіберіңіз';

  @override
  String get loginWorkerTag1 => 'Бос орын іздеу';

  @override
  String get loginWorkerTag2 => 'Өтінімдерді бақылау';

  @override
  String get loginCompanyTitle => 'Компания';

  @override
  String get loginCompanySubtitle =>
      'Бос орын жариялаңыз және қызметкер табыңыз';

  @override
  String get loginCompanyTag1 => 'Бос орын құру';

  @override
  String get loginCompanyTag2 => 'Кандидат іздеу';

  @override
  String get loginChangeRoleFooter =>
      'Рөлді баптауларда кез келген уақытта өзгертуге болады';

  @override
  String get loginContinue => 'Жалғастыру';

  @override
  String get loginScreenTitle => 'Кіру';

  @override
  String get loginCredentialsTitle => 'EasyShift-ке кіру';

  @override
  String loginCredentialsBody(Object role) {
    return 'Рөл: $role. Кіру кезінде ол профильде сақталады — әр кіруде өзгертуге болады. Таңдалған аккаунт түрінің экраны ашылады.';
  }

  @override
  String get loginChangeRole => 'Рөлді өзгерту';

  @override
  String get loginPassword => 'Құпия сөз';

  @override
  String get loginSubmit => 'Кіру';

  @override
  String get loginGoogle => 'Google арқылы кіру';

  @override
  String get loginRegisterLink => 'Аккаунт жоқ па? Тіркелу';

  @override
  String get roleWorker => 'Жұмыс іздеуші';

  @override
  String get roleCompany => 'Компания';

  @override
  String get homeOnlineTooltip => 'Желіде';

  @override
  String get homeOfflineTooltip => 'Желіден тыс';

  @override
  String get homeAccountTooltip => 'Аккаунт';

  @override
  String get homeOfflineBanner =>
      'Желіден тыс: интернет жоқ. Деректер кэштен болуы мүмкін.';

  @override
  String get homeSearchHint => 'Бос орындар мен компанияларды іздеу';

  @override
  String get homeSortLabel => 'Сұрыптау';

  @override
  String get homeSortByDate => 'Күні бойынша';

  @override
  String get homeSortByCity => 'Қала бойынша';

  @override
  String get homeCityHeader => 'Қала';

  @override
  String get homeVacanciesNotFound => 'Бос орындар табылмады';

  @override
  String homeVacanciesError(Object message) {
    return 'Жүктеу қатесі: $message';
  }

  @override
  String get homeCompanyUnknown => 'Компания көрсетілмеген';

  @override
  String get homeSalaryNotSpecified => 'Жалақы көрсетілмеген';

  @override
  String get homeCityUnknown => 'Қала көрсетілмеген';

  @override
  String get homeScheduleUnknown => 'Кесте көрсетілмеген';

  @override
  String get homeHotVacancy => 'Ыстық';

  @override
  String get homeFilterAll => 'Барлығы';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileLoginPrompt => 'Профильді көру үшін кіріңіз.';

  @override
  String get profileEdit => 'Профильді өңдеу';

  @override
  String get profileSwitchCompany => 'Компания ретінде кіру';

  @override
  String get profileLogout => 'Аккаунттан шығу';

  @override
  String get profileResume => 'Менің түйіндемем';

  @override
  String get profileNotifications => 'Хабарландырулар';

  @override
  String get profileSecurity => 'Қауіпсіздік';

  @override
  String get profileSettings => 'Баптаулар';

  @override
  String get profileHelp => 'Көмек';

  @override
  String get profileResumeBadge => 'Толтырылған';

  @override
  String get profileNotificationsBadge => '3';

  @override
  String get profileActivityTitle => 'Белсенділік';

  @override
  String get profileActivityHint =>
      '«Профиль» бөлімін күн сайын ашыңыз — біз қатар күн санаймыз.';

  @override
  String get profileActivityStreakLabel => 'Күн сериясы';

  @override
  String profileActivityLoadError(Object error) {
    return 'Жаңарту сәтсіз: $error';
  }

  @override
  String profileStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count күн',
      one: '$count күн',
    );
    return '$_temp0';
  }

  @override
  String get securityTitle => 'Қауіпсіздік';

  @override
  String get securityAccountLocal =>
      'Жергілікті режим: құпия сөз тек осы құрылғыда сақталады.';

  @override
  String get securityAccountEmailPassword =>
      'Email және құпия сөз аккаунты. Төменде құпия сөзді өзгертуге болады.';

  @override
  String get securityAccountGoogle =>
      'Google арқылы кіру. Қолданба құпия сөзі қолданылмайды — Google аккаунтында рұқсатты басқарыңыз.';

  @override
  String securityPasswordHint(Object min) {
    return 'Өзгерту үшін ағымдағы және жаңа құпия сөзді енгізіңіз (кемінде $min таңба).';
  }

  @override
  String get securityChangePassword => 'Құпия сөзді өзгерту';

  @override
  String get securityResetEmail => 'Email-ға қалпына келтіру хаты';

  @override
  String get securityEmailProfileTitle => 'Email және аты';

  @override
  String get securityEmailProfileSubtitle =>
      'Профильді өңдеу және email өзгерту (растаумен).';

  @override
  String get security2faTitle => 'Екі факторлы аутентификация';

  @override
  String get security2faSubtitle =>
      'Әзірге жоқ. Кейін SMS немесе аутентификатор қолданбасы қосылады.';

  @override
  String get securityBiometricsTitle => 'Биометрия';

  @override
  String get securityBiometricsSubtitle =>
      'Бас бармақ немесе Face ID — жоспарда.';

  @override
  String get securitySoonChip => 'Жақында';

  @override
  String get securitySessionsTitle => 'Сессиялар';

  @override
  String get securitySessionsBody =>
      'Құрылғылар тізімі қолданбада қолжетімсіз: Firebase белсенді сессияларды клиентке бермейді. Осы құрылғыдан шығуға болады.';

  @override
  String get securitySessionsLogout => 'Аккаунттан шығу';

  @override
  String get securityNewPasswordTitle => 'Жаңа құпия сөз';

  @override
  String get securityPasswordUpdated => 'Құпия сөз жаңартылды';

  @override
  String get securityNoEmailForReset => 'Қалпына келтіру үшін email жоқ';

  @override
  String get securityResetEmailSent => 'Сілтемесі бар хат email-ға жіберілді';

  @override
  String get vacancyDetailsTitle => 'Бос орын мәліметтері';

  @override
  String get vacancyNotFound => 'Бос орын табылмады';

  @override
  String get vacancyDescriptionHeading => 'Сипаттама';

  @override
  String get vacancyNoDescription => 'Сипаттама әлі жоқ';

  @override
  String get vacancyNoCategory => 'Санат жоқ';

  @override
  String get vacancyApply => 'Өтінім жіберу';

  @override
  String get vacancyBack => 'Тізімге оралу';

  @override
  String get vacancyNeedLogin => 'Аккаунтқа кіріңіз';

  @override
  String get vacancyWorkerOnly => 'Өтінім тек жұмыс іздеушіге қолжетімді';

  @override
  String get vacancyUidMissing => 'Пайдаланушы UID табылмады';

  @override
  String get vacancyApplySent => 'Өтінім жіберілді';

  @override
  String get editProfileSaved => 'Профиль сақталды';

  @override
  String get editProfileTitle => 'Профильді өңдеу';

  @override
  String get editProfileSave => 'Сақтау';

  @override
  String get editProfileSaving => 'Сақталуда…';

  @override
  String get editProfileEmailHint =>
      'Email өзгерту кезінде Firebase жаңа мекенжайға растау хатын жіберуі мүмкін; расталғанша ескі email жұмыс істейді.';

  @override
  String get settingsCityNotSelected => 'Таңдалмаған';

  @override
  String get settingsCityAllCitiesHint =>
      'Басты бетте — «Барлық қалалар» сүзгісі';

  @override
  String get settingsClearCacheConfirmTitle => 'Кэшті тазалау';

  @override
  String get settingsClearCacheConfirmBody =>
      'Уақытша файлдар, сурет кэші және жергілікті деректер жойылады (кіру сессиясын қоспағанда): баптаулардағы жобалар, белсенділік сериясы, офлайн түйіндеме және т.б.';

  @override
  String get settingsClearCacheAction => 'Тазалау';

  @override
  String get settingsClearingCache => 'Тазаланады…';

  @override
  String settingsCacheCleared(Object size) {
    return 'Кэш тазаланды (~$size)';
  }

  @override
  String get registerTitle => 'Тіркелу';

  @override
  String get registerHaveAccount => 'Аккаунт бар ма? Кіру';

  @override
  String get registerHeadline => 'Аккаунт құру';

  @override
  String get registerSubtitleWorker =>
      'Жұмыс іздеуші ретінде тіркелу. Фото немесе логотипті кейін профильден қосуға болады.';

  @override
  String get registerSubtitleCompany =>
      'Компания ретінде тіркелу. Фото немесе логотипті кейін профильден қосуға болады.';

  @override
  String get registerNameLabel => 'Аты';

  @override
  String get registerNameHint => 'Сізге қалай жүгіну керек';

  @override
  String get registerConfirmPassword => 'Құпия сөзді растау';

  @override
  String get registerSubmit => 'Аккаунт құру';

  @override
  String get editProfilePrimarySection => 'Негізгі';

  @override
  String get editProfileNameLabel => 'Аты';

  @override
  String get fieldEmail => 'Email';

  @override
  String homeSalaryRangeFormatted(Object from, Object to, Object currency) {
    return '$from — $to $currency';
  }

  @override
  String homeSalaryFromFormatted(Object from, Object currency) {
    return '$from $currency бастап';
  }

  @override
  String get homeCurrencyTenge => 'тг';

  @override
  String get profileLabelWorkerShort => 'жұмыс іздеуші';

  @override
  String get profileLabelCompanyShort => 'компания';

  @override
  String get profileSummaryNotFilled => 'Профильдер рәсімделмеген';

  @override
  String get profileSummaryWorkerOnly => 'Жұмыс іздеуші';

  @override
  String get profileSummaryCompanyOnly => 'Компания';

  @override
  String profileSummaryDual(Object worker, Object company, Object active) {
    return 'Профильдер: $worker · $company · қазір: $active';
  }

  @override
  String get securityAccountSectionTitle => 'Аккаунт';

  @override
  String get securityPasswordSectionTitle => 'Құпия сөз';

  @override
  String get securityCurrentPasswordLabel => 'Ағымдағы құпия сөз';

  @override
  String get securityNewPasswordFieldLabel => 'Жаңа құпия сөз';

  @override
  String get securityConfirmNewPasswordLabel => 'Жаңа құпия сөзді қайталаңыз';

  @override
  String securityNewPasswordHelper(Object min) {
    return 'Кемінде $min таңба';
  }

  @override
  String get securityValidatorCurrentPassword =>
      'Ағымдағы құпия сөзді енгізіңіз';

  @override
  String get securityValidatorNewPassword => 'Жаңа құпия сөзді енгізіңіз';

  @override
  String get securityValidatorPasswordTooShort => 'Құпия сөз тым қысқа';

  @override
  String get securityValidatorPasswordsMismatch => 'Құпия сөздер сәйкес емес';

  @override
  String get resumeSkillDialogTitle => 'Дағды';

  @override
  String get resumeSaved => 'Түйіндеме сақталды';

  @override
  String get resumeShowToCompanies => 'Түйіндемені компанияларға көрсету';

  @override
  String get resumeNotSpecified => 'Көрсетілмеген';

  @override
  String get resumeSectionAbout => 'Өзім туралы';

  @override
  String get resumeSectionSkills => 'Дағдылар';

  @override
  String resumeLineCity(Object city) {
    return 'Қала: $city';
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
  String get createVacancyTitle => 'Жаңа бос орын';

  @override
  String get createVacancyCategory => 'Санат';

  @override
  String get createVacancyOpenings => 'Орын саны';

  @override
  String get createVacancyFillRequired => 'Атау, санат және қаланы толтырыңыз';

  @override
  String get createVacancySubmitted => 'Бос орын жариялауға жіберілді';

  @override
  String get routerNoAccess => 'Рұқсат жоқ';

  @override
  String get routerInvalidVacancyId => 'Бос орын идентификаторы дұрыс емес';

  @override
  String get analyticsWorkerOnly => 'Статистика жұмыс іздеушіге арналған';

  @override
  String get companyCandidatesAllStages => 'Барлық кезеңдер';

  @override
  String get companySectionCompanyOnly => 'Бөлім компанияға арналған';

  @override
  String get companyFilter => 'Сүзгі';

  @override
  String get companyCandidateNoResume => 'Кандидатта байланысты түйіндеме жоқ';

  @override
  String get companyResumeNotFound => 'Түйіндеме табылмады';

  @override
  String get companyResumeViewerTitle => 'Кандидаттың түйіндемесі';

  @override
  String get companyResumePreviewExplanation =>
      'Бұл жұмыс іздеуші сақтаған түйіндеме. Бос бөлімдерді ол толтырмаған.';

  @override
  String companyOpenResumeError(Object message) {
    return 'Түйіндемені ашу сәтсіз: $message';
  }

  @override
  String get companyStatisticsCompanyOnly => 'Статистика компанияға арналған';

  @override
  String companyStatisticsVacanciesError(Object message) {
    return 'Статистика қатесі: $message';
  }

  @override
  String companyStatisticsApplicationsError(Object message) {
    return 'Өтінімдер қатесі: $message';
  }

  @override
  String companyVacanciesViewApplications(Object count) {
    return 'Өтінімдерді көру ($count)';
  }

  @override
  String get companyHomeEditProfileSoon => 'Профильді өңдеу — жақында';

  @override
  String get companyHomeCreateVacancy => '+ Құру';

  @override
  String get myApplicationsEditTitle => 'Өтінімді өңдеу';

  @override
  String get myApplicationsWorkerOnly => 'Өтінімдер жұмыс іздеуші режимінде';

  @override
  String get myApplicationsChange => 'Өзгерту';

  @override
  String get myApplicationsDelete => 'Жою';

  @override
  String companyFeatureSoon(Object feature) {
    return '$feature — жақында';
  }

  @override
  String companyProfileError(Object message) {
    return 'Профиль қатесі: $message';
  }

  @override
  String get companyProfileNotFound => 'Компания профилі табылмады';

  @override
  String get companySwitchToWorker => 'Жұмыс іздеуші ретінде кіру';

  @override
  String get resumeSkillHint => 'Мысалы: курьер';

  @override
  String get resumeWorkExperienceNewTitle => 'Жұмыс тәжірибесі';

  @override
  String get resumeWorkExperienceEditTitle => 'Тәжірибені өңдеу';

  @override
  String get resumeFieldPosition => 'Лауазым';

  @override
  String get resumeFieldCompany => 'Компания';

  @override
  String get resumePeriodFrom => 'Мерзімі бастап';

  @override
  String get resumePeriodFromHint => 'Наурыз 2025';

  @override
  String get resumePeriodTo => 'Мерзімі дейін (бос — қазірге дейін)';

  @override
  String get resumePeriodEmptyHint => 'Бос қалдырыңыз';

  @override
  String get resumeFieldDescription => 'Сипаттама';

  @override
  String get resumeLanguageNewTitle => 'Тіл';

  @override
  String get resumeLanguageEditTitle => 'Тілді өңдеу';

  @override
  String get resumeFieldLanguageName => 'Тіл';

  @override
  String get resumeLanguageLevelLabel => 'Деңгей';

  @override
  String get resumePresentTime => 'Қазіргі уақыт';

  @override
  String get resumeLoadFailed => 'Түйіндемені жүктеу сәтсіз';

  @override
  String get resumeScreenTitle => 'Менің түйіндемем';

  @override
  String get resumeAboutHint => 'Өзіңіз туралы айтып беріңіз…';

  @override
  String get resumeFieldCity => 'Қала';

  @override
  String get resumeCityNotSpecified => 'Көрсетілмеген';

  @override
  String get resumeVisibilitySubtitle =>
      'Өшірілсе, компания сіздің түйіндемеңізді жалпы таспада көрмейді.';

  @override
  String get resumeEditTooltip => 'Өңдеу';

  @override
  String get resumeDeleteTooltip => 'Жою';

  @override
  String get resumeHeadlineFieldHint => 'Жұмыс іздеуші';

  @override
  String get resumeSectionWorkExperience => 'Жұмыс тәжірибесі';

  @override
  String get resumeSectionLanguages => 'Тілдер';

  @override
  String get resumeSectionVisibility => 'Көрінуі';

  @override
  String get resumeSectionPersonal => 'Жеке деректер';

  @override
  String get resumeFieldFullName => 'ТАӘ';

  @override
  String get resumeFieldPhone => 'Телефон';

  @override
  String get resumeFieldBirthDate => 'Туған күні';

  @override
  String get resumeFieldBirthDateHint => '15.05.1998';

  @override
  String get resumeFieldDesiredPosition => 'Қалаған лауазым';

  @override
  String get myApplicationsTitle => 'Менің өтінімдерім';

  @override
  String myApplicationsCount(Object count) {
    return '$count өтінім';
  }

  @override
  String get myApplicationsEmpty => 'Әзірге өтінім жоқ';

  @override
  String get myApplicationsUntitledVacancy => 'Атаусыз бос орын';

  @override
  String get myApplicationsStatusLabel => 'Күйі';

  @override
  String get myApplicationsNoteLabel => 'Ескерту';

  @override
  String get createVacancyStepIntro => 'Бос орын атауы мен санатын көрсетіңіз';

  @override
  String get createVacancyTitleLabel => 'Бос орын атауы';

  @override
  String get createVacancyTitleHint => 'Мысалы: кешкі ауысымға курьер';

  @override
  String get createVacancySalaryFromLabel => 'Жалақы бастап (тг)';

  @override
  String get createVacancySalaryToLabel => 'Жалақы дейін (тг)';

  @override
  String get createVacancyScheduleLabel => 'Кесте';

  @override
  String get createVacancyCitySectionTitle => 'Қала';

  @override
  String get createVacancyCityFieldLabel => 'Бос орын қаласы';

  @override
  String get createVacancyCityHint => 'Қаланы таңдаңыз';

  @override
  String get createVacancyDescriptionLabel => 'Сипаттама';

  @override
  String get createVacancySubmitButton => 'Бос орын құру';

  @override
  String get createVacancySubmitting => 'Сақталуда...';

  @override
  String createVacancyOpeningsSuffix(Object slots) {
    return 'Орын саны: $slots';
  }

  @override
  String get companyDefaultName => 'Компания';

  @override
  String get myApplicationsUpdatedPrefix => 'Жаңартылды:';

  @override
  String get companyShellVacanciesTitle => 'Менің бос орындарым';

  @override
  String get companyShellCandidatesTitle => 'Барлық кандидаттар';

  @override
  String get companyShellStatisticsTitle => 'Статистика';

  @override
  String get companyShellProfileTitle => 'Компания профилі';

  @override
  String get companyEditProfileTooltip => 'Өңдеу';

  @override
  String get companyMenuEditProfile => 'Профильді өңдеу';

  @override
  String get companyMenuTeam => 'Команда';

  @override
  String get companyMenuHelp => 'Көмек';

  @override
  String get companyNavVacancies => 'Бос орындар';

  @override
  String get companyNavCandidates => 'Кандидаттар';

  @override
  String get companyNavStatistics => 'Статистика';

  @override
  String get companyNavCompany => 'Компания';

  @override
  String get companyVacancyFilterActive => 'Белсенді';

  @override
  String get companyVacancyFilterPaused => 'Кідірілген';

  @override
  String get companyVacanciesSearchHint => 'Бос орындарды іздеу…';

  @override
  String get companyVacanciesEmptyFilter => 'Сүзгі бойынша еш нәрсе жоқ';

  @override
  String companyVacanciesActiveSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count белсенді бос орын',
      one: '$count белсенді бос орын',
    );
    return '$_temp0';
  }

  @override
  String companyApplicationsShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count өтінім',
      one: '$count өтінім',
    );
    return '$_temp0';
  }

  @override
  String get companyVacancyCardStatusActive => 'Белсенді';

  @override
  String get companyVacancyCardStatusPaused => 'Кідірілген';

  @override
  String get companyStatisticsFirestoreHint =>
      'Firestore нақты деректері бойынша талдау';

  @override
  String get companyCandidatesSearchHint => 'Кандидаттарды іздеу…';

  @override
  String get companyCandidatesStatTotal => 'Барлық өтінім';

  @override
  String get companyCandidatesStatNew => 'Жаңа';

  @override
  String get companyCandidatesEmptyQuery => 'Сұрау бойынша кандидат жоқ';

  @override
  String get resumePreviewNoName => 'Аты жоқ';

  @override
  String get vacancyEditTitle => 'Вакансияны өңдеу';

  @override
  String get vacancyMenuEdit => 'Өңдеу';

  @override
  String get vacancyMenuPause => 'Пауза ету';

  @override
  String get vacancyMenuResume => 'Жалғастыру';

  @override
  String get vacancyMenuDelete => 'Өшіру';

  @override
  String get vacancyDeleteConfirmTitle => 'Вакансияны өшіру?';

  @override
  String get vacancyDeleteConfirmMessage =>
      'Бұл әрекетті қайта қайтаруға болмайды. Осы вакансияға барлық өтініктер өшіріледі.';

  @override
  String get vacancyDeleteConfirmCancel => 'Бас тарту';

  @override
  String get vacancyDeleteConfirmDelete => 'Өшіру';

  @override
  String get vacancyDeletedSuccess => 'Вакансия өшірілді';

  @override
  String get vacancyPausedSuccess => 'Вакансия паузада';

  @override
  String get vacancyResumedSuccess => 'Вакансия белсендірілді';

  @override
  String get vacancyUpdatedSuccess => 'Вакансия жаңартылды';
}
