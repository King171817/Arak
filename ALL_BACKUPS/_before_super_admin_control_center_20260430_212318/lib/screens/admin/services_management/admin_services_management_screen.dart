import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

class AdminServicesManagementScreen extends StatelessWidget {
  const AdminServicesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_AdminServiceConfig> services = <_AdminServiceConfig>[
      _AdminServiceConfig(Icons.translate, 'ترجمه مدارک', 'شرکت ترجمه / واحد بین‌الملل', true, true),
      _AdminServiceConfig(Icons.print_outlined, 'پرینت و کپی', 'مرکز چاپ / شرکت همکار', true, false),
      _AdminServiceConfig(Icons.local_taxi_outlined, 'تاکسی', 'شرکت حمل‌ونقل', true, true),
      _AdminServiceConfig(Icons.health_and_safety_outlined, 'بیمه', 'شرکت بیمه', true, true),
      _AdminServiceConfig(Icons.map_outlined, 'نقشه دانشگاه', 'مدیریت سامانه', false, false),
      _AdminServiceConfig(Icons.psychology_outlined, 'مشاوره', 'مرکز مشاوره دانشگاه', false, true),
    ];

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
                    'مدیریت خدمات، شرکت‌ها و سازمان‌های همکار',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'در این بخش مدیر اصلی می‌تواند خدمات آینده را تعریف کند، ارائه‌دهنده را مشخص کند، نیاز به تأیید دانشگاه را تعیین کند و وضعیت فعال بودن هر سرویس را مدیریت کند.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ...services.map((item) => _AdminServiceConfigCard(item: item)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('افزودن خدمت / شرکت جدید'),
          ),
        ],
      ),
    );
  }
}

class _AdminServiceConfigCard extends StatelessWidget {
  final _AdminServiceConfig item;

  const _AdminServiceConfigCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: Icon(item.icon, size: 24),
        title: Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(item.provider, style: const TextStyle(fontSize: 10)),
        children: <Widget>[
          SwitchListTile(
            dense: true,
            title: const Text('فعال باشد'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            dense: true,
            title: const Text('ارائه‌دهنده بیرونی دارد'),
            value: item.external,
            onChanged: (_) {},
          ),
          SwitchListTile(
            dense: true,
            title: const Text('نیاز به تأیید دانشگاه دارد'),
            value: item.needsApproval,
            onChanged: (_) {},
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.edit_outlined),
            title: const Text('ویرایش مشخصات، قرارداد، API و اطلاعات تماس'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _AdminServiceConfig {
  final IconData icon;
  final String title;
  final String provider;
  final bool external;
  final bool needsApproval;

  const _AdminServiceConfig(
    this.icon,
    this.title,
    this.provider,
    this.external,
    this.needsApproval,
  );
}
