import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../models/word.dart';
import '../../core/constants/app_constants.dart';

@lazySingleton
class LessonRepository {
  final Box<Word> _wordsBox;

  LessonRepository(this._wordsBox);

  List<Word> getWordsForLanguage(String langCode) {
    return _wordsBox.values.where((w) => w.languageCode == langCode).toList();
  }

  List<Word> getWordsByCategory(String langCode, String category) {
    return _wordsBox.values
        .where((w) => w.languageCode == langCode && w.category == category)
        .toList();
  }

  List<Word> getWordsBySubcategory(
    String langCode,
    String category,
    String subcategory,
  ) {
    return _wordsBox.values
        .where(
          (w) =>
              w.languageCode == langCode &&
              w.category == category &&
              w.subcategory == subcategory,
        )
        .toList();
  }

  List<Word> getDailyLessonWords(String langCode) {
    final allWords = getWordsForLanguage(langCode);

    // Prioritize words that are new or still being learned (masteryLevel < 3)
    final reviewWords = allWords.where((w) => w.masteryLevel < 3).toList();

    // If we don't have enough review words, grab some familiar/mastered words
    if (reviewWords.length < AppConstants.wordsPerLesson) {
      final masteredWords = allWords.where((w) => w.masteryLevel >= 3).toList();
      reviewWords.addAll(
        masteredWords.take(AppConstants.wordsPerLesson - reviewWords.length),
      );
    }

    // Return the required count
    return reviewWords.take(AppConstants.wordsPerLesson).toList();
  }

  Future<void> updateWord(Word word) async {
    await _wordsBox.put(word.id, word);
  }

  Future<void> markWordLearned(String wordId, {required bool isCorrect}) async {
    final word = _wordsBox.get(wordId);
    if (word != null) {
      word.timesReviewed += 1;
      if (isCorrect) {
        word.timesCorrect += 1;
        if (word.masteryLevel < 3) {
          word.masteryLevel += 1;
        }
      } else {
        if (word.masteryLevel > 0) {
          word.masteryLevel -= 1;
        }
      }
      word.lastReviewedAt = DateTime.now();
      await word.save();
    }
  }
}
