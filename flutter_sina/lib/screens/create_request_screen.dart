import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final pageCountController = TextEditingController(text: '2');

  String type = 'translation';
  String priority = 'normal';
  String sourceLang = 'fa';
  String targetLang = 'en';
  bool loading = false;
  String? error;

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      await ApiService.createRequest(
        type: type,
        priority: priority,
        details: {
          'sourceLang': sourceLang,
          'targetLang': targetLang,
          'pageCount': int.tryParse(pageCountController.text) ?? 1,
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  DropdownButtonFormField<String> dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((x) => DropdownMenuItem(
                value: x,
                child: Text(x),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ثبت درخواست جدید')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              dropdown(
                label: 'نوع درخواست',
                value: type,
                items: const ['translation', 'hotel', 'taxi', 'ticket', 'education'],
                onChanged: (v) => setState(() => type = v ?? type),
              ),
              const SizedBox(height: 12),
              dropdown(
                label: 'اولویت',
                value: priority,
                items: const ['normal', 'high', 'urgent'],
                onChanged: (v) => setState(() => priority = v ?? priority),
              ),
              const SizedBox(height: 12),
              dropdown(
                label: 'زبان مبدا',
                value: sourceLang,
                items: const ['fa', 'en', 'ar', 'tr', 'ru'],
                onChanged: (v) => setState(() => sourceLang = v ?? sourceLang),
              ),
              const SizedBox(height: 12),
              dropdown(
                label: 'زبان مقصد',
                value: targetLang,
                items: const ['fa', 'en', 'ar', 'tr', 'ru'],
                onChanged: (v) => setState(() => targetLang = v ?? targetLang),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pageCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'تعداد صفحات',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('ثبت درخواست'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
