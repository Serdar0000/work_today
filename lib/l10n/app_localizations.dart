import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Template App'**
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
  /// **'24.5 MB'**
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
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
