import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static const String tokenKey = 'accessToken';
  static const String roleKey = 'userRole';
  static const String emailKey = 'userEmail';
  static const String fullNameKey = 'userFullName';

  static Future<Map<String, String>> _headers({bool jsonBody = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    return {
      if (jsonBody) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(data['message'] ?? 'Login failed');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, data['accessToken'] ?? '');
    await prefs.setString(roleKey, data['user']?['role'] ?? '');
    await prefs.setString(emailKey, data['user']?['email'] ?? '');
    await prefs.setString(fullNameKey, data['user']?['fullName'] ?? '');

    return data;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(roleKey);
    await prefs.remove(emailKey);
    await prefs.remove(fullNameKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey);
  }

  static Future<List<dynamic>> getMyRequests() async {
    final res = await http.get(
      Uri.parse('$baseUrl/requests'),
      headers: await _headers(),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to get requests');
    }

    return data['data'] ?? [];
  }

  static Future<Map<String, dynamic>> createRequest({
    required String type,
    required String priority,
    required Map<String, dynamic> details,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/requests'),
      headers: await _headers(),
      body: jsonEncode({
        'type': type,
        'priority': priority,
        'details': details,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(data['message'] ?? 'Failed to create request');
    }

    return data['data'];
  }

  static Future<List<dynamic>> getAdminRequests() async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/requests'),
      headers: await _headers(),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to get admin requests');
    }

    return data['data'] ?? [];
  }

  static Future<Map<String, dynamic>> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final res = await http.put(
      Uri.parse('$baseUrl/admin/requests/$requestId/status'),
      headers: await _headers(),
      body: jsonEncode({
        'status': status,
      }),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to update status');
    }

    return data['data'];
  }
}
