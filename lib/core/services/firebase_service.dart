import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseService {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  FirebaseAnalytics? _analytics;
  FirebaseMessaging? _messaging;

  // Stream for simulated push notifications
  final _notificationController =
      StreamController<Map<String, String>>.broadcast();
  Stream<Map<String, String>> get simulatedNotificationsStream =>
      _notificationController.stream;

  Future<void> initialize() async {
    try {
      // In a real flutter app, initializing firebase requires configurations.
      // If we are running in debug/emulator or missing configuration files,
      // Firebase.initializeApp() will fail. We wrap it to prevent crashes.
      await Firebase.initializeApp();

      _analytics = FirebaseAnalytics.instance;
      _messaging = FirebaseMessaging.instance;

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Request notification permissions
      await _messaging?.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen to incoming foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          'Foreground push notification received: ${message.notification?.title}',
        );
      });

      _isInitialized = true;
      debugPrint('Firebase Services initialized successfully.');
    } catch (e) {
      debugPrint('Firebase Services failed to initialize: $e');
      debugPrint('Running app in Firebase simulation/emulator mode.');
      _isInitialized = false;

      // Start a timer to simulate periodic push notifications for learning tips
      _startNotificationSimulation();
    }
  }

  // --- Push Notifications ---

  void _startNotificationSimulation() {
    Timer.periodic(const Duration(seconds: 45), (timer) {
      final notification = {
        'title': 'Daily Study Reminder 📚',
        'body': 'Time to practice your daily words! Keep your streak alive.',
      };
      _notificationController.add(notification);
      debugPrint(
        'Simulated Push Notification Fired: ${notification["title"]} - ${notification["body"]}',
      );
    });
  }

  void triggerMockNotification(String title, String body) {
    final notification = {'title': title, 'body': body};
    _notificationController.add(notification);
    debugPrint('Triggered manual mock push notification: $title - $body');
  }

  // --- Firebase Analytics ---

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (_isInitialized && _analytics != null) {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } else {
      debugPrint(
        '[Simulated Analytics] Event: "$name" Parameters: $parameters',
      );
    }
  }

  Future<void> logScreenView(String screenName) async {
    if (_isInitialized && _analytics != null) {
      await _analytics!.logScreenView(screenName: screenName);
    } else {
      debugPrint('[Simulated Analytics] Screen View: "$screenName"');
    }
  }

  // --- Firebase Crashlytics ---

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    if (_isInitialized) {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
      );
    } else {
      debugPrint(
        '[Simulated Crashlytics] Error Recorded: $exception\nReason: $reason\nStackTrace:\n$stack',
      );
    }
  }

  Future<void> forceCrash() async {
    if (_isInitialized) {
      FirebaseCrashlytics.instance.crash();
    } else {
      debugPrint(
        '[Simulated Crashlytics] Triggering Simulated App Crash event.',
      );
      throw StateError('This is a simulated crash trigger.');
    }
  }
}
