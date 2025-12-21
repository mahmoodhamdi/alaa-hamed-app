import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/all_videos_page.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Video Player Navigation Integration Tests', () {
    tearDown(() async {
      await cleanupServiceLocator();
    });

    testWidgets('should navigate to video player when video card is tapped', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act - tap on first video
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert - should navigate to video player
      expect(find.byType(VideoPlayerPage), findsOneWidget);
    });

    testWidgets('video player should display video title', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Video 1 - Flutter Tutorial'), findsOneWidget);
    });

    testWidgets('video player should display published date', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert - should show published on label
      expect(find.textContaining(AppStrings.publishedOn), findsOneWidget);
    });

    testWidgets('video player should display more details section', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.moreDetails), findsOneWidget);
    });

    testWidgets('should navigate back from video player to videos list', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to video player
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert we're on video player
      expect(find.byType(VideoPlayerPage), findsOneWidget);

      // Act - navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert - back on videos list
      expect(find.byType(AllVideosPage), findsOneWidget);
      expect(find.text(AppStrings.allVideos), findsOneWidget);
    });

    testWidgets('should be able to navigate to different videos', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to first video
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();
      expect(find.text('Test Video 1 - Flutter Tutorial'), findsOneWidget);

      // Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Navigate to second video
      await tester.tap(find.text('Test Video 2 - Dart Programming'));
      await tester.pumpAndSettle();
      expect(find.text('Test Video 2 - Dart Programming'), findsOneWidget);
    });

    testWidgets('video player page should have SliverAppBar', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('video player should have NestedScrollView for scrolling', (tester) async {
      // Arrange
      await setupMockedServiceLocator(videosSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllVideosPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Test Video 1 - Flutter Tutorial'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NestedScrollView), findsOneWidget);
    });
  });
}
