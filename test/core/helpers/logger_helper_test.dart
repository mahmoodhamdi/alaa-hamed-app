import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoggerHelper', () {
    test('debug should not throw', () {
      expect(() => LoggerHelper.debug('Test debug message'), returnsNormally);
    });

    test('info should not throw', () {
      expect(() => LoggerHelper.info('Test info message'), returnsNormally);
    });

    test('warning should not throw', () {
      expect(() => LoggerHelper.warning('Test warning message'), returnsNormally);
    });

    test('error should not throw', () {
      expect(() => LoggerHelper.error('Test error message'), returnsNormally);
    });

    test('error with exception should not throw', () {
      expect(
        () => LoggerHelper.error('Test error with exception', Exception('Test')),
        returnsNormally,
      );
    });

    test('should handle empty messages', () {
      expect(() => LoggerHelper.debug(''), returnsNormally);
      expect(() => LoggerHelper.info(''), returnsNormally);
      expect(() => LoggerHelper.warning(''), returnsNormally);
      expect(() => LoggerHelper.error(''), returnsNormally);
    });

    test('should handle special characters in messages', () {
      const specialMessage = 'Test: éàü 中文 🎉 <>&"\'';
      expect(() => LoggerHelper.debug(specialMessage), returnsNormally);
      expect(() => LoggerHelper.info(specialMessage), returnsNormally);
      expect(() => LoggerHelper.warning(specialMessage), returnsNormally);
      expect(() => LoggerHelper.error(specialMessage), returnsNormally);
    });
  });
}
