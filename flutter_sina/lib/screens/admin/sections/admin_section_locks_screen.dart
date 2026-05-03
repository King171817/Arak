import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme.dart';
import '../../../state/admin_control_state.dart';

/// قفل موقت بخش‌های اپ (تعمیرات) + پیام چندزبانه برای همان بخش.
/// داده از [AdminControlState] است؛ در نسخهٔ بعدی به API/دیتابیس وصل می‌شود.
class AdminSectionLocksScreen extends StatelessWidget {
  const AdminSectionLocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

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
                Icon(Icons.lock_clock_outlined, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'قفل بخش‌ها و پیام تعمیرات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'با فعال کردن قفل، کاربر هنگام ورود به آن بخش پیام زیر را می‌بیند. '
            'این وضعیت برای آماده‌سازی یکپارچه با سرویس‌های آینده (شرکت‌ها/سازمان‌ها) '
            'در نظر گرفته شده است.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          ...admin.sections.map((AdminManagedSection section) {
            return _SectionLockCard(section: section);
          }),
        ],
      ),
    );
  }
}

class _SectionLockCard extends StatefulWidget {
  final AdminManagedSection section;

  const _SectionLockCard({required this.section});

  @override
  State<_SectionLockCard> createState() => _SectionLockCardState();
}

class _SectionLockCardState extends State<_SectionLockCard> {
  late TextEditingController _messageCtrl;

  @override
  void initState() {
    super.initState();
    _messageCtrl =
        TextEditingController(text: widget.section.maintenanceMessage);
  }

  @override
  void didUpdateWidget(covariant _SectionLockCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section.maintenanceMessage !=
        widget.section.maintenanceMessage) {
      _messageCtrl.text = widget.section.maintenanceMessage;
    }
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminControlState admin = context.watch<AdminControlState>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: AppDecorations.cardDecoration,
      child: ExpansionTile(
        leading: Icon(widget.section.icon, color: AppColors.primary),
        title: Text(
          widget.section.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          widget.section.locked ? 'قفل فعال است' : 'باز است',
          style: TextStyle(
            fontSize: 11,
            color: widget.section.locked ? Colors.red : Colors.green,
          ),
        ),
        children: <Widget>[
          SwitchListTile(
            dense: true,
            title: const Text('قفل موقت این بخش'),
            value: widget.section.locked,
            onChanged: (bool v) {
              admin.toggleSectionLock(widget.section.id, v);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _messageCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'پیام نمایش داده‌شده هنگام قفل',
                hintText: 'مثال: این بخش تا ساعت ۱۴ در دسترس نیست.',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _saveMessage(admin),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _saveMessage(admin),
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('ذخیره پیام'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveMessage(AdminControlState admin) {
    admin.updateSectionMessage(widget.section.id, _messageCtrl.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('پیام بخش ذخیره شد')),
    );
  }
}
