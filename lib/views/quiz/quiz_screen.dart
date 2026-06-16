import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/quiz_viewmodel.dart';

class QuizScreen extends StatelessWidget {
  final String category;
  final String subcategory;
  final String languageCode;

  const QuizScreen({
    super.key,
    required this.category,
    required this.subcategory,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          subcategory.isEmpty ? '$category Quiz' : '$subcategory Quiz',
        ),
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<QuizViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.questions.isEmpty) {
              return const Center(
                child: Text(
                  'No quiz questions available.',
                  style: TextStyle(color: AppColors.textDarkSecondary),
                ),
              );
            }

            if (viewModel.isQuizCompleted) {
              return _QuizComplete(viewModel: viewModel);
            }

            final question = viewModel.questions[viewModel.currentIndex];
            final answered = question.selectedAnswer != null;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${viewModel.currentIndex + 1}/${viewModel.questions.length}',
                        style: const TextStyle(
                          color: AppColors.textDarkSecondary,
                        ),
                      ),
                      Chip(
                        avatar: const Icon(Icons.timer_rounded, size: 18),
                        label: Text('${viewModel.timeLeft}s'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value:
                        (viewModel.currentIndex + 1) /
                        viewModel.questions.length,
                    backgroundColor: Colors.white12,
                    color: AppColors.gold,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...question.options.map((option) {
                    final isSelected = question.selectedAnswer == option;
                    final isCorrect = question.correctAnswer == option;
                    final color = answered
                        ? isCorrect
                              ? AppColors.success
                              : isSelected
                              ? AppColors.error
                              : AppColors.darkCard
                        : AppColors.darkCard;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          backgroundColor: color.withValues(alpha: 0.18),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: color.withValues(alpha: 0.75),
                          ),
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: answered
                            ? null
                            : () => viewModel.submitAnswer(option),
                        child: Text(option),
                      ),
                    );
                  }),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: answered ? viewModel.nextQuestion : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      viewModel.currentIndex == viewModel.questions.length - 1
                          ? 'Finish'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuizComplete extends StatelessWidget {
  final QuizViewModel viewModel;

  const _QuizComplete({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final total = viewModel.questions.length;
    final score = total == 0
        ? 0
        : ((viewModel.correctCount / total) * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.gold,
              size: 72,
            ),
            const SizedBox(height: 18),
            const Text(
              'Quiz complete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$score% score, ${viewModel.correctCount} of $total correct',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textDarkSecondary),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to category'),
            ),
          ],
        ),
      ),
    );
  }
}
