import 'package:flutter/material.dart';

import 'app/modular_app.dart';
import 'core/core.dart';
import 'services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure logging
  AppLogger.configure(
    enableConsoleLogs: AppConfig.loggingConfig.enableConsoleLogs,
    minLevel: AppConfig.loggingConfig.minLogLevel,
  );

  AppLogger.info('main', AppConfig.getConfigSummary());

  try {
    // Initialize Supabase
    AppLogger.info('main', 'Initializing Supabase...');
    await AppSupabaseService.initialize();
    AppLogger.info('main', 'Supabase initialized successfully');

    // Initialize offline store
    AppLogger.info('main', 'Initializing offline store...');
    final OfflineStoreService offlineStore = OfflineStoreService();

    // Initialize sync service
    AppLogger.info('main', 'Starting sync service...');
    final AppSyncService syncService = AppSyncService(offlineStore: offlineStore);
    syncService.startAutoSync();
    await syncService.syncNow();
    AppLogger.info('main', 'Sync service started');

    // Initialize monitoring service
    AppLogger.info('main', 'Starting monitoring service...');
    final AppMonitoringService monitoringService = AppMonitoringService(
      offlineStore: offlineStore,
      syncService: syncService,
    );
    AppMonitoringService.setupFlutterErrorHandling(monitoringService);
    AppLogger.info('main', 'Monitoring service started');

    // Initialize Supabase bootstrap
    AppLogger.info('main', 'Bootstrapping Supabase...');
    await SupabaseBootstrap.initializeIfConfigured();
    AppLogger.info('main', 'Supabase bootstrap completed');

    // Run app
    AppLogger.info('main', 'Starting application...');
    runApp(const ModularApp());
  } catch (e, stackTrace) {
    AppLogger.error(
      'main',
      'Failed to initialize application',
      exception: e as Exception?,
      stackTrace: stackTrace,
    );

    // Run fallback error UI
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'خطا در راه‌اندازی برنامه',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







