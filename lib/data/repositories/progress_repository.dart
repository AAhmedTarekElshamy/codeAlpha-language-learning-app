import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/user_progress.dart';
import '../models/quiz_result.dart';
import '../models/word.dart';

@lazySingleton
class ProgressRepository {
  final Box<UserProgress> _progressBox;
  final Box<QuizResult> _quizResultsBox;
  final Box<Word> _wordsBox;

  ProgressRepository(this._progressBox, this._quizResultsBox, this._wordsBox);

  UserProgress getUserProgress() {
    if (_progressBox.isEmpty) {
      final newProgress = UserProgress();
      _progressBox.put('current_user_progress', newProgress);
      return newProgress;
    }
    return _progressBox.get('current_user_progress') ?? UserProgress();
  }

  Future<void> saveUserProgress(UserProgress progress) async {
    progress.totalWordsLearned = _wordsBox.values
        .where((w) => w.masteryLevel >= 3)
        .length;
    progress.checkAchievements();
    await _progressBox.put('current_user_progress', progress);
  }

  List<QuizResult> getQuizResults(String langCode) {
    return _quizResultsBox.values
        .where((r) => r.languageCode == langCode)
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  Future<void> recordQuiz(QuizResult result) async {
    final uuid = const Uuid().v4();
    final newResult = QuizResult(
      id: uuid,
      languageCode: result.languageCode,
      category: result.category,
      totalQuestions: result.totalQuestions,
      correctAnswers: result.correctAnswers,
      timeSpentSeconds: result.timeSpentSeconds,
      completedAt: DateTime.now(),
      quizType: result.quizType,
    );
    await _quizResultsBox.put(uuid, newResult);

    // Update user progress metrics
    final progress = getUserProgress();
    progress.totalQuizzesTaken += 1;
    progress.totalQuestionsAnswered += result.totalQuestions;
    progress.totalCorrectAnswers += result.correctAnswers;

    // Award XP: 10 XP for completion, 5 XP per correct answer
    final xpEarned = 10 + (result.correctAnswers * 5);
    progress.addXp(xpEarned);

    progress.recordStudySession();
    await saveUserProgress(progress);
  }

  Future<void> recordSimpleStudy() async {
    final progress = getUserProgress();
    progress.addXp(15); // Study session gives 15 XP
    progress.recordStudySession();
    await saveUserProgress(progress);
  }
}
