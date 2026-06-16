import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../views/shared/animated_gradient_bg.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../core/di/service_locator.dart';
import 'category_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBg(
        child: SafeArea(
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Custom App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _showLanguageSelector(context, viewModel),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        viewModel.selectedLanguageFlag,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        viewModel.selectedLanguageName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Streak
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${viewModel.progress.currentStreak} Days',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              // XP level
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Lvl ${viewModel.progress.level}',
                                  style: const TextStyle(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Daily Goal circular indicator Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).cardTheme.color ??
                              AppColors.darkCard,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Today\'s Progress',
                                    style: TextStyle(
                                      color: AppColors.textDarkSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Keep the momentum!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${viewModel.progress.dailyXp} / 50 XP to Daily Goal',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: (viewModel.progress.dailyXp / 50.0)
                                          .clamp(0.0, 1.0),
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      color: AppColors.mint,
                                      minHeight: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    value: (viewModel.progress.dailyXp / 50.0)
                                        .clamp(0.0, 1.0),
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    color: AppColors.mint,
                                    strokeWidth: 8,
                                  ),
                                ),
                                Text(
                                  '${((viewModel.progress.dailyXp / 50.0) * 100).toInt().clamp(0, 100)}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // AI Recommendation Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2C243B), Color(0xFF1F1A2E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: AppColors.primaryLight,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'AI Study Coach Recommendation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                if (viewModel.isLoadingRecommendation)
                                  const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryLight,
                                    ),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: AppColors.textDarkSecondary,
                                      size: 20,
                                    ),
                                    onPressed: viewModel.loadRecommendation,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              viewModel.aiRecommendation,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                height: 1.4,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Study section header
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, top: 20, bottom: 10),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Categories grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = AppConstants.mainCategories[index];
                        return _buildCategoryCard(context, category, viewModel);
                      }, childCount: AppConstants.mainCategories.length),
                    ),
                  ),

                  // Top spacer
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String category,
    HomeViewModel homeViewModel,
  ) {
    Color cardColor;
    IconData cardIcon;
    List<Color> gradient;

    switch (category) {
      case 'Vocabulary':
        cardColor = AppColors.vocabColor;
        cardIcon = Icons.translate_rounded;
        gradient = [const Color(0xFF6C63FF), const Color(0xFF8B85FF)];
        break;
      case 'Grammar':
        cardColor = AppColors.grammarColor;
        cardIcon = Icons.g_translate_rounded;
        gradient = [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)];
        break;
      case 'Phrases':
        cardColor = AppColors.phrasesColor;
        cardIcon = Icons.forum_rounded;
        gradient = [const Color(0xFF4ECDC4), const Color(0xFF71E3DC)];
        break;
      default:
        cardColor = AppColors.sentencesColor;
        cardIcon = Icons.menu_book_rounded;
        gradient = [const Color(0xFFFFD93D), const Color(0xFFFFE566)];
        break;
    }

    return ChangeNotifierProvider<CategoryViewModel>(
      create: (_) => getIt<CategoryViewModel>(),
      child: Consumer<CategoryViewModel>(
        builder: (context, catViewModel, child) {
          final mastery = catViewModel.getCategoryMastery(
            homeViewModel.selectedLanguage,
            category,
          );
          final wordCount = catViewModel.getWordCount(
            homeViewModel.selectedLanguage,
            category,
          );

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailScreen(
                    category: category,
                    languageCode: homeViewModel.selectedLanguage,
                    languageName: homeViewModel.selectedLanguageName,
                  ),
                ),
              ).then((_) {
                homeViewModel.refresh();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: gradient
                      .map((c) => c.withValues(alpha: 0.15))
                      .toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: cardColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cardColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cardIcon, color: cardColor, size: 22),
                      ),
                      Text(
                        '${(mastery * 100).toInt()}%',
                        style: TextStyle(
                          color: cardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$wordCount items',
                        style: const TextStyle(
                          color: AppColors.textDarkSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: mastery,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          color: cardColor,
                          minHeight: 5,
                        ),
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

  void _showLanguageSelector(
    BuildContext context,
    HomeViewModel homeViewModel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Learning Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ...AppConstants.supportedLanguages.entries.map((entry) {
                final code = entry.key;
                final name = entry.value;
                final flag = AppConstants.languageFlags[code] ?? '🌐';
                final isSelected = homeViewModel.selectedLanguage == code;

                return InkWell(
                  onTap: () {
                    homeViewModel.changeLanguage(code);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(flag, style: const TextStyle(fontSize: 26)),
                            const SizedBox(width: 16),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
