import 'package:flutter/material.dart';

class ManagerHomeScreen extends StatelessWidget {
  final String managerUnitKey;
  const ManagerHomeScreen({super.key, required this.managerUnitKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مدیریت - $managerUnitKey')),
      body: const Center(child: Text('در حال توسعه...')),
    );
  }
}
