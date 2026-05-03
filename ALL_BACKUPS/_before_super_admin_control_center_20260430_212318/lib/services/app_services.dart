import '../config/config.dart';
import '../repositories/auth/auth_repository.dart';
import '../repositories/classes/classes_repository.dart';
import '../repositories/mock/mock_repositories.dart';
import '../repositories/settings/settings_repository.dart';
import '../repositories/supabase/supabase_repositories.dart';
import '../repositories/tickets/tickets_repository.dart';
import '../repositories/users/users_repository.dart';
import 'supabase_bootstrap.dart';

class AppServices {
  AppServices._();

  static bool get useSupabase {
    return SupabaseConfig.isConfigured && SupabaseBootstrap.isInitialized;
  }

  static AuthRepository get authRepository {
    if (useSupabase) {
      return SupabaseAuthRepository();
    }

    return MockAuthRepository();
  }

  static ClassesRepository get classesRepository {
    if (useSupabase) {
      return SupabaseClassesRepository();
    }

    return MockClassesRepository();
  }

  static TicketsRepository get ticketsRepository {
    if (useSupabase) {
      return SupabaseTicketsRepository();
    }

    return MockTicketsRepository();
  }

  static UsersRepository get usersRepository {
    return MockUsersRepository();
  }

  static SettingsRepository get settingsRepository {
    return MockSettingsRepository();
  }
}
