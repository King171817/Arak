/// Centralized error message constants
/// All error messages should be defined here for consistency and easy translation
abstract class AppErrorMessages {
  // Network errors
  static const String networkError = 'Ø®Ø·Ø§ÛŒ Ø´Ø¨Ú©Ù‡. Ù„Ø·ÙØ§Ù‹ Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ø®ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯';
  static const String networkTimeout = 'Ø²Ù…Ø§Ù† Ø§Ù†ØªØ¸Ø§Ø± Ø¨Ø±Ø§ÛŒ Ø§ØªØµØ§Ù„ Ø¨Ù‡ Ù¾Ø§ÛŒØ§Ù† Ø±Ø³ÛŒØ¯. Ù„Ø·ÙØ§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String noInternetConnection = 'Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ù…ÙˆØ¬ÙˆØ¯ Ù†ÛŒØ³Øª';
  static const String dnsError = 'Ù†Ø§Ù… Ø¯Ø§Ù…Ù†Ù‡ Ù‚Ø§Ø¨Ù„ Ø­Ù„ Ù†ÛŒØ³Øª. Ù„Ø·ÙØ§Ù‹ Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ø®ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯';

  // Server errors
  static const String serverError = 'Ø®Ø·Ø§ÛŒ Ø³Ø±ÙˆØ±. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String internalServerError = 'Ø®Ø·Ø§ÛŒ Ø¯Ø§Ø®Ù„ÛŒ Ø³Ø±ÙˆØ±. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String serviceUnavailable = 'Ø³Ø±ÙˆÛŒØ³ Ø¯Ø± Ø­Ø§Ù„ Ø­Ø§Ø¶Ø± Ø¯Ø± Ø¯Ø³ØªØ±Ø³ Ù†ÛŒØ³Øª';
  static const String badGateway = 'Ø®Ø·Ø§ÛŒ Ø¯Ø±Ú¯Ø§Ù‡ Ø¨Ø¯ Ø³Ø±ÙˆØ±. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';

  // Client errors
  static const String badRequest = 'Ø¯Ø±Ø®ÙˆØ§Ø³Øª Ù†Ø§Ù…Ø¹ØªØ¨Ø±. Ù„Ø·ÙØ§Ù‹ ÙˆØ±ÙˆØ¯ÛŒâ€ŒÙ‡Ø§ÛŒ Ø®ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯';
  static const String unauthorized = 'Ø´Ù…Ø§ Ø§Ø¬Ø§Ø²Ù‡ Ø¯Ø³ØªØ±Ø³ÛŒ Ù†Ø¯Ø§Ø±ÛŒØ¯. Ù„Ø·ÙØ§Ù‹ ÙˆØ§Ø±Ø¯ Ø³ÛŒØ³ØªÙ… Ø´ÙˆÛŒØ¯';
  static const String forbidden = 'Ø¯Ø³ØªØ±Ø³ÛŒ Ù…Ù…Ù†ÙˆØ¹';
  static const String notFound = 'Ù…Ù†Ø¨Ø¹ Ù…ÙˆØ±Ø¯ Ù†Ø¸Ø± ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String conflict = 'ØªØ¶Ø§Ø¯ Ø¯Ø± Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§. Ù„Ø·ÙØ§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';

  // Validation errors
  static const String validationError = 'Ø®Ø·Ø§ÛŒ Ø§Ø¹ØªØ¨Ø§Ø±Ø³Ù†Ø¬ÛŒ. Ù„Ø·ÙØ§Ù‹ ÙˆØ±ÙˆØ¯ÛŒâ€ŒÙ‡Ø§ÛŒ Ø®ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯';
  static const String requiredFieldEmpty = 'Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ Ø§Ù„Ø²Ø§Ù…ÛŒ Ø§Ø³Øª';
  static const String invalidEmail = 'Ø¢Ø¯Ø±Ø³ Ø§ÛŒÙ…ÛŒÙ„ Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';
  static const String invalidPassword = 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';
  static const String passwordMismatch = 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ±Ù‡Ø§ Ù…Ø·Ø§Ø¨Ù‚Øª Ù†Ø¯Ø§Ø±Ù†Ø¯';
  static const String invalidPhoneNumber = 'Ø´Ù…Ø§Ø±Ù‡ ØªÙ„ÙÙ† Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';

