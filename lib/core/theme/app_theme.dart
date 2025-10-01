import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary(context),
      secondary: AppColors.secondary(context),
      surface: AppColors.surface(context),
      error: AppColors.notificationColor(context),
    ),
    scaffoldBackgroundColor: AppColors.surface(context),
    textTheme: TextTheme(
      titleLarge: AppTextStyle.header(context),
      titleMedium: AppTextStyle.bodyLarge(context),
      bodyMedium: AppTextStyle.bodyMedium(context),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface(context),
      foregroundColor: AppColors.textColor(context),
      elevation: 0,
    ),
  );

  static ThemeData dark(BuildContext context) => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary(context),
      secondary: AppColors.secondary(context),
      surface: AppColors.surface(context),
      error: AppColors.notificationColor(context),
    ),
    scaffoldBackgroundColor: AppColors.surface(context),
    textTheme: TextTheme(
      titleLarge: AppTextStyle.header(context),
      titleMedium: AppTextStyle.bodyLarge(context),
      bodyMedium: AppTextStyle.bodyMedium(context),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface(context),
      foregroundColor: AppColors.textColor(context),
      elevation: 0,
    ),
  );
}
