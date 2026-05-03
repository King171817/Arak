import '../../models/models.dart';

abstract class AuthRepository {
  Future<AppUserModel?> login({
    required String username,
    required String password,
  });
}
