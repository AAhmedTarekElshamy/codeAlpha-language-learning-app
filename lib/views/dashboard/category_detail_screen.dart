import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../views/shared/animated_gradient_bg.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/flashcard_viewmodel.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import '../../core/di/service_locator.dart';
import '../lessons/lesson_screen.dart';
import '../quiz/quiz_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  final String languageCode;
  final String languageName;

  const CategoryDetailScreen({
    super.key,
    required this.category,
    required this.languageCode,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    Color themeColor;
    switch (category) {
      case 'Vocabulary':
        themeColor = AppColors.vocabColor;
        break;
      case 'Grammar':
        themeColor = AppColors.grammarColor;
        break;
      case 'Phrases':
        themeColor = AppColors.phrasesColor;
        break;
      default:
        themeColor = AppColors.sentencesColor;
        break;
    }

    return ChangeNotifierProvider<CategoryViewModel>(
      create: (_) => getIt<CategoryViewModel>()..selectCategory(category),
      child: Scaffold(
        body: AnimatedGradientBg(
          child: SafeArea(
            child: Consumer<CategoryViewModel>(
              builder: (context, catViewModel, child) {
                final subs = catViewModel.subcategories;

                return Column(
                  children: [
                    // Header Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Learning in $languageName',
                                  style: const TextStyle(
                                    color: AppColors.textDarkSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Main list
                    Expanded(
                      child: subs.isEmpty
                          ? const Center(
                              child: Text(
                                'No subcategories available.',
                                style: TextStyle(
                                  color: AppColors.textDarkSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              itemCount: subs.length,
                              itemBuilder: (context, index) {
                                final sub = subs[index];
                                final count = catViewModel.getWordCount(
                                  languageCode,
                                  category,
                                  subcategory: sub,
                                );
                                final progress = catViewModel
                                    .getCategoryMastery(
                                      languageCode,
                                      category,
                                      subcategory: sub,
                                    );

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.darkSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: themeColor.withValues(alpha: 0.25),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  sub,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '$count items',
                                                  style: const TextStyle(
                                                    color: AppColors
                                                        .textDarkSecondary,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '${(progress * 100).toInt()}%',
                                            style: TextStyle(
                                              color: themeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.05),
                                          color: themeColor,
                                          minHeight: 6,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                ).child(
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          themeColor.withValues(
                                                            alpha: 0.15,
                                                          ),
                                                      foregroundColor:
                                                          themeColor,
                                                      side: BorderSide(
                                                        color: themeColor
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: count == 0
                                                        ? null
                                                        : () =>
                                                              _startFlashcards(
                                                                context,
                                                                sub,
                                                              ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.style_rounded,
                                                          size: 18,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text('Flashcards'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: themeColor,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                              onPressed: count == 0
                                                  ? null
                                                  : () => _startQuiz(
                                                      context,
                                                      sub,
                                                    ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.quiz_rounded,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('Take Quiz'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _startFlashcards(BuildContext context, String subcategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<FlashcardViewModel>(
          create: (_) => getIt<FlashcardViewModel>()
            ..loadFlashcards(languageCode, category, subcategory: subcategory),
          child: LessonScreen(
            category: category,
            subcategory: subcategory,
            languageCode: languageCode,
          ),
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, String subcategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<QuizViewModel>(
          create: (_) =>
              getIt<QuizViewModel>()
                ..startQuiz(languageCode, category, subcategory: subcategory),
          child: QuizScreen(
            category: category,
            subcategory: subcategory,
            languageCode: languageCode,
          ),
        ),
      ),
    );
  }
}

// Extension to avoid styling issues in dart compilation
extension on ButtonStyle {
  Widget child(Widget child) => child;
}
