import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/config.dart';

class SupabaseBootstrap {
  SupabaseBootstrap._();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initializeIfConfigured() async {
    if (_initialized) return;

    if (!SupabaseConfig.isConfigured) {
      debugPrint('Supabase is not configured. App will continue with mock repositories.');
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );

    _initialized = true;
    debugPrint('Supabase initialized successfully.');
  }

  static SupabaseClient? get client {
    if (!_initialized) return null;
    return Supabase.instance.client;
  }
}
