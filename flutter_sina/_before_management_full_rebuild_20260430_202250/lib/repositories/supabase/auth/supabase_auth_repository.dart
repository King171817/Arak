import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../auth/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  @override
  Future<AppUserModel?> login({
    required String username,
    required String password,
  }) async {
    final client = SupabaseBootstrap.client;

    if (client == null) {
      throw Exception('supabase_not_initialized');
    }

    final response = await client
        .from('app_users')
        .select()
        .eq('username', username)
        .eq('password', password)
        .maybeSingle();

    if (response == null) return null;

    return AppUserModel(
      id: response['id'].toString(),
      username: response['username'].toString(),
      displayName: response['display_name'].toString(),
      role: AppRole.values.firstWhere(
        (AppRole role) => role.name == response['role'].toString(),
        orElse: () => AppRole.guest,
      ),
      unitKey: response['unit_key'].toString(),
      permissions: <AppPermission>[],
      isLocked: response['is_locked'] == true,
    );
  }
}
