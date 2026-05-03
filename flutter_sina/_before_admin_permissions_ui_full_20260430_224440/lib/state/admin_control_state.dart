import 'package:flutter/material.dart';

class AdminManagedUser {
  final String id;
  final String name;
  final String role;
  final String unit;
  final bool locked;

  const AdminManagedUser({
    required this.id,
    required this.name,
    required this.role,
    required this.unit,
    required this.locked,
  });

  AdminManagedUser copyWith({
    String? id,
    String? name,
    String? role,
    String? unit,
    bool? locked,
  }) {
    return AdminManagedUser(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      unit: unit ?? this.unit,
      locked: locked ?? this.locked,
    );
  }
}

class AdminManagedSection {
  final String id;
  final String title;
  final IconData icon;
  final bool locked;
  final String maintenanceMessage;

  const AdminManagedSection({
    required this.id,
    required this.title,
    required this.icon,
    required this.locked,
    required this.maintenanceMessage,
  });

  AdminManagedSection copyWith({
    String? id,
    String? title,
    IconData? icon,
    bool? locked,
    String? maintenanceMessage,
  }) {
    return AdminManagedSection(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      locked: locked ?? this.locked,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
    );
  }
}

class AdminManagedService {
  final String id;
  final String title;
  final IconData icon;
  final String provider;
  final bool active;
  final bool externalProvider;
  final bool needsApproval;
  final bool apiEnabled;

  const AdminManagedService({
    required this.id,
    required this.title,
    required this.icon,
    required this.provider,
    required this.active,
    required this.externalProvider,
    required this.needsApproval,
    required this.apiEnabled,
  });

  AdminManagedService copyWith({
    String? id,
    String? title,
    IconData? icon,
    String? provider,
    bool? active,
    bool? externalProvider,
    bool? needsApproval,
    bool? apiEnabled,
  }) {
    return AdminManagedService(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      provider: provider ?? this.provider,
      active: active ?? this.active,
      externalProvider: externalProvider ?? this.externalProvider,
      needsApproval: needsApproval ?? this.needsApproval,
      apiEnabled: apiEnabled ?? this.apiEnabled,
    );
  }
}

class AdminFloatingMessage {
  final String id;
  final String targetType;
  final String targetKey;
  final String lang;
  final String title;
  final String message;
  final DateTime startAt;
  final DateTime endAt;
  final bool active;

  const AdminFloatingMessage({
    required this.id,
    required this.targetType,
    required this.targetKey,
    required this.lang,
    required this.title,
    required this.message,
    required this.startAt,
    required this.endAt,
    required this.active,
  });

  AdminFloatingMessage copyWith({
    String? id,
    String? targetType,
    String? targetKey,
    String? lang,
    String? title,
    String? message,
    DateTime? startAt,
    DateTime? endAt,
    bool? active,
  }) {
    return AdminFloatingMessage(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetKey: targetKey ?? this.targetKey,
      lang: lang ?? this.lang,
      title: title ?? this.title,
      message: message ?? this.message,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      active: active ?? this.active,
    );
  }
}

class AdminSupportKnowledge {
  final String id;
  final String question;
  final String answer;
  final String targetUnit;
  final bool active;

  const AdminSupportKnowledge({
    required this.id,
    required this.question,
    required this.answer,
    required this.targetUnit,
    required this.active,
  });

  AdminSupportKnowledge copyWith({
    String? id,
    String? question,
    String? answer,
    String? targetUnit,
    bool? active,
  }) {
    return AdminSupportKnowledge(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      targetUnit: targetUnit ?? this.targetUnit,
      active: active ?? this.active,
    );
  }
}

class AdminActivityLog {
  final String id;
  final String actor;
  final String action;
  final String target;
  final DateTime createdAt;

  const AdminActivityLog({
    required this.id,
    required this.actor,
    required this.action,
    required this.target,
    required this.createdAt,
  });
}

class AdminControlState extends ChangeNotifier {
  final List<AdminManagedUser> _users = <AdminManagedUser>[
    const AdminManagedUser(id: 's001', name: 'دانشجو نمونه', role: 'student', unit: 'education', locked: false),
    const AdminManagedUser(id: 'p001', name: 'استاد نمونه', role: 'professor', unit: 'education', locked: false),
    const AdminManagedUser(id: 'm001', name: 'مدیر آموزش', role: 'educationManager', unit: 'education', locked: false),
    const AdminManagedUser(id: 'o001', name: 'کارشناس آموزش', role: 'educationOfficer', unit: 'education', locked: false),
  ];

