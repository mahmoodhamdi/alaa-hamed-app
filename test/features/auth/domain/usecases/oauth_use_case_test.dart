import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late OAuthUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = OAuthUseCase(mockRepository);
  });

  group('OAuthUseCase', () {
    const testAccessToken = 'test_access_token_12345';

    test('should return access token when authentication succeeds', () async {
      // Arrange
      when(() => mockRepository.authenticateWithGoogle())
          .thenAnswer((_) async => const Right(testAccessToken));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, const Right(testAccessToken));
      verify(() => mockRepository.authenticateWithGoogle()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user cancels', () async {
      // Arrange
      const failure = AuthenticationFailure('User canceled sign-in');
      when(() => mockRepository.authenticateWithGoogle())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.authenticateWithGoogle()).called(1);
    });

    test('should return AuthenticationFailure when token is null', () async {
      // Arrange
      const failure = AuthenticationFailure('Failed to get access token');
      when(() => mockRepository.authenticateWithGoogle())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.authenticateWithGoogle()).called(1);
    });

    test('should return failure when authentication error occurs', () async {
      // Arrange
      const failure = AuthenticationFailure('Authentication error: Some error');
      when(() => mockRepository.authenticateWithGoogle())
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.authenticateWithGoogle()).called(1);
    });

    test('should work with NoParams parameter', () async {
      // Arrange
      when(() => mockRepository.authenticateWithGoogle())
          .thenAnswer((_) async => const Right(testAccessToken));

      // Act
      final result = await useCase.call(param: const NoParams());

      // Assert
      expect(result, const Right(testAccessToken));
      verify(() => mockRepository.authenticateWithGoogle()).called(1);
    });

    test('should implement UseCase interface', () {
      expect(useCase, isA<UseCase<Either<Failure, String>, NoParams>>());
    });
  });
}
