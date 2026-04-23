// Слой: core | Назначение: дизайн-система приложения (light/dark + токены)

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Geist',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF7C3AED),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFFF97316),
          onSecondary: Color(0xFFFFFFFF),
          error: Color(0xFFEF4444),
          onError: Color(0xFFFFFFFF),
          surface: Color(0xFFF9F9FC),
          onSurface: Color(0xFF251F2E),
          outline: Color(0xFFE4E0EA),
          tertiary: Color(0xFF22C55E),
          onTertiary: Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9FC),
        textTheme: _textTheme(Brightness.light),
        extensions: const [AppColors.light],
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF0EEF5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFFE4E0EA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFFE4E0EA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFF7C3AED)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFFFFFF),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Geist',
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFA78BFA),
          onPrimary: Color(0xFF0F0D1A),
          secondary: Color(0xFFFB923C),
          onSecondary: Color(0xFF0F0D1A),
          error: Color(0xFFEF4444),
          onError: Color(0xFF0F0D1A),
          surface: Color(0xFF0F0D1A),
          onSurface: Color(0xFFF5F3FF),
          outline: Color(0xFF312D45),
          tertiary: Color(0xFF4ADE80),
          onTertiary: Color(0xFF0F0D1A),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0D1A),
        textTheme: _textTheme(Brightness.dark),
        extensions: const [AppColors.dark],
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF211E30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFF312D45)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFF312D45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            borderSide: BorderSide(color: Color(0xFFA78BFA)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1726),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;

    return base.copyWith(
      headlineLarge: const TextStyle(
        fontSize: AppTypography.pageTitle,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: const TextStyle(
        fontSize: AppTypography.sectionTitle,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: const TextStyle(
        fontSize: AppTypography.cardTitle,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        fontSize: AppTypography.body,
      ),
      bodyMedium: const TextStyle(
        fontSize: AppTypography.bodySmall,
      ),
      bodySmall: const TextStyle(
        fontSize: AppTypography.caption,
      ),
    );
  }
}

class AppTypography {
  AppTypography._();

  static const double pageTitle = 24;
  static const double sectionTitle = 20;
  static const double cardTitle = 18;
  static const double body = 16;
  static const double bodySmall = 14;
  static const double caption = 12;
}

class AppRadius {
  AppRadius._();

  static const double sm = 12;
  static const double md = 16;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.muted,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.primary,
    required this.accent,
    required this.success,
    required this.warning,
    required this.destructive,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.navBackground,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color muted;
  final Color mutedForeground;
  final Color border;
  final Color input;
  final Color primary;
  final Color accent;
  final Color success;
  final Color warning;
  final Color destructive;
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;
  final Color navBackground;

  static const AppColors light = AppColors(
    background: Color(0xFFF9F9FC),
    foreground: Color(0xFF251F2E),
    card: Color(0xFFFFFFFF),
    muted: Color(0xFFF0EEF5),
    mutedForeground: Color(0xFF6C647C),
    border: Color(0xFFE4E0EA),
    input: Color(0xFFF0EEF5),
    primary: Color(0xFF7C3AED),
    accent: Color(0xFFF97316),
    success: Color(0xFF22C55E),
    warning: Color(0xFFEAB308),
    destructive: Color(0xFFEF4444),
    chart1: Color(0xFF7C3AED),
    chart2: Color(0xFF9472EB),
    chart3: Color(0xFFB4A0ED),
    chart4: Color(0xFFF97316),
    chart5: Color(0xFF14B8A6),
    navBackground: Color(0xFFF6F7FB),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF0F0D1A),
    foreground: Color(0xFFF5F3FF),
    card: Color(0xFF1A1726),
    muted: Color(0xFF211E30),
    mutedForeground: Color(0xFF9CA3AF),
    border: Color(0xFF312D45),
    input: Color(0xFF211E30),
    primary: Color(0xFFA78BFA),
    accent: Color(0xFFFB923C),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFDE047),
    destructive: Color(0xFFEF4444),
    chart1: Color(0xFFA78BFA),
    chart2: Color(0xFF8B5CF6),
    chart3: Color(0xFFC4B5FD),
    chart4: Color(0xFFFB923C),
    chart5: Color(0xFF34D399),
    navBackground: Color(0xFF171428),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? foreground,
    Color? card,
    Color? muted,
    Color? mutedForeground,
    Color? border,
    Color? input,
    Color? primary,
    Color? accent,
    Color? success,
    Color? warning,
    Color? destructive,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? navBackground,
  }) {
    return AppColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      destructive: destructive ?? this.destructive,
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
      navBackground: navBackground ?? this.navBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
    );
  }
}

extension AppThemeContextX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
