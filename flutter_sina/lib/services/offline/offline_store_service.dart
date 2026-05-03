import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/sync/sync_queue_item.dart';

class OfflineStoreService {
  static const String _syncQueueKey = 'offline_sync_queue_v1';
  static const String _cachePrefix = 'offline_cache_';

  Future<List<SyncQueueItem>> readQueue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString(_syncQueueKey) ?? '[]';
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;

    return decoded
        .map((dynamic item) => SyncQueueItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> saveQueue(List<SyncQueueItem> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = jsonEncode(items.map((SyncQueueItem item) => item.toJson()).toList());
    await prefs.setString(_syncQueueKey, raw);
  }

  Future<void> addToQueue(SyncQueueItem item) async {
    final List<SyncQueueItem> items = await readQueue();
    items.add(item);
    await saveQueue(items);
  }

  Future<void> removeFromQueue(String id) async {
    final List<SyncQueueItem> items = await readQueue();
    items.removeWhere((SyncQueueItem item) => item.id == id);
    await saveQueue(items);
  }

  Future<void> saveTableCache(String tableName, List<Map<String, dynamic>> rows) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_cachePrefix$tableName', jsonEncode(rows));
  }

  Future<List<Map<String, dynamic>>> readTableCache(String tableName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString('$_cachePrefix$tableName') ?? '[]';
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;

    return decoded.map((dynamic item) {
      return Map<String, dynamic>.from(item as Map);
    }).toList();
  }

  Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();

    for (final String key in keys) {
      if (key == _syncQueueKey || key.startsWith(_cachePrefix)) {
        await prefs.remove(key);
      }
    }
  }
}

