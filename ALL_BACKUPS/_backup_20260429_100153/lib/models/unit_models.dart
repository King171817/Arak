import 'package:flutter/material.dart';

class UnitModel {
  final String keyName;
  final IconData icon;
  final int unread;

  UnitModel({required this.keyName, required this.icon, this.unread = 0});
}

class OtherService {
  final String key;
  final IconData icon;
  final Color color;

  OtherService({
    required this.key,
    required this.icon,
    this.color = Colors.blue,
  });
}

final List<UnitModel> units = <UnitModel>[
  UnitModel(keyName: 'international', icon: Icons.public, unread: 2),
  UnitModel(keyName: 'student_services', icon: Icons.support_agent, unread: 1),
  UnitModel(keyName: 'education', icon: Icons.school, unread: 3),
  UnitModel(keyName: 'consular', icon: Icons.badge, unread: 0),
  UnitModel(keyName: 'other_services', icon: Icons.apps, unread: 0),
];

final List<OtherService> otherServices = <OtherService>[
  OtherService(key: 'taxi', icon: Icons.local_taxi, color: Colors.orange),
  OtherService(key: 'translation', icon: Icons.translate, color: Colors.purple),
  OtherService(key: 'insurance', icon: Icons.health_and_safety, color: Colors.red),
  OtherService(key: 'bank', icon: Icons.account_balance, color: Colors.green),
  OtherService(key: 'restaurant', icon: Icons.restaurant, color: Colors.brown),
  OtherService(key: 'gym', icon: Icons.fitness_center, color: Colors.teal),
  OtherService(key: 'library', icon: Icons.library_books, color: Colors.indigo),
  OtherService(key: 'printing', icon: Icons.print, color: Colors.grey),
];
