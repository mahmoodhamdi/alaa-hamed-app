import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/all_videos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Video Fetch and Display Flow Integration Tests', () {
    tearDown(() async {
      await cleanupServiceLocator();
    });

    testWidgets('should display loading indicator initially', (tester) async {
      // Arrange - use longer delay to ensure loading state is visible
      await setupMockedServiceLocator(
        videosSuccess: true,
        mockDelay: const Duration(milliseconds: 500),
      );

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display videos list after successful fetch', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Video 1 - Flutter Tutorial'), findsOneWidget);
      expect(find.text('Test Video 2 - Dart Programming'), findsOneWidget);
      expect(find.text('Test Video 3 - State Management'), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.allVideos), findsOneWidget);
    });

    testWidgets('should display error state on fetch failure', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.failedToLoadVideos), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display empty state when no videos', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true, videos: []);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.noVideosAvailable), findsOneWidget);
      expect(find.text(AppStrings.checkBackLater), findsOneWidget);
      expect(find.byIcon(Icons.video_library), findsOneWidget);
    });

    testWidgets('should have correct number of video cards', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('should allow scrolling through videos list', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - find ListView
      expect(find.byType(ListView), findsOneWidget);

      // Scroll down
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // Videos should still be visible after scroll
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('retry button should trigger new fetch', (tester) async {
      // Arrange - use longer delay to ensure loading state is visible
      await setupMockedServiceLocator(
        videosSuccess: false,
        mockDelay: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert error state
      expect(find.text(AppStrings.retry), findsOneWidget);

      // Act - tap retry
      await tester.tap(find.text(AppStrings.retry));
      await tester.pump(const Duration(milliseconds: 50));

      // Assert - should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
