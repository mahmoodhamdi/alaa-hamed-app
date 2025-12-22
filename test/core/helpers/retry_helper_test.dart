import 'package:eng_alaa_hammed/core/helpers/retry_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RetryHelper', () {
    group('withExponentialBackoff', () {
      test('should succeed on first attempt if no error', () async {
        int attempts = 0;

        final result = await RetryHelper.withExponentialBackoff(
          fn: () async {
            attempts++;
            return 'success';
          },
        );

        expect(result, 'success');
        expect(attempts, 1);
      });

      test('should retry on failure and succeed on second attempt', () async {
        int attempts = 0;

        final result = await RetryHelper.withExponentialBackoff(
          maxAttempts: 3,
          initialDelay: const Duration(milliseconds: 1),
          fn: () async {
            attempts++;
            if (attempts < 2) {
              throw Exception('Temporary error');
            }
            return 'success';
          },
        );

        expect(result, 'success');
        expect(attempts, 2);
      });

      test('should throw after max attempts exceeded', () async {
        int attempts = 0;

        await expectLater(
          () => RetryHelper.withExponentialBackoff(
            maxAttempts: 3,
            initialDelay: const Duration(milliseconds: 1),
            fn: () async {
              attempts++;
              throw Exception('Persistent error');
            },
          ),
          throwsA(isA<Exception>()),
        );

        expect(attempts, 3);
      });

      test('should not retry if retryIf returns false', () async {
        int attempts = 0;

        await expectLater(
          () => RetryHelper.withExponentialBackoff(
            maxAttempts: 3,
            initialDelay: const Duration(milliseconds: 1),
            retryIf: (e) => false,
            fn: () async {
              attempts++;
              throw Exception('Should not retry');
            },
          ),
          throwsA(isA<Exception>()),
        );

        expect(attempts, 1);
      });

      test('should retry only if retryIf returns true', () async {
        int attempts = 0;

        final result = await RetryHelper.withExponentialBackoff(
          maxAttempts: 3,
          initialDelay: const Duration(milliseconds: 1),
          retryIf: (e) => e.toString().contains('retry'),
          fn: () async {
            attempts++;
            if (attempts < 2) {
              throw Exception('please retry');
            }
            return 'success';
          },
        );

        expect(result, 'success');
        expect(attempts, 2);
      });

      test('should respect maxDelay limit', () async {
        int attempts = 0;
        final stopwatch = Stopwatch()..start();

        await expectLater(
          () => RetryHelper.withExponentialBackoff(
            maxAttempts: 3,
            initialDelay: const Duration(milliseconds: 10),
            maxDelay: const Duration(milliseconds: 20),
            fn: () async {
              attempts++;
              throw Exception('Error');
            },
          ),
          throwsA(isA<Exception>()),
        );

        stopwatch.stop();
        // With max delay of 20ms, total should be less than 100ms
        // (10ms + ~20ms between retries, jitter may vary)
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
        expect(attempts, 3);
      });
    });
  });
}
