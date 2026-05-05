// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EasyShift';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get themeSectionTitle => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get cityTitle => 'City';

  @override
  String get cityAlmaty => 'Almaty';

  @override
  String get dataStorageSection => 'Data & storage';

  @override
  String get offlineModeTitle => 'Offline mode';

  @override
  String get offlineModeSubtitle => 'Keep data for offline use';

  @override
  String get autoUpdateTitle => 'Auto refresh';

  @override
  String get autoUpdateSubtitle => 'Refresh data automatically';

  @override
  String get appCacheTitle => 'App cache';

  @override
  String get appCacheSize => '—';

  @override
  String get clearCacheButton => 'Clear cache';

  @override
  String get aboutSection => 'About';

  @override
  String get appName => 'EasyShift';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get termsOfService => 'Terms of use';

  @override
  String get bottomNavVacancies => 'Jobs';

  @override
  String get bottomNavApplications => 'Applications';

  @override
  String get bottomNavStats => 'Statistics';

  @override
  String get bottomNavProfile => 'Profile';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonRetry => 'Retry';

  @override
  String errorWithMessage(Object message) {
    return 'Error: $message';
  }

  @override
  String get authLogoutTitle => 'Sign out?';

  @override
  String get authLogoutMessage =>
      'Your session will end. You will need to sign in again to use the app with your account.';

  @override
  String get authLogoutCancel => 'Cancel';

  @override
  String get authLogoutConfirm => 'Sign out';

  @override
  String get loginPickRoleSubtitle => 'Choose how you want to use the app';

  @override
  String get loginWorkerTitle => 'Job seeker';

  @override
  String get loginWorkerSubtitle => 'Find jobs and apply to vacancies';

  @override
  String get loginWorkerTag1 => 'Job search';

  @override
  String get loginWorkerTag2 => 'Application tracking';

  @override
  String get loginCompanyTitle => 'Company';

  @override
  String get loginCompanySubtitle => 'Post vacancies and hire staff';

  @override
  String get loginCompanyTag1 => 'Create vacancies';

  @override
  String get loginCompanyTag2 => 'Find candidates';

  @override
  String get loginChangeRoleFooter =>
      'You can change your role anytime in settings';

  @override
  String get loginContinue => 'Continue';

  @override
  String get loginScreenTitle => 'Sign in';

  @override
  String get loginCredentialsTitle => 'Sign in to EasyShift';

  @override
  String loginCredentialsBody(Object role) {
    return 'Role: $role. It will be saved to your profile on sign-in and you can change it each time. The home screen for that account type will open.';
  }

  @override
  String get loginChangeRole => 'Change role';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginGoogle => 'Sign in with Google';

  @override
  String get loginRegisterLink => 'No account? Register';

  @override
  String get roleWorker => 'Job seeker';

  @override
  String get roleCompany => 'Company';

  @override
  String get homeOnlineTooltip => 'Online';

  @override
  String get homeOfflineTooltip => 'Offline';

  @override
  String get homeAccountTooltip => 'Account';

  @override
  String get homeOfflineBanner =>
      'Offline: no internet. Data may be from cache.';

  @override
  String get homeSearchHint => 'Search jobs and companies';

  @override
  String get homeSortLabel => 'Sort';

  @override
  String get homeSortByDate => 'By date';

  @override
  String get homeSortByCity => 'By city';

  @override
  String get homeCityHeader => 'City';

  @override
  String get homeVacanciesNotFound => 'No jobs found';

  @override
  String homeVacanciesError(Object message) {
    return 'Could not load jobs: $message';
  }

  @override
  String get homeCompanyUnknown => 'Company not specified';

  @override
  String get homeSalaryNotSpecified => 'Salary not specified';

  @override
  String get homeCityUnknown => 'City not specified';

  @override
  String get homeScheduleUnknown => 'Schedule not specified';

  @override
  String get homeHotVacancy => 'Hot';

  @override
  String get homeFilterAll => 'All';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLoginPrompt => 'Sign in to see your profile.';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileSwitchCompany => 'Switch to company';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileResume => 'My resume';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileHelp => 'Help';

  @override
  String get profileResumeBadge => 'Complete';

  @override
  String get profileNotificationsBadge => '3';

  @override
  String get profileActivityTitle => 'Activity';

  @override
  String get profileActivityHint =>
      'Open Profile every day — we count consecutive days.';

  @override
  String get profileActivityStreakLabel => 'Day streak';

  @override
  String profileActivityLoadError(Object error) {
    return 'Could not refresh: $error';
  }

  @override
  String profileStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get securityTitle => 'Security';

  @override
  String get securityAccountLocal =>
      'Local mode: password is stored only on this device.';

  @override
  String get securityAccountEmailPassword =>
      'Email and password account. You can change the password below.';

  @override
  String get securityAccountGoogle =>
      'Signed in with Google. No app password — manage access in your Google account.';

  @override
  String securityPasswordHint(Object min) {
    return 'To change, enter your current password and a new one (at least $min characters).';
  }

  @override
  String get securityChangePassword => 'Change password';

  @override
  String get securityResetEmail => 'Send password reset email';

  @override
  String get securityEmailProfileTitle => 'Email and name';

  @override
  String get securityEmailProfileSubtitle =>
      'Edit profile and change email (with verification).';

  @override
  String get security2faTitle => 'Two-factor authentication';

  @override
  String get security2faSubtitle =>
      'Not available yet. SMS or authenticator app coming later.';

  @override
  String get securityBiometricsTitle => 'Biometrics';

  @override
  String get securityBiometricsSubtitle =>
      'Fingerprint or Face ID sign-in — planned.';

  @override
  String get securitySoonChip => 'Soon';

  @override
  String get securitySessionsTitle => 'Sessions';

  @override
  String get securitySessionsBody =>
      'Device list is not available in the app: Firebase does not expose active sessions to the client. You can sign out on this device.';

  @override
  String get securitySessionsLogout => 'Sign out';

  @override
  String get securityNewPasswordTitle => 'New password';

  @override
  String get securityPasswordUpdated => 'Password updated';

  @override
  String get securityNoEmailForReset => 'No email for reset';

  @override
  String get securityResetEmailSent => 'A reset link was sent to your email';

  @override
  String get vacancyDetailsTitle => 'Job details';

  @override
  String get vacancyNotFound => 'Job not found';

  @override
  String get vacancyDescriptionHeading => 'Description';

  @override
  String get vacancyNoDescription => 'No description yet';

  @override
  String get vacancyNoCategory => 'No category';

  @override
  String get vacancyApply => 'Apply';

  @override
  String get vacancyBack => 'Back to list';

  @override
  String get vacancyNeedLogin => 'Please sign in';

  @override
  String get vacancyWorkerOnly => 'Applying is only for job seekers';

  @override
  String get vacancyUidMissing => 'User UID not found';

  @override
  String get vacancyApplySent => 'Application sent';

  @override
  String get editProfileSaved => 'Profile saved';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileSave => 'Save';

  @override
  String get editProfileSaving => 'Saving…';

  @override
  String get editProfileEmailHint =>
      'When you change email, Firebase may send a confirmation to the new address; the old email still works until you confirm.';

  @override
  String get settingsCityNotSelected => 'Not set';

  @override
  String get settingsCityAllCitiesHint => 'On home — filter “All cities”';

  @override
  String get settingsClearCacheConfirmTitle => 'Clear cache';

  @override
  String get settingsClearCacheConfirmBody =>
      'Temporary files, image cache, and local data will be removed (except your sign-in session): settings drafts, activity streak, offline resume draft, etc.';

  @override
  String get settingsClearCacheAction => 'Clear';

  @override
  String get settingsClearingCache => 'Clearing…';

  @override
  String settingsCacheCleared(Object size) {
    return 'Cache cleared (~$size)';
  }

  @override
  String get registerTitle => 'Register';

  @override
  String get registerHaveAccount => 'Already have an account? Sign in';

  @override
  String get registerHeadline => 'Create account';

  @override
  String get registerSubtitleWorker =>
      'Register as a job seeker. You can add a photo or logo later in your profile.';

  @override
  String get registerSubtitleCompany =>
      'Register as a company. You can add a photo or logo later in your profile.';

  @override
  String get registerNameLabel => 'Name';

  @override
  String get registerNameHint => 'How should we address you';

  @override
  String get registerConfirmPassword => 'Confirm password';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get editProfilePrimarySection => 'Basics';

  @override
  String get editProfileNameLabel => 'Name';

  @override
  String get fieldEmail => 'Email';

  @override
  String homeSalaryRangeFormatted(Object from, Object to, Object currency) {
    return '$from – $to $currency';
  }

  @override
  String homeSalaryFromFormatted(Object from, Object currency) {
    return 'from $from $currency';
  }

  @override
  String get homeCurrencyTenge => '₸';

  @override
  String get profileLabelWorkerShort => 'job seeker';

  @override
  String get profileLabelCompanyShort => 'company';

  @override
  String get profileSummaryNotFilled => 'Profiles not set up';

  @override
  String get profileSummaryWorkerOnly => 'Job seeker';

  @override
  String get profileSummaryCompanyOnly => 'Company';

  @override
  String profileSummaryDual(Object worker, Object company, Object active) {
    return 'Profiles: $worker · $company · now: $active';
  }

  @override
  String get securityAccountSectionTitle => 'Account';

  @override
  String get securityPasswordSectionTitle => 'Password';

  @override
  String get securityCurrentPasswordLabel => 'Current password';

  @override
  String get securityNewPasswordFieldLabel => 'New password';

  @override
  String get securityConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String securityNewPasswordHelper(Object min) {
    return 'At least $min characters';
  }

  @override
  String get securityValidatorCurrentPassword => 'Enter current password';

  @override
  String get securityValidatorNewPassword => 'Enter new password';

  @override
  String get securityValidatorPasswordTooShort => 'Password too short';

  @override
  String get securityValidatorPasswordsMismatch => 'Passwords do not match';

  @override
  String get resumeSkillDialogTitle => 'Skill';

  @override
  String get resumeSaved => 'Resume saved';

  @override
  String get resumeShowToCompanies => 'Show resume to companies';

  @override
  String get resumeNotSpecified => 'Not specified';

  @override
  String get resumeSectionAbout => 'About';

  @override
  String get resumeSectionSkills => 'Skills';

  @override
  String resumeLineCity(Object city) {
    return 'City: $city';
  }

  @override
  String resumeLinePhone(Object phone) {
    return 'Phone: $phone';
  }

  @override
  String resumeLineEmail(Object email) {
    return 'Email: $email';
  }

  @override
  String get createVacancyTitle => 'New vacancy';

  @override
  String get createVacancyCategory => 'Category';

  @override
  String get createVacancyOpenings => 'Number of openings';

  @override
  String get createVacancyFillRequired => 'Fill in title, category, and city';

  @override
  String get createVacancySubmitted => 'Vacancy submitted for publication';

  @override
  String get routerNoAccess => 'No access';

  @override
  String get routerInvalidVacancyId => 'Invalid job ID';

  @override
  String get analyticsWorkerOnly => 'Statistics are for job seekers';

  @override
  String get companyCandidatesAllStages => 'All stages';

  @override
  String get companySectionCompanyOnly => 'This section is for companies';

  @override
  String get companyFilter => 'Filter';

  @override
  String get companyCandidateNoResume => 'Candidate has no linked resume';

  @override
  String get companyResumeNotFound => 'Resume not found';

  @override
  String get companyResumeViewerTitle => 'Applicant resume';

  @override
  String get companyResumePreviewExplanation =>
      'This is the candidate\'s saved resume. Sections appear empty if they did not fill them in.';

  @override
  String companyOpenResumeError(Object message) {
    return 'Could not open resume: $message';
  }

  @override
  String get companyStatisticsCompanyOnly => 'Statistics are for companies';

  @override
  String companyStatisticsVacanciesError(Object message) {
    return 'Vacancy stats error: $message';
  }

  @override
  String companyStatisticsApplicationsError(Object message) {
    return 'Applications error: $message';
  }

  @override
  String companyVacanciesViewApplications(Object count) {
    return 'View applications ($count)';
  }

  @override
  String get companyHomeEditProfileSoon => 'Edit profile — coming soon';

  @override
  String get companyHomeCreateVacancy => '+ Create';

  @override
  String get myApplicationsEditTitle => 'Edit application';

  @override
  String get myApplicationsWorkerOnly => 'Applications are for job seeker mode';

  @override
  String get myApplicationsChange => 'Edit';

  @override
  String get myApplicationsDelete => 'Delete';

  @override
  String companyFeatureSoon(Object feature) {
    return '$feature — coming soon';
  }

  @override
  String companyProfileError(Object message) {
    return 'Profile error: $message';
  }

  @override
  String get companyProfileNotFound => 'Company profile not found';

  @override
  String get companySwitchToWorker => 'Switch to job seeker';

  @override
  String get resumeSkillHint => 'e.g. Courier';

  @override
  String get resumeWorkExperienceNewTitle => 'Work experience';

  @override
  String get resumeWorkExperienceEditTitle => 'Edit experience';

  @override
  String get resumeFieldPosition => 'Role';

  @override
  String get resumeFieldCompany => 'Company';

  @override
  String get resumePeriodFrom => 'From';

  @override
  String get resumePeriodFromHint => 'Mar 2025';

  @override
  String get resumePeriodTo => 'To (empty — present)';

  @override
  String get resumePeriodEmptyHint => 'Leave empty';

  @override
  String get resumeFieldDescription => 'Description';

  @override
  String get resumeLanguageNewTitle => 'Language';

  @override
  String get resumeLanguageEditTitle => 'Edit language';

  @override
  String get resumeFieldLanguageName => 'Language';

  @override
  String get resumeLanguageLevelLabel => 'Level';

  @override
  String get resumePresentTime => 'Present';

  @override
  String get resumeLoadFailed => 'Could not load resume';

  @override
  String get resumeScreenTitle => 'My resume';

  @override
  String get resumeAboutHint => 'Tell us about yourself…';

  @override
  String get resumeFieldCity => 'City';

  @override
  String get resumeCityNotSpecified => 'Not set';

  @override
  String get resumeVisibilitySubtitle =>
      'When off, companies will not see your resume in the shared feed.';

  @override
  String get resumeEditTooltip => 'Edit';

  @override
  String get resumeDeleteTooltip => 'Delete';

  @override
  String get resumeHeadlineFieldHint => 'Job seeker';

  @override
  String get resumeSectionWorkExperience => 'Work experience';

  @override
  String get resumeSectionLanguages => 'Languages';

  @override
  String get resumeSectionVisibility => 'Visibility';

  @override
  String get resumeSectionPersonal => 'Personal details';

  @override
  String get resumeFieldFullName => 'Full name';

  @override
  String get resumeFieldPhone => 'Phone';

  @override
  String get resumeFieldBirthDate => 'Date of birth';

  @override
  String get resumeFieldBirthDateHint => '15.05.1998';

  @override
  String get resumeFieldDesiredPosition => 'Desired role';

  @override
  String get myApplicationsTitle => 'My applications';

  @override
  String myApplicationsCount(Object count) {
    return '$count applications';
  }

  @override
  String get myApplicationsEmpty => 'No applications yet';

  @override
  String get myApplicationsUntitledVacancy => 'Untitled vacancy';

  @override
  String get myApplicationsStatusLabel => 'Status';

  @override
  String get myApplicationsNoteLabel => 'Note';

  @override
  String get createVacancyStepIntro => 'Enter the job title and category';

  @override
  String get createVacancyTitleLabel => 'Job title';

  @override
  String get createVacancyTitleHint => 'e.g. Evening courier shifts';

  @override
  String get createVacancySalaryFromLabel => 'Salary from (₸)';

  @override
  String get createVacancySalaryToLabel => 'Salary to (₸)';

  @override
  String get createVacancyScheduleLabel => 'Schedule';

  @override
  String get createVacancyCitySectionTitle => 'City';

  @override
  String get createVacancyCityFieldLabel => 'Job city';

  @override
  String get createVacancyCityHint => 'Select a city';

  @override
  String get createVacancyDescriptionLabel => 'Description';

  @override
  String get createVacancySubmitButton => 'Create vacancy';

  @override
  String get createVacancySubmitting => 'Saving...';

  @override
  String createVacancyOpeningsSuffix(Object slots) {
    return 'Openings: $slots';
  }

  @override
  String get companyDefaultName => 'Company';

  @override
  String get myApplicationsUpdatedPrefix => 'Updated:';

  @override
  String get companyShellVacanciesTitle => 'My vacancies';

  @override
  String get companyShellCandidatesTitle => 'All candidates';

  @override
  String get companyShellStatisticsTitle => 'Statistics';

  @override
  String get companyShellProfileTitle => 'Company profile';

  @override
  String get companyEditProfileTooltip => 'Edit';

  @override
  String get companyMenuEditProfile => 'Edit profile';

  @override
  String get companyMenuTeam => 'Team';

  @override
  String get companyMenuHelp => 'Help';

  @override
  String get companyNavVacancies => 'Jobs';

  @override
  String get companyNavCandidates => 'Candidates';

  @override
  String get companyNavStatistics => 'Stats';

  @override
  String get companyNavCompany => 'Company';

  @override
  String get companyVacancyFilterActive => 'Active';

  @override
  String get companyVacancyFilterPaused => 'Paused';

  @override
  String get companyVacanciesSearchHint => 'Search jobs…';

  @override
  String get companyVacanciesEmptyFilter => 'No jobs match this filter';

  @override
  String companyVacanciesActiveSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active listings',
      one: '$count active listing',
    );
    return '$_temp0';
  }

  @override
  String companyApplicationsShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count applications',
      one: '$count application',
    );
    return '$_temp0';
  }

  @override
  String get companyVacancyCardStatusActive => 'Active';

  @override
  String get companyVacancyCardStatusPaused => 'Paused';

  @override
  String get companyStatisticsFirestoreHint =>
      'Analytics from live Firestore data';

  @override
  String get companyCandidatesSearchHint => 'Search candidates…';

  @override
  String get companyCandidatesStatTotal => 'Total applications';

  @override
  String get companyCandidatesStatNew => 'New';

  @override
  String get companyCandidatesEmptyQuery => 'No candidates match your search';

  @override
  String get resumePreviewNoName => 'No name';

  @override
  String get vacancyEditTitle => 'Edit vacancy';

  @override
  String get vacancyMenuEdit => 'Edit';

  @override
  String get vacancyMenuPause => 'Pause';

  @override
  String get vacancyMenuResume => 'Resume';

  @override
  String get vacancyMenuDelete => 'Delete';

  @override
  String get vacancyDeleteConfirmTitle => 'Delete vacancy?';

  @override
  String get vacancyDeleteConfirmMessage =>
      'This action cannot be undone. All applications for this vacancy will be lost.';

  @override
  String get vacancyDeleteConfirmCancel => 'Cancel';

  @override
  String get vacancyDeleteConfirmDelete => 'Delete';

  @override
  String get vacancyDeletedSuccess => 'Vacancy deleted';

  @override
  String get vacancyPausedSuccess => 'Vacancy paused';

  @override
  String get vacancyResumedSuccess => 'Vacancy activated';

  @override
  String get vacancyUpdatedSuccess => 'Vacancy updated';
}
