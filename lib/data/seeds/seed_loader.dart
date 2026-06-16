import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../models/word.dart';
import 'arabic_data.dart';
import 'english_data.dart';

class SeedLoader {
  static Future<void> seedDatabaseIfEmpty() async {
    final Box<Word> wordsBox = Hive.box<Word>(AppConstants.wordsBox);
    final supportedCodes = AppConstants.supportedLanguages.keys.toSet();

    final unsupportedKeys = wordsBox.keys.where((key) {
      final word = wordsBox.get(key);
      return word != null && !supportedCodes.contains(word.languageCode);
    }).toList();

    if (unsupportedKeys.isNotEmpty) {
      await wordsBox.deleteAll(unsupportedKeys);
    }

    final allSeeds = <Word>[...getArabicSeedData(), ...getEnglishSeedData()];

    final wordMap = {for (final word in allSeeds) word.id: word};
    await wordsBox.putAll(wordMap);
  }
}