  final List<AdminManagedSection> _sections = <AdminManagedSection>[
    const AdminManagedSection(id: 'dashboard', title: 'داشبورد', icon: Icons.dashboard_outlined, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'classes', title: 'کلاس‌ها', icon: Icons.school_outlined, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'students', title: 'دانشجویان', icon: Icons.people_outline, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'professors', title: 'استادان', icon: Icons.person_pin_outlined, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'tickets', title: 'درخواست‌ها', icon: Icons.confirmation_number_outlined, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'services', title: 'سایر خدمات', icon: Icons.apps_outlined, locked: false, maintenanceMessage: ''),
    const AdminManagedSection(id: 'support', title: 'پشتیبانی هوشمند', icon: Icons.support_agent_outlined, locked: false, maintenanceMessage: ''),
  ];

  final List<AdminManagedService> _services = <AdminManagedService>[
    const AdminManagedService(id: 'translation', title: 'ترجمه مدارک', icon: Icons.translate, provider: 'شرکت ترجمه / واحد بین‌الملل', active: true, externalProvider: true, needsApproval: true, apiEnabled: false),
    const AdminManagedService(id: 'printing', title: 'پرینت و کپی', icon: Icons.print_outlined, provider: 'مرکز چاپ دانشگاه / شرکت همکار', active: true, externalProvider: true, needsApproval: false, apiEnabled: false),
    const AdminManagedService(id: 'taxi', title: 'تاکسی', icon: Icons.local_taxi_outlined, provider: 'شرکت حمل‌ونقل همکار', active: true, externalProvider: true, needsApproval: true, apiEnabled: false),
    const AdminManagedService(id: 'insurance', title: 'بیمه', icon: Icons.health_and_safety_outlined, provider: 'شرکت بیمه همکار', active: true, externalProvider: true, needsApproval: true, apiEnabled: false),
    const AdminManagedService(id: 'library', title: 'کتابخانه', icon: Icons.local_library_outlined, provider: 'کتابخانه دانشگاه', active: true, externalProvider: false, needsApproval: false, apiEnabled: false),
    const AdminManagedService(id: 'map', title: 'نقشه دانشگاه', icon: Icons.map_outlined, provider: 'مدیریت سامانه', active: true, externalProvider: false, needsApproval: false, apiEnabled: false),
  ];

  final List<AdminFloatingMessage> _floatingMessages = <AdminFloatingMessage>[];
  final List<AdminSupportKnowledge> _supportKnowledge = <AdminSupportKnowledge>[
    const AdminSupportKnowledge(
      id: 'k001',
      question: 'رمز عبور',
      answer: 'برای تغییر رمز عبور وارد بیشتر > تنظیمات > امنیت شوید.',
      targetUnit: 'support',
      active: true,
    ),
    const AdminSupportKnowledge(
      id: 'k002',
      question: 'کلاس',
      answer: 'برای مشاهده کلاس‌ها وارد بخش کلاس‌ها شوید و وضعیت جلسه را بررسی کنید.',
      targetUnit: 'education',
      active: true,
    ),
  ];

  final List<AdminActivityLog> _logs = <AdminActivityLog>[];

  List<AdminManagedUser> get users => List<AdminManagedUser>.unmodifiable(_users);
  List<AdminManagedSection> get sections => List<AdminManagedSection>.unmodifiable(_sections);
  List<AdminManagedService> get services => List<AdminManagedService>.unmodifiable(_services);
  List<AdminFloatingMessage> get floatingMessages => List<AdminFloatingMessage>.unmodifiable(_floatingMessages);
  List<AdminSupportKnowledge> get supportKnowledge => List<AdminSupportKnowledge>.unmodifiable(_supportKnowledge);
  List<AdminActivityLog> get logs => List<AdminActivityLog>.unmodifiable(_logs.reversed);

  void _log(String action, String target) {
    _logs.add(AdminActivityLog(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      actor: 'sina',
      action: action,
      target: target,
      createdAt: DateTime.now(),
    ));
  }

