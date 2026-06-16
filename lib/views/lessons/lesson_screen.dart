import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/flashcard_viewmodel.dart';

class LessonScreen extends StatelessWidget {
  final String category;
  final String subcategory;
  final String languageCode;

  const LessonScreen({
    super.key,
    required this.category,
    required this.subcategory,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subcategory.isEmpty ? category : subcategory),
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.darkBg,
      body: Consumer<FlashcardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.words.isEmpty) {
            return const Center(
              child: Text(
                'No flashcards available.',
                style: TextStyle(color: AppColors.textDarkSecondary),
              ),
            );
          }

          final word = viewModel.words[viewModel.currentIndex];

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value:
                        (viewModel.currentIndex + 1) / viewModel.words.length,
                    backgroundColor: Colors.white12,
                    color: AppColors.mint,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${viewModel.currentIndex + 1} of ${viewModel.words.length}',
                    style: const TextStyle(color: AppColors.textDarkSecondary),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GestureDetector(
                      onTap: viewModel.flipCard,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          key: ValueKey(viewModel.isFlipped),
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                viewModel.isFlipped
                                    ? Icons.translate_rounded
                                    : Icons.record_voice_over_rounded,
                                color: AppColors.primaryLight,
                                size: 42,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                viewModel.isFlipped
                                    ? word.translation
                                    : word.original,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!viewModel.isFlipped &&
                                  word.pronunciation.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  word.pronunciation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textDarkSecondary,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                              if (viewModel.isFlipped &&
                                  word.exampleSentence != null) ...[
                                const SizedBox(height: 18),
                                Text(
                                  word.exampleSentence!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textDarkSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: viewModel.prevCard,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => viewModel.markCardReview(false),
                          icon: const Icon(Icons.close_rounded),
                          label: const Text('Review'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => viewModel.markCardReview(true),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Know it'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: viewModel.nextCard,
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
