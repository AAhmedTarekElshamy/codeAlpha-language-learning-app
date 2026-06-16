import 'dart:ui';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52E0);
  static const Color primaryLight = Color(0xFF8B85FF);

  // Accent colors
  static const Color coral = Color(0xFFFF6B6B);
  static const Color mint = Color(0xFF4ECDC4);
  static const Color gold = Color(0xFFFFD93D);
  static const Color lavender = Color(0xFFB8B5FF);

  // Dark theme background
  static const Color darkBg = Color(0xFF0F0E17);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkCardAlt = Color(0xFF1F2937);

  // Light theme background
  static const Color lightBg = Color(0xFFF8F9FE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0EEFF);

  // Text colors
  static const Color textDark = Color(0xFFE4E4E7);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFF1A1A2E);
  static const Color textLightSecondary = Color(0xFF6B7280);

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradient sets
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF8B85FF),
  ];

  static const List<Color> coralGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E8E),
  ];

  static const List<Color> mintGradient = [
    Color(0xFF4ECDC4),
    Color(0xFF71E3DC),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFFD93D),
    Color(0xFFFFE566),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0F0E17),
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
  ];

  // Category colors
  static const Color vocabColor = Color(0xFF6C63FF);
  static const Color grammarColor = Color(0xFFFF6B6B);
  static const Color phrasesColor = Color(0xFF4ECDC4);
  static const Color sentencesColor = Color(0xFFFFD93D);
}
