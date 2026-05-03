import '../auth/app_lang.dart';
import '../auth/app_role.dart';

enum FloatingAnnouncementTarget {
  all,
  students,
  professors,
  managers,
  officers,
  educationTeam,
  superAdmin,
}

class FloatingAnnouncementModel {
  final String id;
  final String textFa;
  final String textEn;
  final String textAr;
  final FloatingAnnouncementTarget target;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;

  const FloatingAnnouncementModel({
    required this.id,
    required this.textFa,
    required this.textEn,
    required this.textAr,
    required this.target,
    required this.createdAt,
    this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  String textFor(AppLang lang) {
    switch (lang) {
      case AppLang.fa:
        return textFa;
      case AppLang.en:
        return textEn;
      case AppLang.ar:
        return textAr;
    }
  }

  bool canShowForRole(AppRole role) {
    if (!isActive || isExpired) return false;

    switch (target) {
      case FloatingAnnouncementTarget.all:
        return true;
      case FloatingAnnouncementTarget.students:
        return role == AppRole.student;
      case FloatingAnnouncementTarget.professors:
        return role == AppRole.professor;
      case FloatingAnnouncementTarget.managers:
        return role == AppRole.unitManager || role == AppRole.educationManager;
      case FloatingAnnouncementTarget.officers:
        return role == AppRole.unitOfficer || role == AppRole.educationOfficer;
      case FloatingAnnouncementTarget.educationTeam:
        return role == AppRole.educationManager || role == AppRole.educationOfficer;
      case FloatingAnnouncementTarget.superAdmin:
        return role == AppRole.superAdmin;
    }
  }
}
