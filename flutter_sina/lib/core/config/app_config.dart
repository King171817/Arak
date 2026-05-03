// Application configuration and environment setup
// Centralizes all application configuration in one place
import 'package:flutter/foundation.dart';

class AppConfig {
  /// Application name
  static const String appName = 'testapp2';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  /// Debug mode flag
  static bool isDebugMode = kDebugMode;

  // Network configuration
  static const int networkRequestTimeout = 30;
  static const int networkConnectionTimeout = 15;
  static const int networkReceiveTimeout = 30;
  static const int networkMaxRetries = 3;
  static const int networkRetryDelayMs = 1000;

  // Cache configuration
  static const int cacheApiDurationHours = 24;
  static const int cacheUserDataDurationHours = 1;
  static const int cacheMaxSizeMB = 50;

  // Feature flags
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = !kDebugMode;
  static const bool enablePerformanceMonitoring = true;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = true;

  // API endpoints
  static const String apiSupabaseUrl = 'https://your-supabase-url.supabase.co';
  static const String apiSupabaseAnonKey = 'your-anon-key';
  static const String apiBasePath = '/rest/v1';

  // AI support configuration
  static const String apiAiEndpoint = '';
  static const String apiAiKey = '';
  static const String apiAiModel = 'gpt-3.5-turbo';

  static bool get aiSupportEnabled => apiAiEndpoint.isNotEmpty && apiAiKey.isNotEmpty;

  // Logging configuration
  static const bool loggingEnableConsole = kDebugMode;
  static const bool loggingEnableFile = !kDebugMode;
  static const int loggingMinLevel = kDebugMode ? 0 : 2;

  static const LoggingConfig loggingConfig = LoggingConfig(
    enableConsoleLogs: loggingEnableConsole,
    enableFileLogs: loggingEnableFile,
    minLogLevel: loggingMinLevel,
  );

  // UI configuration
  static const bool uiEnableAnimations = true;
  static const int uiAnimationDurationMs = 300;
  static const bool uiEnableHapticFeedback = true;

  /// Get configuration summary
  static String getConfigSummary() {
    return '''
App Configuration:
- Name: $appName
- Version: $appVersion (Build: $buildNumber)
- Debug Mode: $isDebugMode
- Network Timeout: ${networkRequestTimeout}s
- Max Retries: $networkMaxRetries
- Offline Mode: $enableOfflineMode
- Analytics: $enableAnalytics
    ''';
  }
}

class LoggingConfig {
  final bool enableConsoleLogs;
  final bool enableFileLogs;
  final int minLogLevel;

  const LoggingConfig({
    required this.enableConsoleLogs,
    required this.enableFileLogs,
    required this.minLogLevel,
  });
}


