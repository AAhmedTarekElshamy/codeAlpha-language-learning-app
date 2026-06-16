import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../core/constants/app_constants.dart';
import '../core/services/ai_service.dart';
import '../core/utils/tts_helper.dart';
import '../data/models/user_progress.dart';
import '../data/models/word.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/settings_repository.dart';

@injectable
class HomeViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final ProgressRepository _progressRepository;
  final LessonRepository _lessonRepository;
  final AiService _aiService;

  HomeViewModel(
    this._settingsRepository,
    this._progressRepository,
    this._lessonRepository,
    this._aiService,
  ) {
    _loadProgress();
  }

  UserProgress _progress = UserProgress();
  UserProgress get progress => _progress;

  String get selectedLanguage => _settingsRepository.selectedLanguage;
  String get selectedLanguageName =>
      AppConstants.supportedLanguages[selectedLanguage] ?? 'Arabic';
  String get selectedLanguageFlag =>
      AppConstants.languageFlags[selectedLanguage] ?? '🇸🇦';

  bool get isDarkMode => _settingsRepository.isDarkMode;

  List<Word> _dailyLessonWords = [];
  List<Word> get dailyLessonWords => _dailyLessonWords;

  String _aiRecommendation = 'Loading daily study recommendation...';
  String get aiRecommendation => _aiRecommendation;

  bool _isLoadingRecommendation = false;
  bool get isLoadingRecommendation => _isLoadingRecommendation;

  Future<void> loadRecommendation() async {
    _isLoadingRecommendation = true;
    notifyListeners();
    try {
      _aiRecommendation = await _aiService.getDailyStudyRecommendation(
        selectedLanguage,
        _settingsRepository.proficiencyLevel,
      );
    } catch (e) {
      _aiRecommendation =
          'Practice one Arabic phrase and one English sentence today.';
    } finally {
      _isLoadingRecommendation = false;
      notifyListeners();
    }
  }

  void _loadProgress() {
    _progress = _progressRepository.getUserProgress();
    _loadDailyLesson();
    loadRecommendation();
    notifyListeners();
  }

  void _loadDailyLesson() {
    _dailyLessonWords = _lessonRepository.getDailyLessonWords(selectedLanguage);
  }

  Future<void> changeLanguage(String langCode) async {
    await _settingsRepository.setSelectedLanguage(langCode);
    await TtsHelper().setLanguage(langCode);
    _loadDailyLesson();
    _loadProgress();
  }

  Future<void> toggleDarkMode() async {
    await _settingsRepository.setDarkMode(!isDarkMode);
    notifyListeners();
  }

  void refresh() {
    _loadProgress();
  }

  int get masteredWordsCount {
    return _lessonRepository
        .getWordsForLanguage(selectedLanguage)
        .where((w) => w.masteryLevel >= 3)
        .length;
  }

  int get learningWordsCount {
    return _lessonRepository
        .getWordsForLanguage(selectedLanguage)
        .where((w) => w.masteryLevel > 0 && w.masteryLevel < 3)
        .length;
  }
}
