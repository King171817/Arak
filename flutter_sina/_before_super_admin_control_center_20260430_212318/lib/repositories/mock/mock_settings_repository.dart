import '../../models/models.dart';
import '../settings/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  FloatingAnnouncementModel? _announcement;
  final List<SystemLockModel> _locks = <SystemLockModel>[];

  @override
  Future<FloatingAnnouncementModel?> fetchFloatingAnnouncement() async {
    return _announcement;
  }

  @override
  Future<void> saveFloatingAnnouncement(
    FloatingAnnouncementModel announcement,
  ) async {
    _announcement = announcement;
  }

  @override
  Future<List<SystemLockModel>> fetchSystemLocks() async {
    return List<SystemLockModel>.unmodifiable(_locks);
  }

  @override
  Future<void> saveSystemLock(SystemLockModel lock) async {
    final int index = _locks.indexWhere((SystemLockModel item) => item.id == lock.id);

    if (index == -1) {
      _locks.add(lock);
    } else {
      _locks[index] = lock;
    }
  }
}
