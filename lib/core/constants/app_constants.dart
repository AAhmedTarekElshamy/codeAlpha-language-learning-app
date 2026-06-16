class AppConstants {
  AppConstants._();

  static const String appName = 'Arabic English Learn';
  static const String appVersion = '1.0.0';

  // Hive box names
  static const String settingsBox = 'settings_box';
  static const String wordsBox = 'words_box';
  static const String lessonsBox = 'lessons_box';
  static const String progressBox = 'progress_box';
  static const String quizResultsBox = 'quiz_results_box';

  // Settings keys
  static const String selectedLanguageKey = 'selected_language';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String proficiencyLevelKey = 'proficiency_level';
  static const String dailyGoalKey = 'daily_goal';
  static const String currentStreakKey = 'current_streak';
  static const String lastStudyDateKey = 'last_study_date';
  static const String defaultLanguage = 'ar';

  // Daily lesson config
  static const int wordsPerLesson = 8;
  static const int quizQuestionsCount = 10;
  static const int quizTimeSeconds = 30;

  // Categories
  static const List<String> mainCategories = [
    'Vocabulary',
    'Grammar',
    'Phrases',
    'Sentences',
  ];

  static const List<String> vocabSubcategories = [
    'Food & Drinks',
    'Animals',
    'Colors',
    'Numbers',
    'Travel',
    'Family',
    'Body Parts',
    'Clothing',
    'Weather',
    'Professions',
  ];

  static const List<String> grammarSubcategories = [
    'Articles',
    'Pronouns',
    'Verb Conjugation',
    'Tenses',
    'Adjectives',
    'Prepositions',
  ];

  // Supported learning languages
  static const Map<String, String> supportedLanguages = {
    'ar': 'Arabic',
    'en': 'English',
  };

  static const Map<String, String> languageFlags = {'ar': '🇸🇦', 'en': '🇺🇸'};
}
