import 'package:connectivity_plus/connectivity_plus.dart';

import '../../models/sync/sync_queue_item.dart';
import '../offline/offline_store_service.dart';
import '../supabase/app_supabase_service.dart';

class AppSyncService {
  final OfflineStoreService offlineStore;

  AppSyncService({
    required this.offlineStore,
  });

  Future<bool> get isOnline async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Future<void> enqueue({
    required String tableName,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final SyncQueueItem item = SyncQueueItem(
      id: 'sync_${DateTime.now().millisecondsSinceEpoch}',
      tableName: tableName,
      action: action,
      payload: payload,
      createdAt: DateTime.now(),
      retryCount: 0,
      status: 'pending',
    );

    await offlineStore.addToQueue(item);
  }

  Future<void> syncNow() async {
    final bool online = await isOnline;
    final client = AppSupabaseService.client;

    if (!online || client == null) {
      return;
    }

    final List<SyncQueueItem> queue = await offlineStore.readQueue();

    for (final SyncQueueItem item in queue) {
      try {
        if (item.action == 'insert') {
          await client.from(item.tableName).insert(item.payload);
        } else if (item.action == 'update') {
          final String id = item.payload['id']?.toString() ?? '';
          if (id.isNotEmpty) {
            await client.from(item.tableName).update(item.payload).eq('id', id);
          }
        } else if (item.action == 'delete') {
          final String id = item.payload['id']?.toString() ?? '';
          if (id.isNotEmpty) {
            await client.from(item.tableName).delete().eq('id', id);
          }
        }

        await offlineStore.removeFromQueue(item.id);
      } catch (_) {
        final List<SyncQueueItem> current = await offlineStore.readQueue();
        final int index = current.indexWhere((SyncQueueItem q) => q.id == item.id);

        if (index != -1) {
          current[index] = item.copyWith(
            retryCount: item.retryCount + 1,
            status: 'failed',
          );
          await offlineStore.saveQueue(current);
        }
      }
    }
  }

  void startAutoSync() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      if (!results.contains(ConnectivityResult.none)) {
        await syncNow();
      }
    });
  }
}

