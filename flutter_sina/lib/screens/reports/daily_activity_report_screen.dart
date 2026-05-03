import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/admin/backend_daily_report_model.dart';
import '../../repositories/admin_advanced_repository.dart';
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
  final repository = AdminAdvancedRepository();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool loading = true;
  String? error;
  List<BackendDailyReportModel> reports = <BackendDailyReportModel>[];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadReports() async {
    try {
      final result = await repository.fetchDailyReports();
      if (!mounted) return;
      setState(() {
        reports = result;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }

  Future<void> addReport() async {
    if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) return;

    try {
      await repository.createDailyReport(
        userId: 'expert1',
        userName: 'کارشناس آموزش ۱',
        role: 'educationExpert',
        unit: 'education',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );

      titleController.clear();
      descriptionController.clear();

      await loadReports();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('گزارش روزانه در بک‌اند ذخیره شد.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ثبت گزارش: $e')),
      );
    }
  }

  Future<void> editReport(BackendDailyReportModel report) async {
    if (!report.canEdit(isMainAdmin: widget.isMainAdmin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مهلت ویرایش این گزارش تمام شده است. فقط مدیر اصلی می‌تواند ویرایش کند.')),
      );
      return;
    }

    titleController.text = report.title;
    descriptionController.text = report.description;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ویرایش گزارش روزانه'),
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
          TextButton(
            onPressed: () {
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            },
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await repository.updateDailyReport(
                  id: report.id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  isMainAdmin: widget.isMainAdmin,
                );

                titleController.clear();
                descriptionController.clear();

                if (mounted) Navigator.pop(context);
                await loadReports();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطا در ویرایش گزارش: $e')),
                );
              }
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
      appBar: AppBar(
        title: Text(t(lang, 'daily_report')),
        actions: [
          IconButton(onPressed: loadReports, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text('خطا در دریافت گزارش‌ها: $error'))
                : ListView(
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
                                  label: const Text('ثبت گزارش در بک‌اند'),
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
