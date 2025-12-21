import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/auth/data/repository/google_auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late GoogleAuthRepositoryImpl repository;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    repository = GoogleAuthRepositoryImpl(mockGoogleSignIn);
  });

  group('GoogleAuthRepositoryImpl', () {
    const testAccessToken = 'test_access_token_12345';

    group('authenticateWithGoogle', () {
      test('should return access token when sign-in succeeds', () async {
        // Arrange
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => mockGoogleSignInAccount);
        when(() => mockGoogleSignInAccount.authentication)
            .thenAnswer((_) async => mockGoogleSignInAuthentication);
        when(() => mockGoogleSignInAuthentication.accessToken)
            .thenReturn(testAccessToken);

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result, const Right(testAccessToken));
        verify(() => mockGoogleSignIn.signIn()).called(1);
        verify(() => mockGoogleSignInAccount.authentication).called(1);
      });

      test('should return AuthenticationFailure when user cancels', () async {
        // Arrange
        when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthenticationFailure>());
            expect(failure.message, 'User canceled sign-in');
          },
          (token) => fail('Should not return token'),
        );
        verify(() => mockGoogleSignIn.signIn()).called(1);
      });

      test('should return AuthenticationFailure when access token is null', () async {
        // Arrange
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => mockGoogleSignInAccount);
        when(() => mockGoogleSignInAccount.authentication)
            .thenAnswer((_) async => mockGoogleSignInAuthentication);
        when(() => mockGoogleSignInAuthentication.accessToken).thenReturn(null);

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthenticationFailure>());
            expect(failure.message, 'Failed to get access token');
          },
          (token) => fail('Should not return token'),
        );
      });

      test('should return AuthenticationFailure when exception occurs during sign-in', () async {
        // Arrange
        when(() => mockGoogleSignIn.signIn())
            .thenThrow(Exception('Network error'));

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthenticationFailure>());
            expect(failure.message, contains('Authentication error'));
          },
          (token) => fail('Should not return token'),
        );
      });

      test('should return AuthenticationFailure when exception occurs during authentication', () async {
        // Arrange
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => mockGoogleSignInAccount);
        when(() => mockGoogleSignInAccount.authentication)
            .thenThrow(Exception('Failed to get auth'));

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<AuthenticationFailure>());
            expect(failure.message, contains('Authentication error'));
          },
          (token) => fail('Should not return token'),
        );
      });

      test('should handle different access token values', () async {
        // Arrange
        const differentToken = 'another_token_67890';
        when(() => mockGoogleSignIn.signIn())
            .thenAnswer((_) async => mockGoogleSignInAccount);
        when(() => mockGoogleSignInAccount.authentication)
            .thenAnswer((_) async => mockGoogleSignInAuthentication);
        when(() => mockGoogleSignInAuthentication.accessToken)
            .thenReturn(differentToken);

        // Act
        final result = await repository.authenticateWithGoogle();

        // Assert
        expect(result, const Right(differentToken));
      });
    });
  });
}
