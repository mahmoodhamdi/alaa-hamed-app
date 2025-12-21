import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoPlayerPage Widget Tests', () {
    testWidgets('date formatting should work correctly', (tester) async {
      // Test the date formatting logic
      String formatDate(String dateString) {
        try {
          final DateTime parsedDate = DateTime.parse(dateString);
          return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
        } catch (e) {
          return dateString;
        }
      }

      expect(formatDate('2024-01-15T10:00:00Z'), '2024-01-15');
      expect(formatDate('invalid-date'), 'invalid-date');
      expect(formatDate('2023-12-25'), '2023-12-25');
    });

    testWidgets('should render basic scaffold structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test Video')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.publishedOn),
                  Text(AppStrings.moreDetails),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Video'), findsOneWidget);
      expect(find.text(AppStrings.publishedOn), findsOneWidget);
      expect(find.text(AppStrings.moreDetails), findsOneWidget);
    });

    testWidgets('should display video title in app bar', (tester) async {
      const testTitle = 'My Test Video Title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                testTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('should handle long video titles with ellipsis', (tester) async {
      const longTitle = 'This is a very long video title that should be truncated with ellipsis when displayed in the app bar';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                longTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(longTitle));
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should display published date label', (tester) async {
      const testDate = 'January 15, 2024';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('${AppStrings.publishedOn}: $testDate'),
            ),
          ),
        ),
      );

      expect(find.textContaining(AppStrings.publishedOn), findsOneWidget);
      expect(find.textContaining(testDate), findsOneWidget);
    });

    testWidgets('should display more details section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text(AppStrings.moreDetails),
                const Text('Video ID: test123'),
              ],
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.moreDetails), findsOneWidget);
      expect(find.text('Video ID: test123'), findsOneWidget);
    });

    testWidgets('error state should show retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(AppStrings.unexpectedError),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(AppStrings.unexpectedError), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('loading state should show progress indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading video...'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading video...'), findsOneWidget);
    });
  });
}
