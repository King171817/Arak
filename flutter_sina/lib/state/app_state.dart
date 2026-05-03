import 'package:flutter/material.dart';

import '../core/constants/unit_keys.dart';
import '../data/mock/mock_data.dart';
import '../models/models.dart';
import '../services/services.dart';

class AppState extends ChangeNotifier {
  final List<UiSectionSettingModel> _uiSectionSettings = <UiSectionSettingModel>[
    const UiSectionSettingModel(
      id: 'ui_dashboard',
      title: 'داشبورد',
      targetType: 'section',
      targetKey: 'dashboard',
      icon: Icons.dashboard_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_classes',
      title: 'کلاس‌ها',
      targetType: 'section',
      targetKey: 'classes',
      icon: Icons.school_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_students',
      title: 'دانشجویان',
      targetType: 'section',
      targetKey: 'students',
      icon: Icons.people_outline,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_professors',
      title: 'استادان',
      targetType: 'section',
      targetKey: 'professors',
      icon: Icons.person_pin_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_tickets',
      title: 'درخواست‌ها',
      targetType: 'section',
      targetKey: 'tickets',
      icon: Icons.confirmation_number_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_services',
      title: 'خدمات',
      targetType: 'section',
      targetKey: 'services',
      icon: Icons.apps_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
    const UiSectionSettingModel(
      id: 'ui_manager_role',
      title: 'نقش مدیر آموزش',
      targetType: 'role',
      targetKey: 'educationManager',
      icon: Icons.admin_panel_settings_outlined,
      iconSize: 24,
      fontSize: 13,
      visible: true,
      enabled: true,
    ),
  ];

  List<UiSectionSettingModel> get uiSectionSettings =>
      List<UiSectionSettingModel>.unmodifiable(_uiSectionSettings);

  void updateUiSectionSetting(UiSectionSettingModel setting) {
    final int index = _uiSectionSettings.indexWhere(
      (UiSectionSettingModel item) => item.id == setting.id,
    );

    if (index == -1) return;

    _uiSectionSettings[index] = setting;
    notifyListeners();
  }

  void toggleUiSectionVisibility(String id, bool value) {
    final int index = _uiSectionSettings.indexWhere(
      (UiSectionSettingModel item) => item.id == id,
    );

    if (index == -1) return;

    _uiSectionSettings[index] =
        _uiSectionSettings[index].copyWith(visible: value);

    notifyListeners();
  }

  void toggleUiSectionEnabled(String id, bool value) {
    final int index = _uiSectionSettings.indexWhere(
      (UiSectionSettingModel item) => item.id == id,
    );

    if (index == -1) return;

    _uiSectionSettings[index] =
        _uiSectionSettings[index].copyWith(enabled: value);

    notifyListeners();
  }

  void changeUiSectionIconSize(String id, double value) {
    final int index = _uiSectionSettings.indexWhere(
      (UiSectionSettingModel item) => item.id == id,
    );

    if (index == -1) return;

    _uiSectionSettings[index] =
        _uiSectionSettings[index].copyWith(iconSize: value);

    notifyListeners();
  }

  void changeUiSectionFontSize(String id, double value) {
    final int index = _uiSectionSettings.indexWhere(
      (UiSectionSettingModel item) => item.id == id,
    );

    if (index == -1) return;

    _uiSectionSettings[index] =
        _uiSectionSettings[index].copyWith(fontSize: value);

    notifyListeners();
  }
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

  final List<StudentTicketModel> _studentTickets =
      List<StudentTicketModel>.from(mockTickets);

  final List<ExamModel> _exams =
      List<ExamModel>.from(mockExams);

  final List<SupportRequestModel> _supportRequests = <SupportRequestModel>[];

  final List<ProfessorRequestModel> _professorRequests = <ProfessorRequestModel>[];

  FloatingAnnouncementModel? _floatingAnnouncement;
  final Set<String> _dismissedAnnouncementForSession = <String>{};

  final List<SystemLockModel> _systemLocks = <SystemLockModel>[];

  Future<void> initializeRepositories() async {
    await Future.wait(<Future<void>>[
      loadClassesFromRepository(),
      loadTicketsFromRepository(),
    ]);
  }

  AppLang get selectedLang => _selectedLang;
  AppUserModel? get currentUser => _currentUser;
  AppRole get currentRole => _currentUser?.role ?? AppRole.guest;
  String get currentUnitKey => _currentUser?.unitKey ?? '';
  bool get isLoggedIn => _currentUser != null;
  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
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

  List<SystemLockModel> get systemLocks =>
      List<SystemLockModel>.unmodifiable(_systemLocks);

  List<StudentTicketModel> get studentTickets =>
      List<StudentTicketModel>.unmodifiable(_studentTickets);

  List<ExamModel> get exams =>
      List<ExamModel>.unmodifiable(_exams);

  List<SupportRequestModel> get supportRequests =>
      List<SupportRequestModel>.unmodifiable(_supportRequests);

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

  String get maintenanceMessageFaText => _maintenanceMessageFa;
  String get maintenanceMessageEnText => _maintenanceMessageEn;
  String get maintenanceMessageArText => _maintenanceMessageAr;

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
    if (user.role != AppRole.superAdmin) {
      if (isUserLocked(user.id) || isRoleLocked(user.role) || isUnitLocked(user.unitKey)) {
        throw Exception('account_locked');
      }
    }

    _currentUser = user;
    _dismissedAnnouncementForSession.clear();
    notifyListeners();
  }

