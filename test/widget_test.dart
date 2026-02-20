import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicebook_cn/main.dart';

void main() {
  group('ServiceBook App Widget Tests', () {
    testWidgets('MyApp builds correctly with unauthenticated state',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        isAuthenticated: false,
        hasProfile: false,
      ));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp builds correctly with authenticated state but no profile',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        isAuthenticated: true,
        hasProfile: false,
      ));

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MyApp builds correctly with authenticated state and profile',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        isAuthenticated: true,
        hasProfile: true,
      ));

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
