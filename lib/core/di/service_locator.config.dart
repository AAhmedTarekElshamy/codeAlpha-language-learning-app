// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/models/quiz_result.dart' as _i879;
import '../../data/models/user_progress.dart' as _i799;
import '../../data/models/word.dart' as _i504;
import '../../data/repositories/lesson_repository.dart' as _i290;
import '../../data/repositories/progress_repository.dart' as _i916;
import '../../data/repositories/settings_repository.dart' as _i373;
import '../../viewmodels/category_viewmodel.dart' as _i694;
import '../../viewmodels/flashcard_viewmodel.dart' as _i904;
import '../../viewmodels/home_viewmodel.dart' as _i298;
import '../../viewmodels/lesson_viewmodel.dart' as _i286;
import '../../viewmodels/profile_viewmodel.dart' as _i831;
import '../../viewmodels/quiz_viewmodel.dart' as _i339;
import '../services/ai_service.dart' as _i794;
import '../services/firebase_service.dart' as _i758;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i979.Box<_i504.Word>>(
      () => registerModule.wordsBox,
      preResolve: true,
    );
    await gh.singletonAsync<_i979.Box<_i799.UserProgress>>(
      () => registerModule.progressBox,
      preResolve: true,
    );
    await gh.singletonAsync<_i979.Box<_i879.QuizResult>>(
      () => registerModule.quizResultsBox,
      preResolve: true,
    );
    await gh.singletonAsync<_i979.Box<dynamic>>(
      () => registerModule.settingsBox,
      preResolve: true,
    );
    gh.singleton<_i758.FirebaseService>(() => _i758.FirebaseService());
    gh.lazySingleton<_i373.SettingsRepository>(
      () => _i373.SettingsRepository(gh<_i979.Box<dynamic>>()),
    );
    gh.lazySingleton<_i916.ProgressRepository>(
      () => _i916.ProgressRepository(
        gh<_i979.Box<_i799.UserProgress>>(),
        gh<_i979.Box<_i879.QuizResult>>(),
        gh<_i979.Box<_i504.Word>>(),
      ),
    );
    gh.lazySingleton<_i794.AiService>(
      () => _i794.AiService(gh<_i373.SettingsRepository>()),
    );
    gh.lazySingleton<_i290.LessonRepository>(
      () => _i290.LessonRepository(gh<_i979.Box<_i504.Word>>()),
    );
    gh.factory<_i694.CategoryViewModel>(
      () => _i694.CategoryViewModel(gh<_i290.LessonRepository>()),
    );
    gh.factory<_i904.FlashcardViewModel>(
      () => _i904.FlashcardViewModel(gh<_i290.LessonRepository>()),
    );
    gh.factory<_i298.HomeViewModel>(
      () => _i298.HomeViewModel(
        gh<_i373.SettingsRepository>(),
        gh<_i916.ProgressRepository>(),
        gh<_i290.LessonRepository>(),
        gh<_i794.AiService>(),
      ),
    );
    gh.factory<_i286.LessonViewModel>(
      () => _i286.LessonViewModel(
        gh<_i290.LessonRepository>(),
        gh<_i916.ProgressRepository>(),
      ),
    );
    gh.factory<_i339.QuizViewModel>(
      () => _i339.QuizViewModel(
        gh<_i290.LessonRepository>(),
        gh<_i916.ProgressRepository>(),
      ),
    );
    gh.factory<_i831.ProfileViewModel>(
      () => _i831.ProfileViewModel(
        gh<_i916.ProgressRepository>(),
        gh<_i290.LessonRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
