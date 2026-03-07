import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdd_example/src/core/constants/color/app_colors.dart';

class AppThemes {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.inter(color: AppColors.textColor),
    ),
    colorScheme: ColorScheme.light(primary: AppColors.primary),
  );

  static final ThemeData dark = ThemeData(
    textTheme: TextTheme(bodyLarge: GoogleFonts.inter(color: AppColors.white)),
    scaffoldBackgroundColor: AppColors.black,
    colorScheme: ColorScheme.dark(primary: AppColors.primary),
  );
}
