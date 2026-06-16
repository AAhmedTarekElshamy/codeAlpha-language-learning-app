import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../data/models/word.dart';
import '../data/models/quiz_result.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/progress_repository.dart';

class QuizQuestion {
  final Word word;
  final String questionText;
  final String correctAnswer;
  final List<String> options;
  String? selectedAnswer;
  bool? isCorrect;

  QuizQuestion({
    required this.word,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
    this.selectedAnswer,
    this.isCorrect,
  });
}

@injectable
class QuizViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;
  final ProgressRepository _progressRepository;

  QuizViewModel(this._lessonRepository, this._progressRepository);

  List<QuizQuestion> _questions = [];
  List<QuizQuestion> get questions => _questions;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  int _correctCount = 0;
  int get correctCount => _correctCount;

  bool _isQuizCompleted = false;
  bool get isQuizCompleted => _isQuizCompleted;

  int _timeLeft = 30;
  int get timeLeft => _timeLeft;

  Timer? _timer;
  int _timeSpentSeconds = 0;
  int get timeSpentSeconds => _timeSpentSeconds;

  String _currentCategory = 'General';
  String _currentLangCode = 'ar';

  void startQuiz(String langCode, String category, {String? subcategory}) {
    _currentLangCode = langCode;
    _currentCategory = category;

    List<Word> sourceWords = [];
    if (subcategory != null && subcategory.isNotEmpty) {
      sourceWords = _lessonRepository.getWordsBySubcategory(
        langCode,
        category,
        subcategory,
      );
    } else {
      sourceWords = _lessonRepository.getWordsByCategory(langCode, category);
    }

    if (sourceWords.isEmpty) {
      sourceWords = _lessonRepository.getWordsForLanguage(langCode);
    }

    if (sourceWords.isEmpty) {
      _questions = [];
      _isQuizCompleted = true;
      notifyListeners();
      return;
    }

    sourceWords.shuffle();
    final quizSize = sourceWords.length < 10 ? sourceWords.length : 10;
    final selectedWords = sourceWords.take(quizSize).toList();

    final allWordsForLanguage = _lessonRepository.getWordsForLanguage(langCode);

    _questions = selectedWords.map((word) {
      final isWordToTranslation = DateTime.now().millisecond % 2 == 0;
      final questionText = isWordToTranslation
          ? 'What does "${word.original}" mean?'
          : 'How do you say "${word.translation}"?';
      final correctAnswer = isWordToTranslation
          ? word.translation
          : word.original;

      final Set<String> optionsSet = {correctAnswer};

      final distractors =
          allWordsForLanguage.where((w) => w.id != word.id).toList()..shuffle();

      for (var d in distractors) {
        if (optionsSet.length >= 4) break;
        optionsSet.add(isWordToTranslation ? d.translation : d.original);
      }

      final optionsList = optionsSet.toList()..shuffle();

      return QuizQuestion(
        word: word,
        questionText: questionText,
        correctAnswer: correctAnswer,
        options: optionsList,
      );
    }).toList();

    _currentIndex = 0;
    _correctCount = 0;
    _isQuizCompleted = false;
    _timeSpentSeconds = 0;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeSpentSeconds++;
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        submitAnswer(''); // Auto-submit wrong answer if time runs out
      }
    });
  }

  Future<void> submitAnswer(String answer) async {
    if (_isQuizCompleted || _questions.isEmpty) return;

    final currentQuestion = _questions[_currentIndex];
    if (currentQuestion.selectedAnswer != null) return; // Already answered

    currentQuestion.selectedAnswer = answer;
    final correct =
        answer.trim().toLowerCase() ==
        currentQuestion.correctAnswer.trim().toLowerCase();
    currentQuestion.isCorrect = correct;

    if (correct) {
      _correctCount++;
    }

    // Update word mastery logic in repository
    await _lessonRepository.markWordLearned(
      currentQuestion.word.id,
      isCorrect: correct,
    );

    _timer?.cancel();
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _startTimer();
    } else {
      _completeQuiz();
    }
    notifyListeners();
  }

  Future<void> _completeQuiz() async {
    _isQuizCompleted = true;
    _timer?.cancel();

    final result = QuizResult(
      id: '',
      languageCode: _currentLangCode,
      category: _currentCategory,
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      timeSpentSeconds: _timeSpentSeconds,
      completedAt: DateTime.now(),
    );

    await _progressRepository.recordQuiz(result);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
