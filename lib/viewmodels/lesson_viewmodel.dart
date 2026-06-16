import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../data/models/word.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../core/utils/tts_helper.dart';

@injectable
class LessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;
  final ProgressRepository _progressRepository;

  LessonViewModel(this._lessonRepository, this._progressRepository);

  List<Word> _words = [];
  List<Word> get words => _words;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isFlipped = false;
  bool get isFlipped => _isFlipped;

  bool _isLessonCompleted = false;
  bool get isLessonCompleted => _isLessonCompleted;

  void startLesson(List<Word> lessonWords) {
    _words = lessonWords;
    _currentIndex = 0;
    _isFlipped = false;
    _isLessonCompleted = false;
    if (_words.isNotEmpty) {
      speakCurrentWord();
    }
    notifyListeners();
  }

  void flipCard() {
    _isFlipped = !_isFlipped;
    notifyListeners();
  }

  void nextWord() {
    if (_currentIndex < _words.length - 1) {
      _currentIndex++;
      _isFlipped = false;
      speakCurrentWord();
    } else {
      _isLessonCompleted = true;
      _completeLesson();
    }
    notifyListeners();
  }

  void previousWord() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _isFlipped = false;
      speakCurrentWord();
    }
    notifyListeners();
  }

  Future<void> speakCurrentWord() async {
    if (_words.isNotEmpty) {
      await TtsHelper().speak(_words[_currentIndex].original);
    }
  }

  Future<void> speakCurrentExample() async {
    if (_words.isNotEmpty && _words[_currentIndex].exampleSentence != null) {
      await TtsHelper().speak(_words[_currentIndex].exampleSentence!);
    }
  }

  Future<void> markCurrentWordMastery(bool known) async {
    final word = _words[_currentIndex];
    await _lessonRepository.markWordLearned(word.id, isCorrect: known);
    nextWord();
  }

  Future<void> _completeLesson() async {
    await _progressRepository.recordSimpleStudy();
  }
}
