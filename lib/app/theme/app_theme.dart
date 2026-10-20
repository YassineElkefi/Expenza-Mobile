import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_colors.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(dark: false);

  static ThemeData get dark => _buildTheme(dark: true);

  static ThemeData _buildTheme({required bool dark}) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: 'Geist',
    );

    final colors = ColorScheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: dark ? AppColors.darkAccent : AppColors.lightAccent,
      onPrimary: dark ? AppColors.darkBase : Colors.white,
      secondary: dark ? AppColors.darkChart2 : AppColors.lightChart2,
      onSecondary: dark ? AppColors.darkBase : Colors.white,
      error: dark ? AppColors.darkDanger : AppColors.lightDanger,
      onError: dark ? AppColors.darkBase : Colors.white,
      surface: dark ? AppColors.darkSurface : AppColors.lightSurface,
      onSurface: dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      outline: dark ? AppColors.darkBorder : AppColors.lightBorder,
      outlineVariant: dark
          ? AppColors.darkBorderStrong
          : AppColors.lightBorderStrong,
    );

    return base.copyWith(
      colorScheme: colors,
      scaffoldBackgroundColor: dark ? AppColors.darkBase : AppColors.lightBase,
      dividerColor: dark ? AppColors.darkBorder : AppColors.lightBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? AppColors.darkSurface : AppColors.lightSurface,
        foregroundColor: dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: dark ? AppColors.darkSurface : AppColors.lightSurface,
        indicatorColor: dark
            ? AppColors.darkAccentMuted
            : AppColors.lightAccentSubtle,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : dark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colors.primary
                : dark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.darkSurface : AppColors.lightSurface,
        hintStyle: TextStyle(
          color: dark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}
