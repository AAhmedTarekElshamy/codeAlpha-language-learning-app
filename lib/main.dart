import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'data/models/quiz_result.dart';
import 'data/models/user_progress.dart';
import 'data/models/word.dart';
import 'data/seeds/seed_loader.dart';
import 'views/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapApp();
  runApp(const MyApp());
}

Future<void> bootstrapApp() async {
  await Hive.initFlutter();
  registerHiveAdapters();
  await configureDependencies();
  await SeedLoader.seedDatabaseIfEmpty();
}

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(WordAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(QuizResultAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(UserProgressAdapter());
  }
}

class MyApp extends StatelessWidget {
  final Widget? home;

  const MyApp({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: home ?? const MainNavigationScreen(),
    );
  }
}
