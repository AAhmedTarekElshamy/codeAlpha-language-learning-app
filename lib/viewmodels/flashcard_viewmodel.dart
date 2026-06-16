import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../data/models/word.dart';
import '../data/repositories/lesson_repository.dart';
import '../core/utils/tts_helper.dart';

@injectable
class FlashcardViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  FlashcardViewModel(this._lessonRepository);

  List<Word> _words = [];
  List<Word> get words => _words;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isFlipped = false;
  bool get isFlipped => _isFlipped;

  void loadFlashcards(String langCode, String category, {String? subcategory}) {
    if (subcategory != null && subcategory.isNotEmpty) {
      _words = _lessonRepository.getWordsBySubcategory(
        langCode,
        category,
        subcategory,
      );
    } else {
      _words = _lessonRepository.getWordsByCategory(langCode, category);
    }
    _words.shuffle();
    _currentIndex = 0;
    _isFlipped = false;
    if (_words.isNotEmpty) {
      speakCurrent();
    }
    notifyListeners();
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void nextCard() {
    if (_words.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _words.length;
    _isFlipped = false;
    speakCurrent();
    notifyListeners();
  }

  void prevCard() {
    if (_words.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _words.length) % _words.length;
    _isFlipped = false;
    speakCurrent();
    notifyListeners();
  }

  Future<void> speakCurrent() async {
    if (_words.isNotEmpty) {
      await TtsHelper().speak(_words[_currentIndex].original);
    }
  }

  Future<void> speakCurrentExample() async {
    if (_words.isNotEmpty && _words[_currentIndex].exampleSentence != null) {
      await TtsHelper().speak(_words[_currentIndex].exampleSentence!);
    }
  }

  Future<void> markCardReview(bool known) async {
    if (_words.isEmpty) return;
    final word = _words[_currentIndex];
    await _lessonRepository.markWordLearned(word.id, isCorrect: known);
    nextCard();
  }
}
