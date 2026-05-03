import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/admin/backend_floating_message_model.dart';

class AdminAdvancedRepository {
  static const String baseUrl = 'http://localhost:3001';

  Future<List<BackendFloatingMessageModel>> fetchFloatingMessages() async {
    final uri = Uri.parse('$baseUrl/admin-advanced/floating-message');
    final response = await http.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load floating messages: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(BackendFloatingMessageModel.fromJson)
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      return [BackendFloatingMessageModel.fromJson(decoded)];
    }

    return <BackendFloatingMessageModel>[];
  }

  Future<void> createFloatingMessage({
    required String textFa,
    required String textEn,
    required String textAr,
    required DateTime startAt,
    required DateTime endAt,
    required List<String> roles,
    required List<String> units,
    required List<String> userIds,
    required bool isActive,
  }) async {
    final uri = Uri.parse('$baseUrl/admin-advanced/floating-message');

    final body = jsonEncode({
      'textFa': textFa,
      'textEn': textEn,
      'textAr': textAr,
      'startAt': startAt.toUtc().toIso8601String(),
      'endAt': endAt.toUtc().toIso8601String(),
      'roles': roles,
      'units': units,
      'userIds': userIds,
      'isActive': isActive,
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create floating message: ${response.statusCode}');
    }
  }
}
