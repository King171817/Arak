/// String constants for UI text and messages
/// Centralizes all user-facing strings for easy maintenance and localization
abstract class AppStrings {
  // App titles and labels
  static const String appName = 'testapp2';
  static const String appTitle = 'Ø§Ù¾Ù„ÛŒÚ©ÛŒØ´Ù† Ø¯Ø§Ù†Ø´Ú¯Ø§Ù‡';
  static const String appSubtitle = 'Ø§Ø±ØªØ¨Ø§Ø· Ø¯Ø§Ù†Ø´Ø¬ÙˆÛŒØ§Ù† Ø¨ÛŒÙ†â€ŒØ§Ù„Ù…Ù„Ù„';

  // Navigation
  static const String home = 'Ø®Ø§Ù†Ù‡';
  static const String dashboard = 'Ø¯Ø§Ø´Ø¨ÙˆØ±Ø¯';
  static const String profile = 'Ù¾Ø±ÙˆÙØ§ÛŒÙ„';
  static const String settings = 'ØªÙ†Ø¸ÛŒÙ…Ø§Øª';
  static const String logout = 'Ø®Ø±ÙˆØ¬';
  static const String login = 'ÙˆØ±ÙˆØ¯';
  static const String register = 'Ø«Ø¨Øªâ€ŒÙ†Ø§Ù…';

  // Common actions
  static const String save = 'Ø°Ø®ÛŒØ±Ù‡';
  static const String cancel = 'Ù„ØºÙˆ';
  static const String delete = 'Ø­Ø°Ù';
  static const String edit = 'ÙˆÛŒØ±Ø§ÛŒØ´';
  static const String add = 'Ø§ÙØ²ÙˆØ¯Ù†';
  static const String search = 'Ø¬Ø³ØªØ¬Ùˆ';
  static const String filter = 'ÙÛŒÙ„ØªØ±';
  static const String refresh = 'Ø¨Ø±ÙˆØ²Ø±Ø³Ø§Ù†ÛŒ';

  // Form fields
  static const String email = 'Ø§ÛŒÙ…ÛŒÙ„';
  static const String password = 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ±';
  static const String confirmPassword = 'ØªØ£ÛŒÛŒØ¯ Ø±Ù…Ø² Ø¹Ø¨ÙˆØ±';
  static const String firstName = 'Ù†Ø§Ù…';
  static const String lastName = 'Ù†Ø§Ù… Ø®Ø§Ù†ÙˆØ§Ø¯Ú¯ÛŒ';
  static const String phoneNumber = 'Ø´Ù…Ø§Ø±Ù‡ ØªÙ„ÙÙ†';
  static const String address = 'Ø¢Ø¯Ø±Ø³';

  // Validation messages
  static const String requiredField = 'Ø§ÛŒÙ† ÙÛŒÙ„Ø¯ Ø§Ù„Ø²Ø§Ù…ÛŒ Ø§Ø³Øª';
  static const String invalidEmail = 'Ø§ÛŒÙ…ÛŒÙ„ Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';
  static const String invalidPassword = 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ± Ø¨Ø§ÛŒØ¯ Ø­Ø¯Ø§Ù‚Ù„ 8 Ú©Ø§Ø±Ø§Ú©ØªØ± Ø¨Ø§Ø´Ø¯';
  static const String passwordMismatch = 'Ø±Ù…Ø² Ø¹Ø¨ÙˆØ±Ù‡Ø§ Ù…Ø·Ø§Ø¨Ù‚Øª Ù†Ø¯Ø§Ø±Ù†Ø¯';
  static const String invalidPhone = 'Ø´Ù…Ø§Ø±Ù‡ ØªÙ„ÙÙ† Ù…Ø¹ØªØ¨Ø± Ù†ÛŒØ³Øª';

  // Status messages
  static const String loading = 'Ø¯Ø± Ø­Ø§Ù„ Ø¨Ø§Ø±Ú¯Ø°Ø§Ø±ÛŒ...';
  static const String saving = 'Ø¯Ø± Ø­Ø§Ù„ Ø°Ø®ÛŒØ±Ù‡...';
  static const String deleting = 'Ø¯Ø± Ø­Ø§Ù„ Ø­Ø°Ù...';
  static const String success = 'Ø¹Ù…Ù„ÛŒØ§Øª Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø§Ù†Ø¬Ø§Ù… Ø´Ø¯';
  static const String error = 'Ø®Ø·Ø§ Ø±Ø® Ø¯Ø§Ø¯';
  static const String noData = 'Ø¯Ø§Ø¯Ù‡â€ŒØ§ÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String noInternet = 'Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ù…ÙˆØ¬ÙˆØ¯ Ù†ÛŒØ³Øª';

