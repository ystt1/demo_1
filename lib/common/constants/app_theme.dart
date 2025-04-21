import 'package:demo_1/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.zero,
    ),
    dividerColor: Colors.transparent,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    appBarTheme: AppBarTheme(
      color: AppColors.backgroundColor,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
