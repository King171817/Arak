import 'package:flutter/material.dart';

class UnitModel {
  final String keyName;
  final IconData icon;
  final int unread;

  const UnitModel({
    required this.keyName,
    required this.icon,
    this.unread = 0,
  });
}
