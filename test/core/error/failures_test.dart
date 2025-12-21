import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure classes', () {
    group('ServerFailure', () {
      test('should have default message', () {
        const failure = ServerFailure();
        expect(failure.message, 'Server error occurred');
      });

      test('should accept custom message', () {
        const failure = ServerFailure('Custom server error');
        expect(failure.message, 'Custom server error');
      });

      test('two failures with same message should be equal', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1, failure2);
      });
    });

    group('NetworkFailure', () {
      test('should have default message', () {
        const failure = NetworkFailure();
        expect(failure.message, 'Network connection failed');
      });

      test('should accept custom message', () {
        const failure = NetworkFailure('No internet');
        expect(failure.message, 'No internet');
      });
    });

    group('CacheFailure', () {
      test('should have default message', () {
        const failure = CacheFailure();
        expect(failure.message, 'Cache error occurred');
      });
    });

    group('AuthenticationFailure', () {
      test('should have default message', () {
        const failure = AuthenticationFailure();
        expect(failure.message, 'Authentication failed');
      });

      test('should accept custom message', () {
        const failure = AuthenticationFailure('User canceled');
        expect(failure.message, 'User canceled');
      });
    });

    group('UnexpectedFailure', () {
      test('should have default message', () {
        const failure = UnexpectedFailure();
        expect(failure.message, 'An unexpected error occurred');
      });
    });

    group('Equatable', () {
      test('failures of same type with same message should be equal', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1, failure2);
        expect(failure1.hashCode, failure2.hashCode);
      });

      test('failures of same type with different messages should not be equal', () {
        const failure1 = ServerFailure('Error 1');
        const failure2 = ServerFailure('Error 2');
        expect(failure1, isNot(failure2));
      });

      test('failures of different types should not be equal', () {
        const serverFailure = ServerFailure('Error');
        const networkFailure = NetworkFailure('Error');
        expect(serverFailure, isNot(networkFailure));
      });

      test('props should contain message', () {
        const failure = ServerFailure('Test error');
        expect(failure.props, ['Test error']);
      });
    });
  });
}
