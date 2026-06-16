import 'package:hive/hive.dart';

part 'quiz_result.g.dart';

@HiveType(typeId: 1)
class QuizResult extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String languageCode;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final int correctAnswers;

  @HiveField(5)
  final int timeSpentSeconds;

  @HiveField(6)
  final DateTime completedAt;

  @HiveField(7)
  final String quizType; // 'multiple_choice', 'fill_blank', 'matching'

  QuizResult({
    required this.id,
    required this.languageCode,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeSpentSeconds,
    required this.completedAt,
    this.quizType = 'multiple_choice',
  });

  double get scorePercent =>
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

  String get grade {
    if (scorePercent >= 90) return 'A+';
    if (scorePercent >= 80) return 'A';
    if (scorePercent >= 70) return 'B';
    if (scorePercent >= 60) return 'C';
    return 'D';
  }
}
