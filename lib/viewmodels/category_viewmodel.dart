import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../data/models/word.dart';
import '../data/repositories/lesson_repository.dart';
import '../core/constants/app_constants.dart';

@injectable
class CategoryViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  CategoryViewModel(this._lessonRepository);

  String _selectedCategory = 'Vocabulary';
  String get selectedCategory => _selectedCategory;

  List<String> get subcategories {
    if (_selectedCategory == 'Vocabulary') {
      return AppConstants.vocabSubcategories;
    } else if (_selectedCategory == 'Grammar') {
      return AppConstants.grammarSubcategories;
    } else if (_selectedCategory == 'Phrases') {
      return ['Greetings', 'Directions', 'Shopping', 'Travel', 'Emergency'];
    } else {
      return ['General', 'Interrogative', 'Declarative'];
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  int getWordCount(String langCode, String category, {String? subcategory}) {
    if (subcategory != null && subcategory.isNotEmpty) {
      return _lessonRepository
          .getWordsBySubcategory(langCode, category, subcategory)
          .length;
    }
    return _lessonRepository.getWordsByCategory(langCode, category).length;
  }

  double getCategoryMastery(
    String langCode,
    String category, {
    String? subcategory,
  }) {
    List<Word> words = [];
    if (subcategory != null && subcategory.isNotEmpty) {
      words = _lessonRepository.getWordsBySubcategory(
        langCode,
        category,
        subcategory,
      );
    } else {
      words = _lessonRepository.getWordsByCategory(langCode, category);
    }

    if (words.isEmpty) return 0.0;

    int totalMastery = words.fold(0, (sum, w) => sum + w.masteryLevel);
    double maxPossibleMastery = words.length * 3.0; // 3 is max mastery level
    return totalMastery / maxPossibleMastery;
  }
}
