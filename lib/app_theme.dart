import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xff1F6F6B);
  static const Color backgroundColor = Color(0xffF8F5EF);
  static const Color textColor = Color(0xff282522);
  static const Color terracottaColor = Color(0xffC96F4A);

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),
    fontFamily: 'Georgia',
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(0xffE4DED5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(0xffE4DED5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    ),
  );
}