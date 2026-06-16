import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/settings_repository.dart';

@lazySingleton
class AiService {
  final SettingsRepository _settingsRepository;

  AiService(this._settingsRepository);

  String get _apiKey {
    final envKey = Platform.environment['GEMINI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) return envKey;
    return _settingsRepository.selectedLanguage;
  }

  String getCustomApiKey() => _settingsRepository.selectedLanguage;

  GenerativeModel? _getModel() {
    try {
      final key = _apiKey;
      if (key.length < 15) return null;
      return GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
    } catch (e) {
      debugPrint('Error creating GenerativeModel: $e');
      return null;
    }
  }

  Future<String> getDailyStudyRecommendation(
    String language,
    String proficiency,
  ) async {
    final model = _getModel();
    if (model == null) {
      return _getMockRecommendation(language, proficiency);
    }

    try {
      final languageName = _languageName(language);
      final prompt =
          'Write a short daily study suggestion for a $proficiency student learning $languageName in an Arabic-English learning app. Keep it practical, friendly, and under 250 characters.';
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? _getMockRecommendation(language, proficiency);
    } catch (e) {
      debugPrint('Gemini daily recommendation failed: $e. Using mock.');
      return _getMockRecommendation(language, proficiency);
    }
  }

  Future<String> explainGrammarRule(String language, String rule) async {
    final model = _getModel();
    if (model == null) {
      return _getMockGrammarExplanation(language, rule);
    }

    try {
      final languageName = _languageName(language);
      final prompt =
          'Explain "$rule" for a $languageName learner. Include a simple explanation, one Arabic-English example, and one quick practice tip.';
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? _getMockGrammarExplanation(language, rule);
    } catch (e) {
      debugPrint('Gemini grammar explanation failed: $e. Using mock.');
      return _getMockGrammarExplanation(language, rule);
    }
  }

  Future<String> getChatResponse(
    String language,
    String userMessage,
    List<Map<String, String>> chatHistory,
  ) async {
    final model = _getModel();
    if (model == null) {
      return _getMockChatResponse(language, userMessage);
    }

    try {
      final languageName = _languageName(language);
      final List<Content> contents = [
        Content.text(
          'You are LinguaCoach in an Arabic-English learning app. Help the student practice $languageName. Use short beginner-friendly sentences and include translations when helpful.',
        ),
      ];

      final recentHistory = chatHistory.length > 10
          ? chatHistory.sublist(chatHistory.length - 10)
          : chatHistory;

      for (final msg in recentHistory) {
        final role = msg['role'] == 'user' ? 'user' : 'model';
        contents.add(Content(role, [TextPart(msg['text'] ?? '')]));
      }

      contents.add(Content('user', [TextPart(userMessage)]));

      final response = await model.generateContent(contents);
      return response.text ?? _getMockChatResponse(language, userMessage);
    } catch (e) {
      debugPrint('Gemini chat response failed: $e. Using mock.');
      return _getMockChatResponse(language, userMessage);
    }
  }

  String _languageName(String language) =>
      language == 'en' ? 'English' : 'Arabic';

  String _getMockRecommendation(String language, String proficiency) {
    final recommendations = {
      'ar': [
        'Practice five Arabic greetings today. Say each one aloud, then write the English meaning beside it.',
        'Review Arabic letters with deep sounds like ع and ح. Listen, repeat slowly, then use one word in a sentence.',
        'Build one simple Arabic sentence: subject + verb + object. Example: أنا أقرأ كتابا (I read a book).',
      ],
      'en': [
        'Practice five useful English classroom phrases today, then translate each one into Arabic.',
        'Choose one English verb and use it in past, present, and future: I studied, I study, I will study.',
        'Read one short English sentence aloud three times. Focus on clear word endings and natural rhythm.',
      ],
    };

    final list = recommendations[language] ?? recommendations['ar']!;
    return list[DateTime.now().millisecond % list.length];
  }

  String _getMockGrammarExplanation(String language, String rule) {
    if (language == 'en') {
      return '### English: $rule\n\n'
          'English sentences usually follow subject + verb + object.\n\n'
          '**Example:** I drink water. = أنا أشرب الماء.\n\n'
          '**Practice Tip:** Write three short English sentences, then translate them into Arabic.';
    }

    return '### Arabic: $rule\n\n'
        'Arabic often changes word forms based on gender, number, and sentence role.\n\n'
        '**Example:** أنا أتعلم الإنجليزية. = I am learning English.\n\n'
        '**Practice Tip:** Read one Arabic sentence aloud, then identify the subject and verb.';
  }

  String _getMockChatResponse(String language, String message) {
    final normalized = message.trim().toLowerCase();

    if (language == 'en') {
      if (normalized.contains('hello') || normalized.contains('hi')) {
        return 'Hello! How are you today? (مرحبا! كيف حالك اليوم؟)';
      }
      if (normalized.contains('thank')) {
        return 'You are welcome. Try saying: I am learning English. (أنا أتعلم الإنجليزية.)';
      }
      return 'Good job. Can you answer in English: What did you study today?';
    }

    if (normalized.contains('مرحبا') ||
        normalized.contains('السلام') ||
        normalized.contains('marhaban')) {
      return 'مرحبا بك! كيف حالك اليوم؟ (Welcome! How are you today?)';
    }
    if (normalized.contains('شكرا') || normalized.contains('shukran')) {
      return 'عفوا! قل: أنا أتعلم العربية. (You are welcome! Say: I am learning Arabic.)';
    }
    return 'جيد جدا! هل تستطيع أن تقول جملة قصيرة بالعربية؟ (Very good! Can you say a short sentence in Arabic?)';
  }
}