  // Authentication errors
  static const String authenticationFailed = 'Ø§Ø­Ø±Ø§Ø² Ù‡ÙˆÛŒØª Ù†Ø§Ù…ÙˆÙÙ‚ Ø¨ÙˆØ¯. Ù„Ø·ÙØ§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String sessionExpired = 'Ø¬Ù„Ø³Ù‡ Ø´Ù…Ø§ Ù…Ù†Ù‚Ø¶ÛŒ Ø´Ø¯Ù‡ Ø§Ø³Øª. Ù„Ø·ÙØ§Ù‹ ÙˆØ§Ø±Ø¯ Ø³ÛŒØ³ØªÙ… Ø´ÙˆÛŒØ¯';
  static const String invalidCredentials = 'Ù†Ø§Ù…â€ŒÚ©Ø§Ø±Ø¨Ø±ÛŒ ÛŒØ§ Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ù†Ø§Ø¯Ø±Ø³Øª Ø§Ø³Øª';
  static const String accountLocked = 'Ø­Ø³Ø§Ø¨ Ú©Ø§Ø±Ø¨Ø±ÛŒ Ø´Ù…Ø§ Ù‚ÙÙ„ Ø´Ø¯Ù‡ Ø§Ø³Øª';
  static const String accountNotFound = 'Ø­Ø³Ø§Ø¨ Ú©Ø§Ø±Ø¨Ø±ÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯';

  // Permission errors
  static const String permissionDenied = 'Ø¯Ø³ØªØ±Ø³ÛŒ Ù…Ù…Ù†ÙˆØ¹. Ø´Ù…Ø§ Ø§Ø¬Ø§Ø²Ù‡ Ø§ÛŒÙ† Ø¹Ù…Ù„ Ø±Ø§ Ù†Ø¯Ø§Ø±ÛŒØ¯';
  static const String insufficientPermissions = 'Ø´Ù…Ø§ Ø¯Ø³ØªØ±Ø³ÛŒ Ú©Ø§ÙÛŒ Ø¨Ø±Ø§ÛŒ Ø§ÛŒÙ† Ø¹Ù…Ù„ Ù†Ø¯Ø§Ø±ÛŒØ¯';

  // Database errors
  static const String databaseError = 'Ø®Ø·Ø§ÛŒ Ù¾Ø§ÛŒÚ¯Ø§Ù‡ Ø¯Ø§Ø¯Ù‡. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String recordNotFound = 'Ø±Ú©ÙˆØ±Ø¯ Ù…ÙˆØ±Ø¯ Ù†Ø¸Ø± ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String recordAlreadyExists = 'Ø§ÛŒÙ† Ø±Ú©ÙˆØ±Ø¯ Ù‚Ø¨Ù„Ø§Ù‹ Ù…ÙˆØ¬ÙˆØ¯ Ø§Ø³Øª';
  static const String dataIntegrityError = 'Ø®Ø·Ø§ÛŒ ÛŒÚ©Ù¾Ø§Ø±Ú†Ú¯ÛŒ Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§';

  // File errors
  static const String fileNotFound = 'ÙØ§ÛŒÙ„ Ù…ÙˆØ±Ø¯ Ù†Ø¸Ø± ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String fileTooBig = 'Ø­Ø¬Ù… ÙØ§ÛŒÙ„ Ø®ÛŒÙ„ÛŒ Ø¨Ø²Ø±Ú¯ Ø§Ø³Øª';
  static const String invalidFileFormat = 'ÙØ±Ù…Øª ÙØ§ÛŒÙ„ Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';

  // Operation errors
  static const String operationFailed = 'Ø¹Ù…Ù„ÛŒØ§Øª Ù†Ø§Ù…ÙˆÙÙ‚ Ø¨ÙˆØ¯. Ù„Ø·ÙØ§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String operationCancelled = 'Ø¹Ù…Ù„ÛŒØ§Øª ØªÙˆØ³Ø· Ú©Ø§Ø±Ø¨Ø± Ù„ØºÙˆ Ø´Ø¯';
  static const String operationTimeout = 'Ø²Ù…Ø§Ù† Ø¹Ù…Ù„ÛŒØ§Øª Ø¨Ù‡ Ù¾Ø§ÛŒØ§Ù† Ø±Ø³ÛŒØ¯';

