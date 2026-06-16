import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

@lazySingleton
class SettingsRepository {
  final Box _box;

  SettingsRepository(this._box);

  String get selectedLanguage {
    final saved = _box.get(
      AppConstants.selectedLanguageKey,
      defaultValue: AppConstants.defaultLanguage,
    );
    return AppConstants.supportedLanguages.containsKey(saved)
        ? saved
        : AppConstants.defaultLanguage;
  }

  Future<void> setSelectedLanguage(String langCode) async {
    await _box.put(AppConstants.selectedLanguageKey, langCode);
  }

  bool get isDarkMode =>
      _box.get(AppConstants.isDarkModeKey, defaultValue: true);

  Future<void> setDarkMode(bool value) async {
    await _box.put(AppConstants.isDarkModeKey, value);
  }

  bool get isOnboardingComplete =>
      _box.get(AppConstants.onboardingCompleteKey, defaultValue: false);

  Future<void> setOnboardingComplete(bool value) async {
    await _box.put(AppConstants.onboardingCompleteKey, value);
  }

  String get proficiencyLevel =>
      _box.get(AppConstants.proficiencyLevelKey, defaultValue: 'Beginner');

  Future<void> setProficiencyLevel(String level) async {
    await _box.put(AppConstants.proficiencyLevelKey, level);
  }

  int get dailyGoal => _box.get(AppConstants.dailyGoalKey, defaultValue: 10);

  Future<void> setDailyGoal(int goal) async {
    await _box.put(AppConstants.dailyGoalKey, goal);
  }
}
