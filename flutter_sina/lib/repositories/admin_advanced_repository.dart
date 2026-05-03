import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/admin/access_rule_model.dart';
import '../models/admin/backend_daily_report_model.dart';
import '../models/admin/backend_admin_user_model.dart';
import '../models/admin/backend_floating_message_model.dart';
import '../models/admin/dataset_setting_model.dart';

class AdminAdvancedRepository {
  static const String baseUrl = 'http://localhost:3001';

  Future<List<BackendFloatingMessageModel>> fetchFloatingMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/admin-advanced/floating-message'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load floating messages: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().map(BackendFloatingMessageModel.fromJson).toList();
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
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/floating-message'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'textFa': textFa,
        'textEn': textEn,
        'textAr': textAr,
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
        'roles': roles,
        'units': units,
        'userIds': userIds,
        'isActive': isActive,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create floating message: ${response.statusCode}');
    }
  }

  Future<List<AccessRuleModel>> fetchAccessRules() async {
    final response = await http.get(Uri.parse('$baseUrl/admin-advanced/access-rule'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load access rules: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().map(AccessRuleModel.fromJson).toList();
    }
    return <AccessRuleModel>[];
  }

  Future<void> saveAccessRule({
    required String userId,
    required String role,
    required String unit,
    required List<String> permissions,
    required bool isLocked,
    required String updatedBy,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/access-rule'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'role': role,
        'unit': unit,
        'permissions': permissions,
        'isLocked': isLocked,
        'updatedBy': updatedBy,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to save access rule: ${response.statusCode}');
    }
  }

  Future<List<BackendDailyReportModel>> fetchDailyReports() async {
    final response = await http.get(Uri.parse('$baseUrl/admin-advanced/daily-report'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load daily reports: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().map(BackendDailyReportModel.fromJson).toList();
    }
    return <BackendDailyReportModel>[];
  }

  Future<void> createDailyReport({
    required String userId,
    required String userName,
    required String role,
    required String unit,
    required String title,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/daily-report'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'userName': userName,
        'role': role,
        'unit': unit,
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create daily report: ${response.statusCode}');
    }
  }

  Future<void> updateDailyReport({
    required String id,
    required String title,
    required String description,
    required bool isMainAdmin,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin-advanced/daily-report/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'isMainAdmin': isMainAdmin,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update daily report: ${response.statusCode}');
    }
  }
  Future<DatasetSettingModel> fetchDatasetSetting() async {
    final response = await http.get(Uri.parse('$baseUrl/admin-advanced/dataset-setting'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load dataset setting: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return DatasetSettingModel.fromJson(decoded);
    }

    return const DatasetSettingModel(
      apiBaseUrl: 'http://localhost:3001',
      databaseUrl: '',
      useApi: true,
      useMock: true,
      updatedBy: '',
    );
  }

  Future<void> saveDatasetSetting({
    required String apiBaseUrl,
    required String databaseUrl,
    required bool useApi,
    required bool useMock,
    required String updatedBy,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/dataset-setting'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'apiBaseUrl': apiBaseUrl,
        'databaseUrl': databaseUrl,
        'useApi': useApi,
        'useMock': useMock,
        'updatedBy': updatedBy,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to save dataset setting: ${response.statusCode}');
    }
  }
  Future<AccessRuleModel?> fetchAccessRuleByUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/admin-advanced/access-rule/$userId'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load user access rule: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded == null) {
      return null;
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded.isEmpty) return null;
      return AccessRuleModel.fromJson(decoded);
    }

    return null;
  }
  Future<List<BackendAdminUserModel>> searchAdminUsers(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/users/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to search users: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded.whereType<Map<String, dynamic>>().map(BackendAdminUserModel.fromJson).toList();
    }

    return <BackendAdminUserModel>[];
  }

  Future<void> createAdminUser({
    required String username,
    required String password,
    required String fullName,
    required String role,
    required String unit,
    required String email,
    required String phone,
    required String passportNo,
    required String studentNo,
    required bool isLocked,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin-advanced/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'fullName': fullName,
        'role': role,
        'unit': unit,
        'email': email,
        'phone': phone,
        'passportNo': passportNo,
        'studentNo': studentNo,
        'isLocked': isLocked,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }

  Future<void> updateAdminUser({
    required String id,
    required String fullName,
    required String role,
    required String unit,
    required String email,
    required String phone,
    required String passportNo,
    required String studentNo,
    required bool isLocked,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin-advanced/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'role': role,
        'unit': unit,
        'email': email,
        'phone': phone,
        'passportNo': passportNo,
        'studentNo': studentNo,
        'isLocked': isLocked,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  Future<void> changeAdminUserPassword({
    required String id,
    required String password,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin-advanced/users/$id/password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to change password: ${response.statusCode}');
    }
  }

  Future<void> lockAdminUser({
    required String id,
    required bool isLocked,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin-advanced/users/$id/lock'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'isLocked': isLocked}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to lock user: ${response.statusCode}');
    }
  }
}