  // Unknown errors
  static const String unknownError = 'Ø®Ø·Ø§ÛŒ Ù†Ø§Ù…Ø´Ø®Øµ. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String unexpectedError = 'Ø®Ø·Ø§ÛŒ ØºÛŒØ±Ù…Ù†ØªØ¸Ø±Ù‡ Ø±Ø® Ø¯Ø§Ø¯';

  // Success messages
  static const String successOperationCompleted = 'Ø¹Ù…Ù„ÛŒØ§Øª Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø§Ù†Ø¬Ø§Ù… Ø´Ø¯';
  static const String successDataSaved = 'Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§ Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø°Ø®ÛŒØ±Ù‡ Ø´Ø¯Ù†Ø¯';
  static const String successDataDeleted = 'Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§ Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø­Ø°Ù Ø´Ø¯Ù†Ø¯';
  static const String successDataUpdated = 'Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§ Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø¨Ø±ÙˆØ²Ø±Ø³Ø§Ù†ÛŒ Ø´Ø¯Ù†Ø¯';
  static const String successLoginCompleted = 'ÙˆØ±ÙˆØ¯ Ù…ÙˆÙÙ‚ÛŒØªâ€ŒØ¢Ù…ÛŒØ² Ø¨ÙˆØ¯';
  static const String successLogoutCompleted = 'Ø®Ø±ÙˆØ¬ Ù…ÙˆÙÙ‚ÛŒØªâ€ŒØ¢Ù…ÛŒØ² Ø¨ÙˆØ¯';

  // Confirmation messages
  static const String confirmDelete = 'Ø¢ÛŒØ§ Ù…Ø·Ù…Ø¦Ù† Ù‡Ø³ØªÛŒØ¯ Ú©Ù‡ Ù…ÛŒâ€ŒØ®ÙˆØ§Ù‡ÛŒØ¯ Ø§ÛŒÙ† Ù…ÙˆØ±Ø¯ Ø±Ø§ Ø­Ø°Ù Ú©Ù†ÛŒØ¯ØŸ';
  static const String confirmLogout = 'Ø¢ÛŒØ§ Ù…Ø·Ù…Ø¦Ù† Ù‡Ø³ØªÛŒØ¯ Ú©Ù‡ Ù…ÛŒâ€ŒØ®ÙˆØ§Ù‡ÛŒØ¯ Ø®Ø§Ø±Ø¬ Ø´ÙˆÛŒØ¯ØŸ';

  // Loading messages
  static const String loadingData = 'Ø¯Ø± Ø­Ø§Ù„ Ø¨Ø§Ø±Ú¯Ø°Ø§Ø±ÛŒ Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§...';
  static const String processingRequest = 'Ø¯Ø± Ø­Ø§Ù„ Ù¾Ø±Ø¯Ø§Ø²Ø´ Ø¯Ø±Ø®ÙˆØ§Ø³Øª...';
  static const String savingData = 'Ø¯Ø± Ø­Ø§Ù„ Ø°Ø®ÛŒØ±Ù‡ Ø¯Ø§Ø¯Ù‡â€ŒÙ‡Ø§...';

  /// Get error message by code
  static String getErrorMessage(String code) {
    switch (code.toUpperCase()) {
      case 'NETWORK_ERROR':
        return networkError;
      case 'NETWORK_TIMEOUT':
        return networkTimeout;
      case 'NO_INTERNET':
        return noInternetConnection;
      case 'SERVER_ERROR':
        return serverError;
      case 'AUTH_ERROR':
        return authenticationFailed;
      case 'VALIDATION_ERROR':
        return validationError;
      case 'DATABASE_ERROR':
        return databaseError;
      case 'PERMISSION_ERROR':
        return permissionDenied;
      default:
        return unknownError;
    }
  }
}

