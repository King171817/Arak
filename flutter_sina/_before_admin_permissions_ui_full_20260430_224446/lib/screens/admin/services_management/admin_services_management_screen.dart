import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/admin_control_state.dart';

class AdminServicesManagementScreen extends StatelessWidget {
  const AdminServicesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

    return Container(
      decoration: AppDecorations.pageBackground,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.business_center_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'مدیریت واقعی خدمات، شرکت‌ها و سازمان‌های همکار',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...admin.services.map((AdminManagedService service) {
            return _ServiceControlCard(service: service);
          }),
        ],
      ),
    );
  }
}

class _ServiceControlCard extends StatefulWidget {
  final AdminManagedService service;

  const _ServiceControlCard({
    required this.service,
  });

  @override
  State<_ServiceControlCard> createState() => _ServiceControlCardState();
}

class _ServiceControlCardState extends State<_ServiceControlCard> {
  late final TextEditingController providerCtrl;

  @override
  void initState() {
    super.initState();
    providerCtrl = TextEditingController(text: widget.service.provider);
  }

  @override
  void dispose() {
    providerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.read<AdminControlState>();

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: Icon(widget.service.icon, size: 24, color: AppColors.primary),
        title: Text(
          widget.service.title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.service.provider,
          style: const TextStyle(fontSize: 10),
        ),
        children: <Widget>[
          SwitchListTile(
            dense: true,
            title: const Text('خدمت فعال باشد'),
            value: widget.service.active,
            onChanged: (bool value) {
              admin.toggleServiceActive(widget.service.id, value);
            },
          ),
          SwitchListTile(
            dense: true,
            title: const Text('اتصال API فعال باشد'),
            subtitle: const Text('برای اتصال به شرکت یا سازمان بیرونی'),
            value: widget.service.apiEnabled,
            onChanged: (bool value) {
              admin.toggleServiceApi(widget.service.id, value);
            },
          ),
          ListTile(
            dense: true,
            title: const Text('ارائه‌دهنده / شرکت / سازمان'),
            subtitle: TextField(
              controller: providerCtrl,
              decoration: const InputDecoration(
                hintText: 'نام ارائه‌دهنده',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  admin.updateServiceProvider(widget.service.id, providerCtrl.text.trim());
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text('ذخیره تغییرات خدمت'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
