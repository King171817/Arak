// Professional logging system for the application
// Provides structured logging with severity levels and context
import 'package:flutter/foundation.dart';

class AppLogger {

  /// Log severity levels
  static const int _levelDebug = 0;
  static const int _levelInfo = 1;
  static const int _levelWarning = 2;
  static const int _levelError = 3;

  /// Current log level - change this to control verbosity
  static int _currentLevel = _levelDebug;

  /// Whether to print logs to console
  static bool _enableConsoleLogs = kDebugMode;

  static final List<Map<String, dynamic>> _logs = <Map<String, dynamic>>[];

  /// Configure logging
  static void configure({
    required bool enableConsoleLogs,
    int minLevel = _levelDebug,
  }) {
    _enableConsoleLogs = enableConsoleLogs;
    _currentLevel = minLevel;
  }

  /// Log debug message
  static void debug(
    String tag,
    String message, {
    Map<String, dynamic>? data,
  }) =>
      _log(tag, message, _levelDebug, data: data);

  /// Log info message
  static void info(
    String tag,
    String message, {
    Map<String, dynamic>? data,
  }) =>
      _log(tag, message, _levelInfo, data: data);

  /// Log warning message
  static void warning(
    String tag,
    String message, {
    Map<String, dynamic>? data,
  }) =>
      _log(tag, message, _levelWarning, data: data);

  /// Log error with optional exception and stack trace
  static void error(
    String tag,
    String message, {
    Exception? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    final Map<String, dynamic> errorData = data ?? <String, dynamic>{};
    if (exception != null) {
      errorData['exception'] = exception.toString();
    }
    if (stackTrace != null) {
      errorData['stackTrace'] = stackTrace.toString();
    }
    _log(tag, message, _levelError, data: errorData);
  }

  /// Internal logging method
  static void _log(
    String tag,
    String message,
    int level, {
    Map<String, dynamic>? data,
  }) {
    if (level < _currentLevel) return;

    final String levelName = _getLevelName(level);
    final DateTime timestamp = DateTime.now();
    final String logMessage = '[$timestamp] [$levelName] [$tag] $message';

    if (_enableConsoleLogs) {
      debugPrint(logMessage);
      if (data != null && data.isNotEmpty) {
        debugPrint('  Data: $data');
      }
    }

    // Store log for later retrieval if needed
    _logs.add(<String, dynamic>{
      'timestamp': timestamp,
      'level': levelName,
      'tag': tag,
      'message': message,
      'data': data,
    });

    // Keep only last 500 logs in memory
    if (_logs.length > 500) {
      _logs.removeAt(0);
    }
  }

  /// Get log level name
  static String _getLevelName(int level) {
    switch (level) {
      case _levelDebug:
        return 'DEBUG';
      case _levelInfo:
        return 'INFO';
      case _levelWarning:
        return 'WARNING';
      case _levelError:
        return 'ERROR';
      default:
        return 'UNKNOWN';
    }
  }

  /// Get all logs
  static List<Map<String, dynamic>> getLogs() =>
      List<Map<String, dynamic>>.from(_logs);

  /// Clear all logs
  static void clearLogs() => _logs.clear();

  /// Export logs as formatted string
  static String exportLogs() {
    final StringBuffer buffer = StringBuffer();
    for (final Map<String, dynamic> log in _logs) {
      buffer.writeln(
        '[${log['timestamp']}] [${log['level']}] [${log['tag']}] ${log['message']}',
      );
      if (log['data'] != null && (log['data'] as Map).isNotEmpty) {
        buffer.writeln('  Data: ${log['data']}');
      }
    }
    return buffer.toString();
  }
}

