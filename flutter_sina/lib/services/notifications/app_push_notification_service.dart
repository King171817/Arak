import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../supabase/app_supabase_service.dart';
import '../sync/app_sync_service.dart';

@pragma('vm:entry-point')
Future<void> appFirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class AppPushNotificationService {
  final AppSyncService syncService;

  AppPushNotificationService({
    required this.syncService,
  });

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize({
    required String userId,
    required String role,
    required String unitKey,
  }) async {
    try {
      await Firebase.initializeApp();
    } catch (_) {
      return;
    }

    FirebaseMessaging.onBackgroundMessage(appFirebaseMessagingBackgroundHandler);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: initSettings);

    final String? token = await _messaging.getToken();
    if (token != null) {
      await saveToken(
        token: token,
        userId: userId,
        role: role,
        unitKey: unitKey,
      );
    }

    _messaging.onTokenRefresh.listen((String token) async {
      await saveToken(
        token: token,
        userId: userId,
        role: role,
        unitKey: unitKey,
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showForegroundNotification(message);
    });
  }

  Future<void> saveToken({
    required String token,
    required String userId,
    required String role,
    required String unitKey,
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'id': '${userId}_${token.hashCode}',
      'user_id': userId,
      'role': role,
      'unit_key': unitKey,
      'fcm_token': token,
      'platform': defaultTargetPlatform.name,
      'active': true,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final client = AppSupabaseService.client;

    if (client != null && await syncService.isOnline) {
      try {
        await client.from('push_tokens').upsert(payload);
        return;
      } catch (_) {}
    }

    await syncService.enqueue(
      tableName: 'push_tokens',
      action: 'update',
      payload: payload,
    );
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;

    final String title =
        notification?.title ?? message.data['title']?.toString() ?? 'اعلان';
    final String body =
        notification?.body ?? message.data['body']?.toString() ?? '';

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'main_channel',
      'Main Notifications',
      channelDescription: 'University app notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }
}



