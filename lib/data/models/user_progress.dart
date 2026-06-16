import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 2)
class UserProgress extends HiveObject {
  @HiveField(0)
  int currentStreak;

  @HiveField(1)
  int longestStreak;

  @HiveField(2)
  int totalWordsLearned;

  @HiveField(3)
  int totalQuizzesTaken;

  @HiveField(4)
  int totalCorrectAnswers;

  @HiveField(5)
  int totalQuestionsAnswered;

  @HiveField(6)
  DateTime? lastStudyDate;

  @HiveField(7)
  List<String> studyDates; // ISO date strings for streak calendar

  @HiveField(8)
  int dailyXp;

  @HiveField(9)
  int totalXp;

  @HiveField(10)
  List<String> achievements;

  UserProgress({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalWordsLearned = 0,
    this.totalQuizzesTaken = 0,
    this.totalCorrectAnswers = 0,
    this.totalQuestionsAnswered = 0,
    this.lastStudyDate,
    List<String>? studyDates,
    this.dailyXp = 0,
    this.totalXp = 0,
    List<String>? achievements,
  }) : studyDates = studyDates ?? [],
       achievements = achievements ?? [];

  double get overallAccuracy => totalQuestionsAnswered > 0
      ? (totalCorrectAnswers / totalQuestionsAnswered) * 100
      : 0;

  int get level => (totalXp / 100).floor() + 1;

  double get levelProgress => (totalXp % 100) / 100;

  void recordStudySession() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (!studyDates.contains(today)) {
      studyDates.add(today);
    }

    if (lastStudyDate != null) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final lastDate = lastStudyDate!.toIso8601String().substring(0, 10);
      final yesterdayStr = yesterday.toIso8601String().substring(0, 10);

      if (lastDate == yesterdayStr || lastDate == today) {
        if (lastDate == yesterdayStr) {
          currentStreak++;
        }
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    lastStudyDate = DateTime.now();
  }

  void addXp(int xp) {
    dailyXp += xp;
    totalXp += xp;
  }

  void checkAchievements() {
    if (totalWordsLearned >= 10 && !achievements.contains('first_10_words')) {
      achievements.add('first_10_words');
    }
    if (totalWordsLearned >= 50 && !achievements.contains('word_collector')) {
      achievements.add('word_collector');
    }
    if (totalWordsLearned >= 100 &&
        !achievements.contains('vocabulary_master')) {
      achievements.add('vocabulary_master');
    }
    if (currentStreak >= 3 && !achievements.contains('streak_starter')) {
      achievements.add('streak_starter');
    }
    if (currentStreak >= 7 && !achievements.contains('week_warrior')) {
      achievements.add('week_warrior');
    }
    if (currentStreak >= 30 && !achievements.contains('monthly_champion')) {
      achievements.add('monthly_champion');
    }
    if (totalQuizzesTaken >= 5 && !achievements.contains('quiz_taker')) {
      achievements.add('quiz_taker');
    }
    if (overallAccuracy >= 90 &&
        totalQuestionsAnswered >= 20 &&
        !achievements.contains('accuracy_star')) {
      achievements.add('accuracy_star');
    }
  }
}