  Future<void> loginWithRepository({
    required String username,
    required String password,
  }) async {
    final AppUserModel? user = await AppServices.authRepository.login(
      username: username,
      password: password,
    );

    if (user == null) {
      throw Exception('incorrect_credentials');
    }

    login(user);
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

  String smartSupportAnswer(String question) {
    final String q = question.trim().toLowerCase();

    if (q.contains('رمز') || q.contains('password') || q.contains('پسورد')) {
      return 'برای تغییر رمز عبور، وارد بخش بیشتر > تنظیمات > امنیت شوید. اگر مشکل ادامه داشت، درخواست شما برای کارشناس ارسال می‌شود.';
    }

    if (q.contains('کلاس') || q.contains('برنامه') || q.contains('schedule')) {
      return 'برای مشاهده کلاس‌ها وارد بخش کلاس‌ها شوید. در آنجا می‌توانید نمایش لیستی یا جدول هفتگی را انتخاب کنید.';
    }

    if (q.contains('درخواست') || q.contains('تیکت') || q.contains('tracking')) {
      return 'برای ثبت یا پیگیری درخواست وارد بخش درخواست‌ها شوید. برای هر درخواست شماره پیگیری صادر می‌شود.';
    }

    if (q.contains('واحد') || q.contains('آموزش') || q.contains('بین‌الملل')) {
      return 'برای ارتباط با واحدها وارد بخش بیشتر > واحدها شوید و واحد مورد نظر را انتخاب کنید.';
    }

    if (q.contains('خدمات') || q.contains('تاکسی') || q.contains('ترجمه')) {
      return 'برای خدمات دانشجویی وارد بخش بیشتر > سایر خدمات شوید.';
    }

    return '';
  }

  String submitSupportQuestion(String question) {
    final AppUserModel? user = _currentUser;
    final String autoAnswer = smartSupportAnswer(question);

    final bool answered = autoAnswer.isNotEmpty;

    final String answer = answered
        ? autoAnswer
        : 'متأسفیم، پاسخ دقیق این سؤال را پیدا نکردم. درخواست شما ثبت شد و کارشناسان در اسرع وقت با شما تماس خواهند گرفت.';

    final SupportRequestModel request = SupportRequestModel(
      id: 'support_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? 'guest',
      userName: user?.displayName ?? 'کاربر مهمان',
      question: question,
      answer: answer,
      targetUnitKey: user?.unitKey ?? 'support',
      createdAt: DateTime.now(),
      answeredAutomatically: answered,
    );

    _supportRequests.add(request);

    notifyListeners();
    return answer;
  }

  Future<void> loadTicketsFromRepository() async {
    final List<StudentTicketModel> tickets =
        await AppServices.ticketsRepository.fetchTickets();

    _studentTickets
      ..clear()
      ..addAll(tickets);

    notifyListeners();
  }

  List<StudentTicketModel> getTicketsForCurrentUser() {
    final AppUserModel? user = _currentUser;
    if (user == null) return <StudentTicketModel>[];

    if (user.role == AppRole.superAdmin) {
      return _studentTickets;
    }

    if (user.role == AppRole.student) {
      return _studentTickets
          .where((StudentTicketModel ticket) => ticket.studentId == 's001')
          .toList();
    }

    return _studentTickets
        .where((StudentTicketModel ticket) => ticket.unitKey == user.unitKey)
        .toList();
  }

  List<ProfessorRequestModel> get professorRequests => List<ProfessorRequestModel>.unmodifiable(_professorRequests);

  /// درخواست استاد به واحد آموزش (امتحان، اتاق جلسه، کلاس فوق‌العاده و …).
  Future<void> submitProfessorEducationRequest({
    required String title,
    required String description,
  }) async {
    final AppUserModel? user = _currentUser;
    if (user == null) return;
    if (user.role != AppRole.professor) return;

    final StudentTicketModel ticket = StudentTicketModel(
      id: 'prof_edu_${DateTime.now().millisecondsSinceEpoch}',
      trackingCode:
          'PE-${(DateTime.now().millisecondsSinceEpoch % 900000 + 100000)}',
      studentId: user.id,
      studentName: user.displayName,
      unitKey: UnitKeys.education,
      title: title,
      description: description,
      status: TicketStatus.submitted,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      assignedTo: 'education_manager',
    );

    await addStudentTicket(ticket);
  }

  Future<void> addStudentTicket(StudentTicketModel ticket) async {
    final StudentTicketModel saved =
        await AppServices.ticketsRepository.createTicket(ticket);

    _studentTickets.add(saved);
    notifyListeners();
  }

  Future<void> updateStudentTicketStatus({
    required String ticketId,
    required TicketStatus status,
    required String assignedTo,
  }) async {
    if (!hasPermission(AppPermission.viewStudents) &&
        !hasPermission(AppPermission.manageReports)) {
      return;
    }

    final StudentTicketModel updated =
        await AppServices.ticketsRepository.updateTicketStatus(
      ticketId: ticketId,
      status: status,
      assignedTo: assignedTo,
    );

    final int index = _studentTickets.indexWhere(
      (StudentTicketModel ticket) => ticket.id == ticketId,
    );

    if (index == -1) {
      _studentTickets.add(updated);
    } else {
      _studentTickets[index] = updated;
    }

    notifyListeners();
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

  void addSystemLock(SystemLockModel lock) {
    if (!hasPermission(AppPermission.lockSections) &&
        !hasPermission(AppPermission.lockUsers)) {
      return;
    }

    _systemLocks.add(lock);
    notifyListeners();
  }

  void toggleSystemLock(String lockId, bool isActive) {
    if (!hasPermission(AppPermission.lockSections) &&
        !hasPermission(AppPermission.lockUsers)) {
      return;
    }

    final int index = _systemLocks.indexWhere(
      (SystemLockModel lock) => lock.id == lockId,
    );

    if (index == -1) return;

    _systemLocks[index] = _systemLocks[index].copyWith(isActive: isActive);
    notifyListeners();
  }

  bool isUserLocked(String userId) {
    return _systemLocks.any((SystemLockModel lock) {
      return lock.isEffective &&
          lock.targetType == LockTargetType.user &&
          lock.targetKey == userId;
    });
  }

  bool isRoleLocked(AppRole role) {
    return _systemLocks.any((SystemLockModel lock) {
      return lock.isEffective &&
          lock.targetType == LockTargetType.role &&
          lock.targetKey == role.name;
    });
  }

  bool isUnitLocked(String unitKey) {
    return _systemLocks.any((SystemLockModel lock) {
      return lock.isEffective &&
          lock.targetType == LockTargetType.unit &&
          lock.targetKey == unitKey;
    });
  }

  bool isSectionLocked(String sectionKey) {
    return _systemLocks.any((SystemLockModel lock) {
      return lock.isEffective &&
          lock.targetType == LockTargetType.section &&
          lock.targetKey == sectionKey;
    });
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

  Future<void> loadClassesFromRepository() async {
    final List<EducationManagedClassModel> classes =
        await AppServices.classesRepository.fetchClasses();

    _educationClasses
      ..clear()
      ..addAll(classes);

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

  Future<void> addEducationClass(EducationManagedClassModel classItem) async {
    if (!hasPermission(AppPermission.createClass)) return;

    final EducationManagedClassModel saved =
        await AppServices.classesRepository.createClass(classItem);

    _educationClasses.add(saved);
    notifyListeners();
  }

  Future<void> updateEducationClass(EducationManagedClassModel classItem) async {
    if (!hasPermission(AppPermission.editClass)) return;

    final EducationManagedClassModel saved =
        await AppServices.classesRepository.updateClass(classItem);

    final int index = _educationClasses.indexWhere(
      (EducationManagedClassModel c) => c.id == saved.id,
    );

    if (index == -1) {
      _educationClasses.add(saved);
    } else {
      _educationClasses[index] = saved;
    }

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

  List<ExamModel> getProfessorExams(String professorId) {
    return _exams.where((ExamModel exam) => exam.professorId == professorId).toList();
  }

  List<ExamModel> getStudentExams(String studentId) {
    return _exams.where((ExamModel exam) => exam.studentIds.contains(studentId)).toList();
  }

  void updateExam(ExamModel updatedExam) {
    final int index = _exams.indexWhere((ExamModel exam) => exam.id == updatedExam.id);
    if (index != -1) {
      _exams[index] = updatedExam;
      notifyListeners();
    }
  }

  void addExam(ExamModel exam) {
    _exams.add(exam);
    notifyListeners();
  }

  void updateProfessorRequest(ProfessorRequestModel updatedRequest) {
    final int index = _professorRequests.indexWhere(
      (ProfessorRequestModel request) => request.id == updatedRequest.id,
    );
    if (index != -1) {
      _professorRequests[index] = updatedRequest;
      notifyListeners();
    }
  }
}

















