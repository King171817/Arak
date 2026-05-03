import '../core/http/api_service.dart';


class AuthApi {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _apiService.post('auth/login', body: {
      'username': username,
      'password': password,
    });
    return response;
  }
}