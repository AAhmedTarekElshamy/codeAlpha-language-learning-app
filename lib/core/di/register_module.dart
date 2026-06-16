import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';
import '../../data/models/word.dart';
import '../../data/models/user_progress.dart';
import '../../data/models/quiz_result.dart';

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<Box<Word>> get wordsBox async =>
      Hive.openBox<Word>(AppConstants.wordsBox);

  @preResolve
  @singleton
  Future<Box<UserProgress>> get progressBox async =>
      Hive.openBox<UserProgress>(AppConstants.progressBox);

  @preResolve
  @singleton
  Future<Box<QuizResult>> get quizResultsBox async =>
      Hive.openBox<QuizResult>(AppConstants.quizResultsBox);

  @preResolve
  @singleton
  Future<Box> get settingsBox async => Hive.openBox(AppConstants.settingsBox);
}
