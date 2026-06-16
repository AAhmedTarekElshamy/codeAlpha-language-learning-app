import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadQuizHistory('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          final progress = viewModel.progress;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Language learner',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Level ${progress.level}',
                            style: const TextStyle(
                              color: AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _StatGrid(
                items: [
                  _StatItem(
                    'Streak',
                    '${progress.currentStreak} days',
                    Icons.local_fire_department_rounded,
                  ),
                  _StatItem(
                    'Words',
                    '${progress.totalWordsLearned}',
                    Icons.style_rounded,
                  ),
                  _StatItem(
                    'Quizzes',
                    '${progress.totalQuizzesTaken}',
                    Icons.quiz_rounded,
                  ),
                  _StatItem(
                    'Accuracy',
                    '${progress.overallAccuracy.round()}%',
                    Icons.track_changes_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent quizzes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (viewModel.quizHistory.isEmpty)
                const Text(
                  'No quiz history yet.',
                  style: TextStyle(color: AppColors.textDarkSecondary),
                )
              else
                ...viewModel.quizHistory
                    .take(5)
                    .map(
                      (result) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.fact_check_rounded,
                          color: AppColors.gold,
                        ),
                        title: Text(
                          result.category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${result.correctAnswers}/${result.totalQuestions} correct',
                          style: const TextStyle(
                            color: AppColors.textDarkSecondary,
                          ),
                        ),
                        trailing: Text(
                          result.grade,
                          style: const TextStyle(
                            color: AppColors.mint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final List<_StatItem> items;

  const _StatGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: AppColors.primaryLight),
              const SizedBox(height: 8),
              Text(
                item.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.label,
                style: const TextStyle(color: AppColors.textDarkSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem(this.label, this.value, this.icon);
}
