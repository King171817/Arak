import 'package:flutter/material.dart';

class AdminUiSettingsScreen extends StatelessWidget {
  const AdminUiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('??????? ?????? ????'),
      ),
      body: ListView(
        children: [
          _UiSettingCard(setting: '????????'),
          _UiSettingCard(setting: '???????'),
          _UiSettingCard(setting: '???????'),
        ],
      ),
    );
  }
}

class _UiSettingCard extends StatelessWidget {
  final String setting;

  const _UiSettingCard({required this.setting});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(setting),
        trailing: Icon(Icons.edit),
        onTap: () {
          // ?????? ?????? ??? ???
        },
      ),
    );
  }
}

