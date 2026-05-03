import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/reports/daily_activity_report_model.dart';
import '../../state/app_state.dart';

class DailyActivityReportScreen extends StatefulWidget {
  final bool isMainAdmin;

  const DailyActivityReportScreen({
    super.key,
    this.isMainAdmin = false,
  });

  @override
  State<DailyActivityReportScreen> createState() => _DailyActivityReportScreenState();
}

class _DailyActivityReportScreenState extends State<DailyActivityReportScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final reports = <DailyActivityReportModel>[];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addReport() {
    if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) return;

    final now = DateTime.now();

    setState(() {
      reports.insert(
        0,
        DailyActivityReportModel(
          id: now.microsecondsSinceEpoch.toString(),
          userId: 'current-user',
          userName: 'کاربر فعلی',
          role: 'educationExpert',
          unit: 'education',
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    titleController.clear();
    descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('گزارش روزانه ثبت شد.')),
    );
  }

  void editReport(DailyActivityReportModel report) {
    if (!report.canEdit(isMainAdmin: widget.isMainAdmin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مهلت ویرایش این گزارش تمام شده است. فقط مدیر اصلی می‌تواند ویرایش کند.')),
      );
      return;
    }

    titleController.text = report.title;
    descriptionController.text = report.description;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ویرایش گزارش'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان')),
              const SizedBox(height: 8),
              TextField(controller: descriptionController, maxLines: 4, decoration: const InputDecoration(labelText: 'شرح فعالیت')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          FilledButton(
            onPressed: () {
              setState(() {
                final index = reports.indexWhere((x) => x.id == report.id);
                if (index >= 0) {
                  reports[index] = report.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    updatedAt: DateTime.now(),
                  );
                }
              });
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;

    return Scaffold(
      appBar: AppBar(title: Text(t(lang, 'daily_report'))),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان فعالیت')),
                    const SizedBox(height: 8),
                    TextField(controller: descriptionController, maxLines: 4, decoration: const InputDecoration(labelText: 'شرح فعالیت روزانه')),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: addReport,
                        icon: const Icon(Icons.save),
                        label: const Text('ثبت گزارش روزانه'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...reports.map((report) {
              final canEdit = report.canEdit(isMainAdmin: widget.isMainAdmin);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  title: Text(report.title),
                  subtitle: Text(
                    '${report.userName} | ${report.unit}\n${report.description}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: Icon(canEdit ? Icons.edit : Icons.lock),
                    onPressed: () => editReport(report),
                  ),
                ),
              );
            }),
            if (reports.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('هنوز گزارشی ثبت نشده است.'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
