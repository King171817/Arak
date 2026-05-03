/// Input validation utilities for forms and inputs
/// Provides common validation patterns with custom error messages
class AppValidator {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø¢Ø¯Ø±Ø³ Ø§ÛŒÙ…ÛŒÙ„ Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø¢Ø¯Ø±Ø³ Ø§ÛŒÙ…ÛŒÙ„ Ù…Ø¹ØªØ¨Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    return null;
  }

  /// Validate password (minimum 8 characters, mix of uppercase, lowercase, numbers)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    if (value.length < 8) {
      return 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ø¨Ø§ÛŒØ¯ Ø­Ø¯Ø§Ù‚Ù„ 8 Ú©Ø§Ø±Ø§Ú©ØªØ± Ø¨Ø§Ø´Ø¯';
    }

    final bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    final bool hasNumbers = value.contains(RegExp(r'[0-9]'));

    if (!hasUppercase || !hasLowercase || !hasNumbers) {
      return 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ø¨Ø§ÛŒØ¯ Ø´Ø§Ù…Ù„ Ø­Ø±ÙˆÙ Ø¨Ø²Ø±Ú¯ØŒ Ø­Ø±ÙˆÙ Ú©ÙˆÚ†Ú© Ùˆ Ø§Ø¹Ø¯Ø§Ø¯ Ø¨Ø§Ø´Ø¯';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ ${fieldName ?? 'Ø§ÛŒÙ† ÙÛŒÙ„Ø¯'} Ø±Ø§ Ù¾Ø± Ú©Ù†ÛŒØ¯';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ Ø±Ø§ Ù¾Ø± Ú©Ù†ÛŒØ¯';
    }

    if (value.length < minLength) {
      return 'Ø­Ø¯Ø§Ù‚Ù„ Ø·ÙˆÙ„ Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ $minLength Ú©Ø§Ø±Ø§Ú©ØªØ± Ø§Ø³Øª';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Ø­Ø¯Ø§Ú©Ø«Ø± Ø·ÙˆÙ„ Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ $maxLength Ú©Ø§Ø±Ø§Ú©ØªØ± Ø§Ø³Øª';
    }

    return null;
  }

  /// Validate phone number (Persian and international formats)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø´Ù…Ø§Ø±Ù‡ ØªÙ„ÙÙ† Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    // Support +98, 0098, 0, and just 9 prefixes
    final RegExp phoneRegex = RegExp(
      r'^(?:\+98|0098|0)?9\d{9}$',
    );

    if (!phoneRegex.hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø´Ù…Ø§Ø±Ù‡ ØªÙ„ÙÙ† Ù…Ø¹ØªØ¨Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ URL Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'Ù„Ø·ÙØ§Ù‹ URL Ù…Ø¹ØªØ¨Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
      }
      return null;
    } catch (e) {
      return 'Ù„Ø·ÙØ§Ù‹ URL Ù…Ø¹ØªØ¨Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }
  }

  /// Validate password match
  static String? validatePasswordMatch(String? value, String passwordToMatch) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ ØªØ£ÛŒÛŒØ¯ Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    if (value != passwordToMatch) {
      return 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ±Ù‡Ø§ Ù…Ø·Ø§Ø¨Ù‚Øª Ù†Ø¯Ø§Ø±Ù†Ø¯';
    }

    return null;
  }

  /// Validate numeric value
  static String? validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ù…Ù‚Ø¯Ø§Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Ù„Ø·ÙØ§Ù‹ ØªÙ†Ù‡Ø§ Ø¹Ø¯Ø¯ Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    return null;
  }

  /// Validate Persian/Arabic characters only
  static String? validatePersianOnly(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ Ø±Ø§ Ù¾Ø± Ú©Ù†ÛŒØ¯';
    }

    final RegExp persianRegex = RegExp(r'^[\u0600-\u06FF\s]+$');

    if (!persianRegex.hasMatch(value)) {
      return 'Ù„Ø·ÙØ§Ù‹ ØªÙ†Ù‡Ø§ Ø­Ø±ÙˆÙ ÙØ§Ø±Ø³ÛŒ Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    return null;
  }

  /// Validate custom regex pattern
  static String? validateRegex(
    String? value,
    RegExp regex, {
    String? errorMessage,
  }) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ Ø±Ø§ Ù¾Ø± Ú©Ù†ÛŒØ¯';
    }

    if (!regex.hasMatch(value)) {
      return errorMessage ?? 'ÙØ±Ù…Øª Ø§Ø·Ù„Ø§Ø¹Ø§Øª ØµØ­ÛŒØ­ Ù†ÛŒØ³Øª';
    }

    return null;
  }

  /// Validate number range
  static String? validateNumberRange(
    String? value, {
    required num minValue,
    required num maxValue,
  }) {
    if (value == null || value.isEmpty) {
      return 'Ù„Ø·ÙØ§Ù‹ Ù…Ù‚Ø¯Ø§Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    final num? numValue = num.tryParse(value);
    if (numValue == null) {
      return 'Ù„Ø·ÙØ§Ù‹ Ø¹Ø¯Ø¯ Ù…Ø¹ØªØ¨Ø± Ø±Ø§ ÙˆØ§Ø±Ø¯ Ú©Ù†ÛŒØ¯';
    }

    if (numValue < minValue || numValue > maxValue) {
      return 'Ù…Ù‚Ø¯Ø§Ø± Ø¨Ø§ÛŒØ¯ Ø¨ÛŒÙ† $minValue Ùˆ $maxValue Ø¨Ø§Ø´Ø¯';
    }

    return null;
  }
}

