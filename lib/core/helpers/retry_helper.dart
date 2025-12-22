import 'dart:async';
import 'dart:math';

import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';

/// Helper class for implementing retry logic with exponential backoff.
class RetryHelper {
  /// Executes an async function with exponential backoff retry.
  ///
  /// [fn] - The async function to execute.
  /// [maxAttempts] - Maximum number of retry attempts (default: 3).
  /// [initialDelay] - Initial delay before first retry (default: 1 second).
  /// [maxDelay] - Maximum delay between retries (default: 30 seconds).
  /// [retryIf] - Optional predicate to determine if error should trigger retry.
  static Future<T> withExponentialBackoff<T>({
    required Future<T> Function() fn,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 30),
    bool Function(Exception)? retryIf,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (true) {
      attempts++;
      try {
        return await fn();
      } on Exception catch (e) {
        if (attempts >= maxAttempts) {
          LoggerHelper.error(
            'Retry failed after $attempts attempts',
            e,
          );
          rethrow;
        }

        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }

        LoggerHelper.warning(
          'Attempt $attempts failed, retrying in ${delay.inMilliseconds}ms...',
        );

        await Future.delayed(delay);

        // Exponential backoff with jitter
        final jitter = Random().nextDouble() * 0.3 + 0.85; // 0.85 to 1.15
        delay = Duration(
          milliseconds: min(
            (delay.inMilliseconds * 2 * jitter).round(),
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }
}
