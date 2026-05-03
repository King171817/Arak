import 'package:flutter/material.dart';
import 'app_lang.dart';

class UnitModel {
  final String keyName;
  final IconData icon;
  const UnitModel(this.keyName, this.icon);
}

const List<UnitModel> units = <UnitModel>[
  UnitModel('international', Icons.public),
  UnitModel('education', Icons.school),
  UnitModel('student_services', Icons.support_agent),
  UnitModel('consular', Icons.badge),
  UnitModel('other_services', Icons.apps),
];

String unitTitle(AppLang lang, String key) {
  switch (key) {
    case 'international':
      return t(lang, 'امور بین‌الملل', 'International Affairs', 'الشؤون الدولية');
    case 'education':
      return t(lang, 'آموزش', 'Education', 'التعليم');
    case 'student_services':
      return t(lang, 'خدمات دانشجویی', 'Student Services', 'خدمات الطلاب');
    case 'consular':
      return t(lang, 'کنسولی', 'Consular', 'القنصلية');
    case 'other_services':
      return t(lang, 'سایر خدمات', 'Other Services', 'خدمات أخرى');
    default:
      return key;
  }
}