  void toggleUserLock(String userId, bool locked) {
    final int index = _users.indexWhere((AdminManagedUser user) => user.id == userId);
    if (index == -1) return;
    _users[index] = _users[index].copyWith(locked: locked);
    _log(locked ? 'قفل کاربر' : 'باز کردن کاربر', _users[index].name);
    notifyListeners();
  }

  void toggleSectionLock(String sectionId, bool locked) {
    final int index = _sections.indexWhere((AdminManagedSection section) => section.id == sectionId);
    if (index == -1) return;
    _sections[index] = _sections[index].copyWith(locked: locked);
    _log(locked ? 'قفل بخش' : 'باز کردن بخش', _sections[index].title);
    notifyListeners();
  }

  void updateSectionMessage(String sectionId, String message) {
    final int index = _sections.indexWhere((AdminManagedSection section) => section.id == sectionId);
    if (index == -1) return;
    _sections[index] = _sections[index].copyWith(maintenanceMessage: message);
    _log('ویرایش پیام تعمیرات بخش', _sections[index].title);
    notifyListeners();
  }

  void toggleServiceActive(String serviceId, bool active) {
    final int index = _services.indexWhere((AdminManagedService service) => service.id == serviceId);
    if (index == -1) return;
    _services[index] = _services[index].copyWith(active: active);
    _log(active ? 'فعال کردن خدمت' : 'غیرفعال کردن خدمت', _services[index].title);
    notifyListeners();
  }

  void toggleServiceApi(String serviceId, bool enabled) {
    final int index = _services.indexWhere((AdminManagedService service) => service.id == serviceId);
    if (index == -1) return;
    _services[index] = _services[index].copyWith(apiEnabled: enabled);
    _log(enabled ? 'فعال کردن API خدمت' : 'غیرفعال کردن API خدمت', _services[index].title);
    notifyListeners();
  }

  void updateServiceProvider(String serviceId, String provider) {
    final int index = _services.indexWhere((AdminManagedService service) => service.id == serviceId);
    if (index == -1) return;
    _services[index] = _services[index].copyWith(provider: provider);
    _log('ویرایش ارائه‌دهنده خدمت', _services[index].title);
    notifyListeners();
  }

  void addFloatingMessage({
    required String targetType,
    required String targetKey,
    required String lang,
    required String title,
    required String message,
    required int activeDays,
  }) {
    _floatingMessages.add(AdminFloatingMessage(
      id: 'float_${DateTime.now().millisecondsSinceEpoch}',
      targetType: targetType,
      targetKey: targetKey,
      lang: lang,
      title: title,
      message: message,
      startAt: DateTime.now(),
      endAt: DateTime.now().add(Duration(days: activeDays)),
      active: true,
    ));
    _log('افزودن پیام شناور', '$targetType/$targetKey');
    notifyListeners();
  }

  void toggleFloatingMessage(String id, bool active) {
    final int index = _floatingMessages.indexWhere((AdminFloatingMessage item) => item.id == id);
    if (index == -1) return;
    _floatingMessages[index] = _floatingMessages[index].copyWith(active: active);
    _log(active ? 'فعال کردن پیام شناور' : 'غیرفعال کردن پیام شناور', _floatingMessages[index].title);
    notifyListeners();
  }

  void addSupportKnowledge({
    required String question,
    required String answer,
    required String targetUnit,
  }) {
    _supportKnowledge.add(AdminSupportKnowledge(
      id: 'k_${DateTime.now().millisecondsSinceEpoch}',
      question: question,
      answer: answer,
      targetUnit: targetUnit,
      active: true,
    ));
    _log('افزودن دانش پشتیبانی', question);
    notifyListeners();
  }

  void toggleSupportKnowledge(String id, bool active) {
    final int index = _supportKnowledge.indexWhere((AdminSupportKnowledge item) => item.id == id);
    if (index == -1) return;
    _supportKnowledge[index] = _supportKnowledge[index].copyWith(active: active);
    _log(active ? 'فعال کردن دانش پشتیبانی' : 'غیرفعال کردن دانش پشتیبانی', _supportKnowledge[index].question);
    notifyListeners();
  }
}
