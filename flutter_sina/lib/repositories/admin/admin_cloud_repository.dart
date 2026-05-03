import '../../services/offline/offline_store_service.dart';
import '../../services/supabase/app_supabase_service.dart';
import '../../services/sync/app_sync_service.dart';

class AdminCloudRepository {
  final OfflineStoreService offlineStore;
  final AppSyncService syncService;

  AdminCloudRepository({
    required this.offlineStore,
    required this.syncService,
  });

  Future<List<Map<String, dynamic>>> loadTable(String tableName) async {
    final client = AppSupabaseService.client;

    if (client == null) {
      return offlineStore.readTableCache(tableName);
    }

    try {
      final List<dynamic> response = await client.from(tableName).select();
      final List<Map<String, dynamic>> rows = response.map((dynamic item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();

      await offlineStore.saveTableCache(tableName, rows);
      return rows;
    } catch (_) {
      return offlineStore.readTableCache(tableName);
    }
  }

  Future<void> upsert({
    required String tableName,
    required Map<String, dynamic> payload,
  }) async {
    final client = AppSupabaseService.client;
    final bool online = await syncService.isOnline;

    if (client != null && online) {
      try {
        await client.from(tableName).upsert(payload);
        return;
      } catch (_) {
        await syncService.enqueue(
          tableName: tableName,
          action: 'update',
          payload: payload,
        );
        return;
      }
    }

    await syncService.enqueue(
      tableName: tableName,
      action: 'update',
      payload: payload,
    );
  }

  Future<void> insert({
    required String tableName,
    required Map<String, dynamic> payload,
  }) async {
    final client = AppSupabaseService.client;
    final bool online = await syncService.isOnline;

    if (client != null && online) {
      try {
        await client.from(tableName).insert(payload);
        return;
      } catch (_) {
        await syncService.enqueue(
          tableName: tableName,
          action: 'insert',
          payload: payload,
        );
        return;
      }
    }

    await syncService.enqueue(
      tableName: tableName,
      action: 'insert',
      payload: payload,
    );
  }
}

