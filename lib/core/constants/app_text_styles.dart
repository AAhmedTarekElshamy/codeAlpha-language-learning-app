import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings - Outfit font
  static TextStyle heading1({bool isDark = true}) => GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: isDark ? AppColors.textDark : AppColors.textLight,
    letterSpacing: -0.5,
  );

  static TextStyle heading2({bool isDark = true}) => GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.textDark : AppColors.textLight,
    letterSpacing: -0.3,
  );

  static TextStyle heading3({bool isDark = true}) => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.textDark : AppColors.textLight,
  );

  // Body - Inter font
  static TextStyle bodyLarge({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColors.textDark : AppColors.textLight,
    height: 1.5,
  );

  static TextStyle bodyMedium({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
  );

  // Labels
  static TextStyle label({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle labelLarge({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: isDark ? AppColors.textDark : AppColors.textLight,
  );

  // Button text
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  // Special
  static TextStyle flashcardWord = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static TextStyle flashcardTranslation = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  static TextStyle streakNumber = GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.gold,
  );

  static TextStyle quizOption({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: isDark ? AppColors.textDark : AppColors.textLight,
  );

  static TextStyle statValue({bool isDark = true}) => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: isDark ? AppColors.textDark : AppColors.textLight,
  );

  static TextStyle statLabel({bool isDark = true}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
    letterSpacing: 0.3,
  );
}
