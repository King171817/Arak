import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/supabase_config.dart';

class AppSupabaseService {
  AppSupabaseService._();

  static bool _initialized = false;

  static bool get isConfigured => SupabaseConfig.isConfigured;
  static bool get isInitialized => _initialized;

  static SupabaseClient? get client {
    if (!_initialized || !SupabaseConfig.isConfigured) {
      return null;
    }

    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (!SupabaseConfig.isConfigured) {
      _initialized = false;
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );

    _initialized = true;
  }
}

