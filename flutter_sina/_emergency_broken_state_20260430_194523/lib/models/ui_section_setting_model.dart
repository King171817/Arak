import 'package:flutter/material.dart';

class UiSectionSettingModel {
  final String id;
  final String title;
  final String targetType; // section, role, user
  final String targetKey;
  final IconData icon;
  final double iconSize;
  final double fontSize;
  final bool visible;
  final bool enabled;

  const UiSectionSettingModel({
    required this.id,
    required this.title,
    required this.targetType,
    required this.targetKey,
    required this.icon,
    required this.iconSize,
    required this.fontSize,
    required this.visible,
    required this.enabled,
  });

  UiSectionSettingModel copyWith({
    String? id,
    String? title,
    String? targetType,
    String? targetKey,
    IconData? icon,
    double? iconSize,
    double? fontSize,
    bool? visible,
    bool? enabled,
  }) {
    return UiSectionSettingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetType: targetType ?? this.targetType,
      targetKey: targetKey ?? this.targetKey,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      visible: visible ?? this.visible,
      enabled: enabled ?? this.enabled,
    );
  }
}
