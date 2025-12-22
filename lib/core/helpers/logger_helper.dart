import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Environment-aware logging helper.
/// - Debug mode: Shows all logs (debug, info, warning, error)
/// - Release mode: Only shows errors (no debug/info/warning logs)
class LoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: kDebugMode ? 2 : 0,
      errorMethodCount: kDebugMode ? 8 : 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
    level: kReleaseMode ? Level.error : Level.debug,
  );

  /// Log debug message (only in debug mode)
  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  /// Log info message (only in debug mode)
  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  /// Log warning message (only in debug mode)
  static void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  /// Log error message (always logs, even in release mode)
  static void error(String message, [dynamic error]) {
    _logger.e(message, error: error, stackTrace: StackTrace.current);
  }
}