  // User roles
  static const String student = 'Ø¯Ø§Ù†Ø´Ø¬Ùˆ';
  static const String professor = 'Ø§Ø³ØªØ§Ø¯';
  static const String manager = 'Ù…Ø¯ÛŒØ±';
  static const String admin = 'Ù…Ø¯ÛŒØ± Ø³ÛŒØ³ØªÙ…';

  // Sections
  static const String classes = 'Ú©Ù„Ø§Ø³â€ŒÙ‡Ø§';
  static const String units = 'ÙˆØ§Ø­Ø¯Ù‡Ø§';
  static const String services = 'Ø®Ø¯Ù…Ø§Øª';
  static const String tickets = 'Ø¯Ø±Ø®ÙˆØ§Ø³Øªâ€ŒÙ‡Ø§';
  static const String notifications = 'Ø§Ø¹Ù„Ø§Ù†â€ŒÙ‡Ø§';

  // Dialogs
  static const String confirmDelete = 'Ø¢ÛŒØ§ Ù…Ø·Ù…Ø¦Ù† Ù‡Ø³ØªÛŒØ¯ Ú©Ù‡ Ù…ÛŒâ€ŒØ®ÙˆØ§Ù‡ÛŒØ¯ Ø§ÛŒÙ† Ù…ÙˆØ±Ø¯ Ø±Ø§ Ø­Ø°Ù Ú©Ù†ÛŒØ¯ØŸ';
  static const String confirmLogout = 'Ø¢ÛŒØ§ Ù…Ø·Ù…Ø¦Ù† Ù‡Ø³ØªÛŒØ¯ Ú©Ù‡ Ù…ÛŒâ€ŒØ®ÙˆØ§Ù‡ÛŒØ¯ Ø®Ø§Ø±Ø¬ Ø´ÙˆÛŒØ¯ØŸ';
  static const String ok = 'ØªØ£ÛŒÛŒØ¯';
  static const String yes = 'Ø¨Ù„Ù‡';
  static const String no = 'Ø®ÛŒØ±';

  // Error messages
  static const String networkError = 'Ø®Ø·Ø§ÛŒ Ø´Ø¨Ú©Ù‡. Ù„Ø·ÙØ§Ù‹ Ø§ØªØµØ§Ù„ Ø§ÛŒÙ†ØªØ±Ù†Øª Ø®ÙˆØ¯ Ø±Ø§ Ø¨Ø±Ø±Ø³ÛŒ Ú©Ù†ÛŒØ¯';
  static const String serverError = 'Ø®Ø·Ø§ÛŒ Ø³Ø±ÙˆØ±. Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';
  static const String authError = 'Ø®Ø·Ø§ÛŒ Ø§Ø­Ø±Ø§Ø² Ù‡ÙˆÛŒØª. Ù„Ø·ÙØ§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ÙˆØ§Ø±Ø¯ Ø´ÙˆÛŒØ¯';
  static const String permissionError = 'Ø´Ù…Ø§ Ø§Ø¬Ø§Ø²Ù‡ Ø¯Ø³ØªØ±Ø³ÛŒ Ø¨Ù‡ Ø§ÛŒÙ† Ø¨Ø®Ø´ Ø±Ø§ Ù†Ø¯Ø§Ø±ÛŒØ¯';

  // Time and dates
  static const String today = 'Ø§Ù…Ø±ÙˆØ²';
  static const String yesterday = 'Ø¯ÛŒØ±ÙˆØ²';
  static const String tomorrow = 'ÙØ±Ø¯Ø§';
  static const String now = 'Ø§Ú©Ù†ÙˆÙ†';

  // Units and measurements
  static const String currency = 'ØªÙˆÙ…Ø§Ù†';
  static const String percentage = 'Ø¯Ø±ØµØ¯';
  static const String count = 'Ø¹Ø¯Ø¯';

