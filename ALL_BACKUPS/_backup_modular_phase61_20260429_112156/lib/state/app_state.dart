import 'package:flutter/material.dart';

import '../core/constants/unit_keys.dart';
import '../data/mock/mock_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  AppLang _selectedLang = AppLang.fa;
  AppUserModel? _currentUser;
  bool _isDarkMode = false;
  String _selectedLogoKey = 'default';
  String _selectedBackgroundKey = 'spring';
  bool _maintenanceMode = false;
  bool _registrationEnabled = true;
  String _maintenanceMessageFa = 'سامانه موقتاً در حال بروزرسانی است.';
  String _maintenanceMessageEn = 'The system is temporarily under maintenance.';
  String _maintenanceMessageAr = 'النظام قيد الصيانة مؤقتاً.';

  final List<AppNotificationModel> _notifications =
      List<AppNotificationModel>.from(mockNotifications);

  final List<EducationManagedClassModel> _educationClasses =
      List<EducationManagedClassModel>.from(mockEducationClasses);

  final List<EducationOfficerModel> _educationOfficers =
      List<EducationOfficerModel>.from(mockEducationOfficers);

  final List<InterManagerMessage> _managerMessages =
      List<InterManagerMessage>.from(mockManagerMessages);

  FloatingAnnouncementModel? _floatingAnnouncement;
  final Set<String> _dismissedAnnouncementForSession = <String>{};

  AppLang get selectedLang => _selectedLang;
  AppUserModel? get currentUser => _currentUser;
  AppRole get currentRole => _currentUser?.role ?? AppRole.guest;
  String get currentUnitKey => _currentUser?.unitKey ?? '';
  bool get isLoggedIn => _currentUser != null;
  bool get isDarkMode => _isDarkMode;
  String get selectedLogoKey => _selectedLogoKey;
  String get selectedBackgroundKey => _selectedBackgroundKey;
  bool get maintenanceMode => _maintenanceMode;
  bool get registrationEnabled => _registrationEnabled;

  List<AppNotificationModel> get notifications =>
      List<AppNotificationModel>.unmodifiable(_notifications);

  List<EducationManagedClassModel> get educationClasses =>
      List<EducationManagedClassModel>.unmodifiable(_educationClasses);

  List<EducationOfficerModel> get educationOfficers =>
      List<EducationOfficerModel>.unmodifiable(_educationOfficers);

  List<InterManagerMessage> get managerMessages =>
      List<InterManagerMessage>.unmodifiable(_managerMessages);

  bool get isSuperAdmin => currentRole == AppRole.superAdmin;

  bool get isEducationManager {
    return currentRole == AppRole.educationManager ||
        (currentRole == AppRole.unitManager && currentUnitKey == UnitKeys.education);
  }

  bool get isEducationOfficer {
    return currentRole == AppRole.educationOfficer ||
        (currentRole == AppRole.unitOfficer && currentUnitKey == UnitKeys.education);
  }

  String maintenanceMessageForCurrentLang() {
    switch (_selectedLang) {
      case AppLang.fa:
        return _maintenanceMessageFa;
      case AppLang.en:
        return _maintenanceMessageEn;
      case AppLang.ar:
        return _maintenanceMessageAr;
    }
  }

  bool get canSeeClassesInBottomNav {
    return currentRole == AppRole.student ||
        currentRole == AppRole.professor ||
        isEducationManager ||
        isEducationOfficer;
  }

  void setLanguage(AppLang lang) {
    if (_selectedLang == lang) return;
    _selectedLang = lang;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void login(AppUserModel user) {
    _currentUser = user;
    _dismissedAnnouncementForSession.clear();
    notifyListeners();
  }

  void loginDemo({
    required String username,
    required String password,
  }) {
    if (password != '1234') {
      throw Exception('incorrect_credentials');
    }

    final AppUserModel? user = _demoUserByUsername(username);
    if (user == null) {
      throw Exception('incorrect_credentials');
    }

    login(user);
  }

  AppUserModel? _demoUserByUsername(String username) {
    switch (username) {
      case 'admin':
        return const AppUserModel(
          id: 'student_admin',
          username: 'admin',
          displayName: 'دانشجو نمونه',
          role: AppRole.student,
          unitKey: 'student',
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewClasses,
          ],
        );

      case 'prof1':
        return const AppUserModel(
          id: 'p001',
          username: 'prof1',
          displayName: 'دکتر محمدی',
          role: AppRole.professor,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewClasses,
            AppPermission.chatWithManagers,
          ],
        );

      case 'prof2':
        return const AppUserModel(
          id: 'p002',
          username: 'prof2',
          displayName: 'Dr. Johnson',
          role: AppRole.professor,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewClasses,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin1':
        return const AppUserModel(
          id: 'manager_international',
          username: 'admin1',
          displayName: 'مدیر امور بین‌الملل',
          role: AppRole.unitManager,
          unitKey: UnitKeys.international,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin2':
        return const AppUserModel(
          id: 'manager_education',
          username: 'admin2',
          displayName: 'مدیر آموزش',
          role: AppRole.educationManager,
          unitKey: UnitKeys.education,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.editStudents,
            AppPermission.viewClasses,
            AppPermission.manageClasses,
            AppPermission.createClass,
            AppPermission.editClass,
            AppPermission.deleteClass,
            AppPermission.viewReports,
            AppPermission.manageOfficers,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin3':
        return const AppUserModel(
          id: 'manager_student_services',
          username: 'admin3',
          displayName: 'مدیر خدمات دانشجویی',
          role: AppRole.unitManager,
          unitKey: UnitKeys.studentServices,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'admin4':
        return const AppUserModel(
          id: 'manager_consular',
          username: 'admin4',
          displayName: 'مدیر کنسولی',
          role: AppRole.unitManager,
          unitKey: UnitKeys.consular,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.viewUnits,
            AppPermission.viewStudents,
            AppPermission.chatWithManagers,
          ],
        );

      case 'sina':
        return const AppUserModel(
          id: 'super_admin_sina',
          username: 'sina',
          displayName: 'sina',
          role: AppRole.superAdmin,
          unitKey: UnitKeys.adminMain,
          permissions: <AppPermission>[
            AppPermission.viewDashboard,
            AppPermission.manageGlobalSettings,
            AppPermission.manageFloatingAnnouncements,
            AppPermission.manageBackground,
            AppPermission.manageLogo,
            AppPermission.lockUsers,
            AppPermission.lockSections,
            AppPermission.manageRoles,
            AppPermission.managePermissions,
            AppPermission.viewReports,
            AppPermission.manageReports,
            AppPermission.chatWithManagers,
          ],
        );

      default:
        final EducationOfficerModel? educationOfficer =
            _findEducationOfficerByUsername(username);
        if (educationOfficer != null && educationOfficer.isActive) {
          return AppUserModel(
            id: educationOfficer.id,
            username: educationOfficer.username,
            displayName: educationOfficer.name,
            role: AppRole.educationOfficer,
            unitKey: UnitKeys.education,
            permissions: _mapEducationPermissions(educationOfficer.permissions),
          );
        }

        return null;
    }
  }

  EducationOfficerModel? _findEducationOfficerByUsername(String username) {
    try {
      return _educationOfficers.firstWhere(
        (EducationOfficerModel officer) => officer.username == username,
      );
    } catch (_) {
      return null;
    }
  }

  List<AppPermission> _mapEducationPermissions(
    List<EducationPermission> permissions,
  ) {
    final Set<AppPermission> mapped = <AppPermission>{
      AppPermission.viewDashboard,
      AppPermission.viewUnits,
    };

    if (permissions.contains(EducationPermission.viewReports)) {
      mapped.add(AppPermission.viewReports);
    }
    if (permissions.contains(EducationPermission.manageClasses)) {
      mapped.add(AppPermission.manageClasses);
      mapped.add(AppPermission.viewClasses);
    }
    if (permissions.contains(EducationPermission.createClass)) {
      mapped.add(AppPermission.createClass);
    }
    if (permissions.contains(EducationPermission.editClass)) {
      mapped.add(AppPermission.editClass);
    }
    if (permissions.contains(EducationPermission.deleteClass)) {
      mapped.add(AppPermission.deleteClass);
    }
    if (permissions.contains(EducationPermission.manageStudents)) {
      mapped.add(AppPermission.viewStudents);
      mapped.add(AppPermission.editStudents);
    }
    if (permissions.contains(EducationPermission.privateChat)) {
      mapped.add(AppPermission.chatWithManagers);
    }
    if (permissions.contains(EducationPermission.manageProfessors)) {
      mapped.add(AppPermission.manageClasses);
    }

    return mapped.toList();
  }

  void logout() {
    _currentUser = null;
    _dismissedAnnouncementForSession.clear();
    notifyListeners();
  }

  bool hasPermission(AppPermission permission) {
    final AppUserModel? user = _currentUser;
    if (user == null) return false;
    return user.hasPermission(permission);
  }

  List<AppNotificationModel> getCurrentRoleNotifications() {
    final AppUserModel? user = _currentUser;
    if (user == null) return <AppNotificationModel>[];

    if (user.role == AppRole.superAdmin) {
      return _notifications;
    }

    return _notifications
        .where((AppNotificationModel n) => n.unitKey == user.unitKey)
        .toList();
  }

  int getUnreadNotificationCountForCurrentRole() {
    return getCurrentRoleNotifications()
        .where((AppNotificationModel n) => n.unread)
        .length;
  }

  void markNotificationAsRead(String notificationId) {
    final int index = _notifications.indexWhere(
      (AppNotificationModel n) => n.id == notificationId,
    );

    if (index == -1) return;

    _notifications[index] = _notifications[index].copyWith(unread: false);
    notifyListeners();
  }

  void setMaintenanceMode(bool value) {
    if (!hasPermission(AppPermission.manageGlobalSettings)) return;
    _maintenanceMode = value;
    notifyListeners();
  }

  void setRegistrationEnabled(bool value) {
    if (!hasPermission(AppPermission.manageGlobalSettings)) return;
    _registrationEnabled = value;
    notifyListeners();
  }

  void setMaintenanceMessages({
    required String fa,
    required String en,
    required String ar,
  }) {
    if (!hasPermission(AppPermission.manageGlobalSettings)) return;

    _maintenanceMessageFa = fa.trim().isEmpty
        ? 'سامانه موقتاً در حال بروزرسانی است.'
        : fa.trim();
    _maintenanceMessageEn = en.trim().isEmpty
        ? 'The system is temporarily under maintenance.'
        : en.trim();
    _maintenanceMessageAr = ar.trim().isEmpty
        ? 'النظام قيد الصيانة مؤقتاً.'
        : ar.trim();

    notifyListeners();
  }

  void setLogoKey(String key) {
    if (!hasPermission(AppPermission.manageLogo)) return;
    _selectedLogoKey = key;
    notifyListeners();
  }

  void setBackgroundKey(String key) {
    if (!hasPermission(AppPermission.manageBackground)) return;
    _selectedBackgroundKey = key;
    notifyListeners();
  }

  void setFloatingAnnouncement(FloatingAnnouncementModel announcement) {
    _floatingAnnouncement = announcement;
    _dismissedAnnouncementForSession.clear();
    notifyListeners();
  }

  String? visibleFloatingAnnouncementText() {
    final FloatingAnnouncementModel? announcement = _floatingAnnouncement;
    final AppUserModel? user = _currentUser;

    if (announcement == null || user == null) return null;
    if (_dismissedAnnouncementForSession.contains(announcement.id)) return null;
    if (!announcement.canShowForRole(user.role)) return null;

    return announcement.textFor(_selectedLang);
  }

  void dismissFloatingAnnouncementForThisSession() {
    final FloatingAnnouncementModel? announcement = _floatingAnnouncement;
    if (announcement == null) return;

    _dismissedAnnouncementForSession.add(announcement.id);
    notifyListeners();
  }

  void addEducationOfficer(EducationOfficerModel officer) {
    if (!hasPermission(AppPermission.manageOfficers)) return;

    _educationOfficers.add(officer);
    notifyListeners();
  }

  void updateEducationOfficerPermissions({
    required String officerId,
    required List<EducationPermission> permissions,
  }) {
    if (!hasPermission(AppPermission.manageOfficers)) return;

    final int index = _educationOfficers.indexWhere(
      (EducationOfficerModel officer) => officer.id == officerId,
    );

    if (index == -1) return;

    _educationOfficers[index] = _educationOfficers[index].copyWith(
      permissions: permissions,
    );

    notifyListeners();
  }

  List<EducationManagedClassModel> getStudentClasses(String studentId) {
    return _educationClasses
        .where((EducationManagedClassModel c) => c.studentIds.contains(studentId))
        .toList();
  }

  List<EducationManagedClassModel> getProfessorClasses(String professorId) {
    return _educationClasses
        .where((EducationManagedClassModel c) => c.professorId == professorId)
        .toList();
  }

  void addEducationClass(EducationManagedClassModel classItem) {
    if (!hasPermission(AppPermission.createClass)) return;

    _educationClasses.add(classItem);
    notifyListeners();
  }

  void updateEducationClass(EducationManagedClassModel classItem) {
    if (!hasPermission(AppPermission.editClass)) return;

    final int index = _educationClasses.indexWhere(
      (EducationManagedClassModel c) => c.id == classItem.id,
    );

    if (index == -1) return;

    _educationClasses[index] = classItem;
    notifyListeners();
  }

  void removeStudentFromClass({
    required String classId,
    required String studentId,
  }) {
    if (!hasPermission(AppPermission.editClass)) return;

    final int index = _educationClasses.indexWhere(
      (EducationManagedClassModel c) => c.id == classId,
    );

    if (index == -1) return;

    final EducationManagedClassModel current = _educationClasses[index];
    final int studentIndex = current.studentIds.indexOf(studentId);

    if (studentIndex == -1) return;

    final List<String> updatedIds = List<String>.from(current.studentIds);
    final List<String> updatedNames = List<String>.from(current.studentNames);

    updatedIds.removeAt(studentIndex);
    if (studentIndex < updatedNames.length) {
      updatedNames.removeAt(studentIndex);
    }

    _educationClasses[index] = current.copyWith(
      studentIds: updatedIds,
      studentNames: updatedNames,
    );

    notifyListeners();
  }

  void addStudentToClass({
    required String classId,
    required String studentId,
    required String studentName,
  }) {
    if (!hasPermission(AppPermission.editClass)) return;

    final int index = _educationClasses.indexWhere(
      (EducationManagedClassModel c) => c.id == classId,
    );

    if (index == -1) return;

    final EducationManagedClassModel current = _educationClasses[index];

    if (current.studentIds.contains(studentId)) return;

    final List<String> updatedIds = List<String>.from(current.studentIds);
    final List<String> updatedNames = List<String>.from(current.studentNames);

    updatedIds.add(studentId);
    updatedNames.add(studentName);

    _educationClasses[index] = current.copyWith(
      studentIds: updatedIds,
      studentNames: updatedNames,
    );

    notifyListeners();
  }

  void addManagerMessage(InterManagerMessage message) {
    _managerMessages.add(message);
    notifyListeners();
  }

  List<InterManagerMessage> getMessagesForCurrentUnit() {
    final AppUserModel? user = _currentUser;
    if (user == null) return <InterManagerMessage>[];

    return _managerMessages.where((InterManagerMessage message) {
      return message.senderUnit == user.unitKey ||
          message.receiverUnit == user.unitKey ||
          user.role == AppRole.superAdmin;
    }).toList();
  }
}



