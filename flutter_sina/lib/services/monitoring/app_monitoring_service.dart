import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../offline/offline_store_service.dart';
import '../supabase/app_supabase_service.dart';
import '../sync/app_sync_service.dart';

class AppMonitoringService {
  final OfflineStoreService offlineStore;
  final AppSyncService syncService;

  AppMonitoringService({
    required this.offlineStore,
    required this.syncService,
  });

  Future<void> reportError({
    required Object error,
    StackTrace? stackTrace,
    String source = 'app',
    Map<String, dynamic> extra = const <String, dynamic>{},
  }) async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    final Map<String, dynamic> payload = <String, dynamic>{
      'id': 'err_${DateTime.now().millisecondsSinceEpoch}',
      'source': source,
      'message': error.toString(),
      'stack_trace': stackTrace?.toString() ?? '',
      'app_version': info.version,
      'build_number': info.buildNumber,
      'extra': jsonEncode(extra),
      'created_at': DateTime.now().toIso8601String(),
    };

    final client = AppSupabaseService.client;

    if (client != null && await syncService.isOnline) {
      try {
        await client.from('error_reports').insert(payload);
        return;
      } catch (_) {}
    }

    await syncService.enqueue(
      tableName: 'error_reports',
      action: 'insert',
      payload: payload,
    );

    log('Error queued: ${payload['message']}');
  }

  Future<void> logActivity({
    required String actorId,
    required String actorName,
    required String action,
    required String targetType,
    required String targetId,
    String details = '',
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'id': 'act_${DateTime.now().millisecondsSinceEpoch}',
      'actor_id': actorId,
      'actor_name': actorName,
      'action': action,
      'target_type': targetType,
      'target_id': targetId,
      'details': details,
      'created_at': DateTime.now().toIso8601String(),
    };

    final client = AppSupabaseService.client;

    if (client != null && await syncService.isOnline) {
      try {
        await client.from('activity_logs').insert(payload);
        return;
      } catch (_) {}
    }

    await syncService.enqueue(
      tableName: 'activity_logs',
      action: 'insert',
      payload: payload,
    );
  }

  Future<void> createBackupRecord({
    required String title,
    required String backupType,
    String description = '',
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'id': 'backup_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'backup_type': backupType,
      'description': description,
      'status': 'created',
      'created_at': DateTime.now().toIso8601String(),
    };

    final client = AppSupabaseService.client;

    if (client != null && await syncService.isOnline) {
      try {
        await client.from('backup_jobs').insert(payload);
        return;
      } catch (_) {}
    }

    await syncService.enqueue(
      tableName: 'backup_jobs',
      action: 'insert',
      payload: payload,
    );
  }

  static void setupFlutterErrorHandling(AppMonitoringService service) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      service.reportError(
        error: details.exception,
        stackTrace: details.stack,
        source: 'flutter_error',
        extra: <String, dynamic>{
          'library': details.library ?? '',
          'context': details.context?.toString() ?? '',
        },
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      service.reportError(
        error: error,
        stackTrace: stack,
        source: 'platform_dispatcher',
      );
      return true;
    };
  }
}

