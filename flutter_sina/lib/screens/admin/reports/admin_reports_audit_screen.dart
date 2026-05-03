import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../models/notifications/chat_message_models.dart';
import '../../../state/admin_control_state.dart';
import '../../../state/app_state.dart';

class AdminReportsAuditScreen extends StatefulWidget {
  const AdminReportsAuditScreen({super.key});

  @override
  State<AdminReportsAuditScreen> createState() => _AdminReportsAuditScreenState();
}

class _AdminReportsAuditScreenState extends State<AdminReportsAuditScreen> {
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();
  String selectedReport = 'users';

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AdminControlState admin = context.watch<AdminControlState>();

    final List<_ReportItem> reports = <_ReportItem>[
      _ReportItem('users', Icons.people_alt_outlined, 'گزارش کاربران', '${admin.users.length}', 'کاربران، نقش‌ها، قفل‌ها و دسترسی‌ها'),
      _ReportItem('roles', Icons.security_outlined, 'گزارش نقش و دسترسی', '${AdminControlState.roles.length}', 'نقش‌ها و دسترسی‌های هر فرد'),
      _ReportItem('classes', Icons.school_outlined, 'گزارش کلاس‌ها', '${appState.educationClasses.length}', 'کلاس‌های فعال، گذشته، استاد و دانشجو'),
      _ReportItem('tickets', Icons.confirmation_number_outlined, 'گزارش تیکت‌ها', '${appState.studentTickets.length}', 'درخواست‌ها، وضعیت، ارجاع و پاسخ‌ها'),
      _ReportItem('services', Icons.business_center_outlined, 'گزارش خدمات', '${admin.services.length}', 'شرکت‌ها، API، فعال/غیرفعال'),
      _ReportItem('floating', Icons.campaign_outlined, 'گزارش پیام شناور', '${admin.floatingMessages.length}', 'پیام‌های زمان‌دار و مخاطبان'),
      _ReportItem('support', Icons.smart_toy_outlined, 'گزارش پشتیبانی هوشمند', '${admin.supportKnowledge.length}', 'دانش پشتیبانی و پاسخ‌ها'),
      _ReportItem('chat', Icons.chat_outlined, 'گزارش چت‌ها', '${appState.managerMessages.length}', 'چت‌های مدیران و واحدها'),
      _ReportItem('logs', Icons.history_outlined, 'لاگ فعالیت‌ها', '${admin.logs.length}', 'فعالیت‌های مدیر و تغییرات سیستم'),
    ];

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.analytics_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'گزارش‌های لحظه‌ای و دوره‌ای',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _DateRangeCard(
            fromDate: fromDate,
            toDate: toDate,
            onLastDay: () => setState(() {
              fromDate = DateTime.now().subtract(const Duration(days: 1));
              toDate = DateTime.now();
            }),
            onLastWeek: () => setState(() {
              fromDate = DateTime.now().subtract(const Duration(days: 7));
              toDate = DateTime.now();
            }),
            onLastMonth: () => setState(() {
              fromDate = DateTime.now().subtract(const Duration(days: 30));
              toDate = DateTime.now();
            }),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 3.7,
            children: reports.map((_ReportItem item) {
              return _ReportCard(
                item: item,
                selected: selectedReport == item.key,
                onTap: () => setState(() => selectedReport = item.key),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _ReportDetails(
            selectedReport: selectedReport,
            fromDate: fromDate,
            toDate: toDate,
            admin: admin,
            appState: appState,
          ),
        ],
      ),
    );
  }
}

