import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/views/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    tearDown(() async {
      await cleanupServiceLocator();
    });

    testWidgets('should display sign in button on initial state', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.signInWithGoogle), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });

    testWidgets('should show loading indicator when sign in is tapped', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(AppStrings.signInWithGoogle));
      await tester.pump();

      // Assert - should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show success state after successful sign in', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: true);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(AppStrings.signInWithGoogle));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.signedIn), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.textContaining(AppStrings.accessToken), findsOneWidget);
    });

    testWidgets('should show error state when user cancels sign in', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text(AppStrings.signInWithGoogle));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
    });

    testWidgets('should allow retry after failed sign in', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // First attempt - fails
      await tester.tap(find.text(AppStrings.signInWithGoogle));
      await tester.pumpAndSettle();

      // Assert error state
      expect(find.text(AppStrings.retry), findsOneWidget);

      // Act - tap retry
      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();

      // Assert - should show loading again
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (tester) async {
      // Arrange
      await setupMockedServiceLocator(authSuccess: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: AuthView(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.googleSignIn), findsOneWidget);
    });
  });
}
