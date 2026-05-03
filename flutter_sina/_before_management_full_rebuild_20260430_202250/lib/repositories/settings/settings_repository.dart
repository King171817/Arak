import '../../models/models.dart';

abstract class SettingsRepository {
  Future<FloatingAnnouncementModel?> fetchFloatingAnnouncement();
  Future<void> saveFloatingAnnouncement(FloatingAnnouncementModel announcement);

  Future<List<SystemLockModel>> fetchSystemLocks();
  Future<void> saveSystemLock(SystemLockModel lock);
}