  // Help and support
  static const String help = 'Ø±Ø§Ù‡Ù†Ù…Ø§';
  static const String support = 'Ù¾Ø´ØªÛŒØ¨Ø§Ù†ÛŒ';
  static const String contactUs = 'ØªÙ…Ø§Ø³ Ø¨Ø§ Ù…Ø§';
  static const String about = 'Ø¯Ø±Ø¨Ø§Ø±Ù‡ Ù…Ø§';

  // Empty states
  static const String noClasses = 'Ú©Ù„Ø§Ø³ÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String noNotifications = 'Ø§Ø¹Ù„Ø§Ù†ÛŒ ÙˆØ¬ÙˆØ¯ Ù†Ø¯Ø§Ø±Ø¯';
  static const String noTickets = 'Ø¯Ø±Ø®ÙˆØ§Ø³ØªÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯';
  static const String noServices = 'Ø³Ø±ÙˆÛŒØ³ÛŒ ÛŒØ§ÙØª Ù†Ø´Ø¯';

  // Success messages
  static const String loginSuccess = 'ÙˆØ±ÙˆØ¯ Ù…ÙˆÙÙ‚ÛŒØªâ€ŒØ¢Ù…ÛŒØ² Ø¨ÙˆØ¯';
  static const String saveSuccess = 'Ø§Ø·Ù„Ø§Ø¹Ø§Øª Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø°Ø®ÛŒØ±Ù‡ Ø´Ø¯';
  static const String deleteSuccess = 'Ù…ÙˆØ±Ø¯ Ø¨Ø§ Ù…ÙˆÙÙ‚ÛŒØª Ø­Ø°Ù Ø´Ø¯';
  static const String updateSuccess = 'Ø§Ø·Ù„Ø§Ø¹Ø§Øª Ø¨Ø±ÙˆØ²Ø±Ø³Ø§Ù†ÛŒ Ø´Ø¯';

  // Feature flags
  static const String featureComingSoon = 'Ø§ÛŒÙ† Ù‚Ø§Ø¨Ù„ÛŒØª Ø¨Ù‡ Ø²ÙˆØ¯ÛŒ Ø§Ø¶Ø§ÙÙ‡ Ø®ÙˆØ§Ù‡Ø¯ Ø´Ø¯';
  static const String featureDisabled = 'Ø§ÛŒÙ† Ù‚Ø§Ø¨Ù„ÛŒØª ØºÛŒØ±ÙØ¹Ø§Ù„ Ø§Ø³Øª';

  // Maintenance
  static const String maintenanceMode = 'Ø³ÛŒØ³ØªÙ… Ø¯Ø± Ø­Ø§Ù„ ØªØ¹Ù…ÛŒØ± Ùˆ Ù†Ú¯Ù‡Ø¯Ø§Ø±ÛŒ Ø§Ø³Øª';
  static const String maintenanceMessage = 'Ù„Ø·ÙØ§Ù‹ Ø¨Ø¹Ø¯Ø§Ù‹ Ø¯ÙˆØ¨Ø§Ø±Ù‡ ØªÙ„Ø§Ø´ Ú©Ù†ÛŒØ¯';

  // Accessibility
  static const String accessibilityLabel = 'Ø¨Ø±Ú†Ø³Ø¨ Ø¯Ø³ØªØ±Ø³ÛŒ';
  static const String accessibilityHint = 'Ø±Ø§Ù‡Ù†Ù…Ø§ÛŒÛŒ Ø¯Ø³ØªØ±Ø³ÛŒ';

  /// Get localized string by key
  static String getString(String key, {String? defaultValue}) {
    switch (key) {
      case 'appName':
        return appName;
      case 'home':
        return home;
      case 'dashboard':
        return dashboard;
      case 'profile':
        return profile;
      case 'settings':
        return settings;
      case 'login':
        return login;
      case 'logout':
        return logout;
      case 'save':
        return save;
      case 'cancel':
        return cancel;
      case 'delete':
        return delete;
      case 'edit':
        return edit;
      case 'add':
        return add;
      case 'search':
        return search;
      case 'loading':
        return loading;
      case 'success':
        return success;
      case 'error':
        return error;
      case 'noData':
        return noData;
      case 'classes':
        return classes;
      case 'units':
        return units;
      case 'services':
        return services;
      case 'tickets':
        return tickets;
      case 'notifications':
        return notifications;
      default:
        return defaultValue ?? key;
    }
  }
}