class _DateRangeCard extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback onLastDay;
  final VoidCallback onLastWeek;
  final VoidCallback onLastMonth;

  const _DateRangeCard({
    required this.fromDate,
    required this.toDate,
    required this.onLastDay,
    required this.onLastWeek,
    required this.onLastMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.date_range_outlined, size: 22, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'بازه گزارش: ${fromDate.toString().substring(0, 10)} تا ${toDate.toString().substring(0, 10)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: <Widget>[
              OutlinedButton(onPressed: onLastDay, child: const Text('۲۴ ساعت')),
              OutlinedButton(onPressed: onLastWeek, child: const Text('۷ روز')),
              OutlinedButton(onPressed: onLastMonth, child: const Text('۳۰ روز')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _ReportItem item;
  final bool selected;
  final VoidCallback onTap;

  const _ReportCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration.copyWith(
        border: Border.all(
          color: selected ? AppColors.primary : Colors.black.withValues(alpha: 0.05),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: <Widget>[
              Icon(item.icon, size: 24, color: AppColors.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9)),
                  ],
                ),
              ),
              Text(item.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportDetails extends StatelessWidget {
  final String selectedReport;
  final DateTime fromDate;
  final DateTime toDate;
  final AdminControlState admin;
  final AppState appState;

  const _ReportDetails({
    required this.selectedReport,
    required this.fromDate,
    required this.toDate,
    required this.admin,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = _buildRows();

    return Container(
      decoration: AppDecorations.cardDecoration,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'جزئیات گزارش: $selectedReport',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'از ${fromDate.toString().substring(0, 10)} تا ${toDate.toString().substring(0, 10)}',
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          const Divider(),
          ...rows,
        ],
      ),
    );
  }

  List<Widget> _buildRows() {
    if (selectedReport == 'users') {
      return admin.users.map((user) {
        return _detail(Icons.person_outline, user.name, '${user.role} / ${user.unit} / ${user.locked ? "قفل" : "فعال"}');
      }).toList();
    }

    if (selectedReport == 'classes') {
      return appState.educationClasses.map((c) {
        return _detail(Icons.school_outlined, c.title, '${c.professorName} / ${c.weekDay} / ${c.startTime}');
      }).toList();
    }

    if (selectedReport == 'tickets') {
      return appState.studentTickets.map((t) {
        return _detail(Icons.confirmation_number_outlined, t.title, '${t.id} / ${t.status.name}');
      }).toList();
    }

    if (selectedReport == 'services') {
      return admin.services.map((s) {
        return _detail(Icons.business_center_outlined, s.title, '${s.provider} / ${s.active ? "فعال" : "غیرفعال"}');
      }).toList();
    }

    if (selectedReport == 'floating') {
      return admin.floatingMessages.map((m) {
        return _detail(Icons.campaign_outlined, m.title, '${m.targetType}: ${m.targetKeys.join(', ')} / ${m.lang}');
      }).toList();
    }

    if (selectedReport == 'support') {
      return admin.supportKnowledge.map((k) {
        return _detail(Icons.smart_toy_outlined, k.question, '${k.targetUnit} / ${k.active ? "فعال" : "غیرفعال"}');
      }).toList();
    }

    if (selectedReport == 'chat') {
      final List<InterManagerMessage> filtered = appState.managerMessages.where((InterManagerMessage message) {
        return message.sentAt.isAfter(fromDate) && message.sentAt.isBefore(toDate.add(const Duration(days: 1)));
      }).toList();

      final Map<String, int> senderCounts = <String, int>{};
      for (final InterManagerMessage message in filtered) {
        senderCounts[message.senderUnit] = (senderCounts[message.senderUnit] ?? 0) + 1;
      }

      return <Widget>[
        _detail(Icons.chat_outlined, 'پیام‌های بازه زمانی', '${filtered.length} پیام'),
        ...senderCounts.entries.map((MapEntry<String, int> entry) {
          return _detail(Icons.group_outlined, entry.key, 'تعداد: ${entry.value}');
        }),
        const Divider(),
        ...filtered.map((InterManagerMessage message) {
          return _detail(Icons.message_outlined, '${message.senderUnit} → ${message.receiverUnit}', message.message);
        }),
      ];
    }

    if (selectedReport == 'logs') {
      final List<AdminActivityLog> filtered = admin.logs.where((AdminActivityLog log) {
        return log.createdAt.isAfter(fromDate) && log.createdAt.isBefore(toDate.add(const Duration(days: 1)));
      }).toList();

      return filtered.map((AdminActivityLog l) {
        return _detail(Icons.history_outlined, l.action, '${l.target} / ${l.createdAt}');
      }).toList();
    }

    return <Widget>[
      _detail(Icons.security_outlined, 'نقش‌ها', AdminControlState.roles.join(', ')),
      _detail(Icons.verified_user_outlined, 'دسترسی‌ها', AdminControlState.allPermissions.join(', ')),
    ];
  }

  Widget _detail(IconData icon, String title, String subtitle) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _ReportItem {
  final String key;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _ReportItem(this.key, this.icon, this.title, this.value, this.subtitle);
}




