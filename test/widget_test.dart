import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_learn/core/constants/app_constants.dart';
import 'package:lingua_learn/main.dart';

void main() {
  testWidgets('uses Arabic English app shell instead of counter template', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MyApp(home: Scaffold(body: Text('Arabic English shell'))),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, AppConstants.appName);
    expect(find.text('Arabic English shell'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
