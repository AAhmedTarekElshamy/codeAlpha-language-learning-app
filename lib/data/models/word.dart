import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String original;

  @HiveField(2)
  final String translation;

  @HiveField(3)
  final String pronunciation;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String subcategory;

  @HiveField(6)
  final String languageCode;

  @HiveField(7)
  final String? exampleSentence;

  @HiveField(8)
  final String? exampleTranslation;

  @HiveField(9)
  int masteryLevel; // 0=new, 1=learning, 2=familiar, 3=mastered

  @HiveField(10)
  int timesReviewed;

  @HiveField(11)
  int timesCorrect;

  @HiveField(12)
  DateTime? lastReviewedAt;

  Word({
    required this.id,
    required this.original,
    required this.translation,
    this.pronunciation = '',
    required this.category,
    this.subcategory = '',
    required this.languageCode,
    this.exampleSentence,
    this.exampleTranslation,
    this.masteryLevel = 0,
    this.timesReviewed = 0,
    this.timesCorrect = 0,
    this.lastReviewedAt,
  });

  double get accuracy => timesReviewed > 0 ? timesCorrect / timesReviewed : 0.0;

  bool get isMastered => masteryLevel >= 3;

  Word copyWith({
    int? masteryLevel,
    int? timesReviewed,
    int? timesCorrect,
    DateTime? lastReviewedAt,
  }) {
    return Word(
      id: id,
      original: original,
      translation: translation,
      pronunciation: pronunciation,
      category: category,
      subcategory: subcategory,
      languageCode: languageCode,
      exampleSentence: exampleSentence,
      exampleTranslation: exampleTranslation,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }
}
