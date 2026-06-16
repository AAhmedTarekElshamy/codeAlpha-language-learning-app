import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../data/models/user_progress.dart';
import '../data/models/quiz_result.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/lesson_repository.dart';

@injectable
class ProfileViewModel extends ChangeNotifier {
  final ProgressRepository _progressRepository;
  final LessonRepository _lessonRepository;

  ProfileViewModel(this._progressRepository, this._lessonRepository) {
    refresh();
  }

  UserProgress _progress = UserProgress();
  UserProgress get progress => _progress;

  List<QuizResult> _quizHistory = [];
  List<QuizResult> get quizHistory => _quizHistory;

  void refresh() {
    _progress = _progressRepository.getUserProgress();
    // Refresh word count just in case
    notifyListeners();
  }

  void loadQuizHistory(String langCode) {
    _quizHistory = _progressRepository.getQuizResults(langCode);
    notifyListeners();
  }

  Future<void> resetAllProgress(String langCode) async {
    // Reset UserProgress
    final newProgress = UserProgress();
    await _progressRepository.saveUserProgress(newProgress);

    // Reset Word masteries
    final words = _lessonRepository.getWordsForLanguage(langCode);
    for (var word in words) {
      word.masteryLevel = 0;
      word.timesReviewed = 0;
      word.timesCorrect = 0;
      word.lastReviewedAt = null;
      await _lessonRepository.updateWord(word);
    }

    refresh();
    loadQuizHistory(langCode);
  }
}
