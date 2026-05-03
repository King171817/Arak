/// Custom exception class for application-wide error handling
/// Provides structured error information with categorization and messaging
class AppException implements Exception {
  /// The error message to be displayed to users
  final String message;

  /// The error code for identifying different error types
  final String code;

  /// The original exception that caused this error
  final Exception? originalException;

  /// Stack trace for debugging purposes
  final StackTrace? stackTrace;

  /// The category of the error (network, validation, server, unknown)
  final AppExceptionType type;

  AppException({
    required this.message,
    required this.code,
    this.originalException,
    this.stackTrace,
    this.type = AppExceptionType.unknown,
  });

  /// Network-related error (no internet, timeout, DNS failure)
  factory AppException.network(
    String message, {
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'NETWORK_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.network,
      );

  /// Server error (5xx responses)
  factory AppException.server(
    String message, {
    int? statusCode,
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'SERVER_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.server,
      );

  /// Client error (4xx responses)
  factory AppException.client(
    String message, {
    int? statusCode,
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'CLIENT_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.client,
      );

  /// Validation error
  factory AppException.validation(
    String message, {
    String? fieldName,
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'VALIDATION_ERROR_${fieldName ?? 'UNKNOWN'.toUpperCase()}',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.validation,
      );

  /// Authentication error
  factory AppException.auth(
    String message, {
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'AUTH_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.auth,
      );

  /// Permission error
  factory AppException.permission(
    String message, {
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'PERMISSION_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.permission,
      );

  /// Database operation error
  factory AppException.database(
    String message, {
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'DATABASE_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.database,
      );

  /// Generic unknown error
  factory AppException.unknown(
    String message, {
    Exception? originalException,
    StackTrace? stackTrace,
  }) =>
      AppException(
        message: message,
        code: 'UNKNOWN_ERROR',
        originalException: originalException,
        stackTrace: stackTrace,
        type: AppExceptionType.unknown,
      );

  @override
  String toString() =>
      'AppException(code: $code, message: $message, type: ${type.toString()})';
}

/// Error type categorization for better error handling strategies
enum AppExceptionType {
  network,
  server,
  client,
  validation,
  auth,
  permission,
  database,
  unknown,
}

