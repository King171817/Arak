import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static const String baseUrl = 'http://localhost:3001';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
      }),
    );

    final Map<String, dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['message'] ?? 'login_failed');
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', data['accessToken'].toString());
    await prefs.setString('refreshToken', data['refreshToken'].toString());

    return data;
  }
}
