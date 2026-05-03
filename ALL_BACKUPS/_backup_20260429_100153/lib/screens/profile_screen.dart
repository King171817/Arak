import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: 'سینا سالاری');
    emailCtrl = TextEditingController(text: 'sina.salari@stu.araku.ac.ir');
    phoneCtrl = TextEditingController(text: '+98 912 345 6789');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isRtl = isRtlLang(appState.selectedLang);
    
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(isRtl ? 'پروفایل کاربر' : 'User Profile'), centerTitle: true, actions: [
          IconButton(onPressed: () => setState(() => editMode = !editMode), icon: Icon(editMode ? Icons.close : Icons.edit_outlined)),
        ]),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 560),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))]),
              child: Column(
                children: [
                  const CircleAvatar(radius: 48, backgroundColor: Colors.green, child: Icon(Icons.person, size: 48, color: Colors.white)),
                  const SizedBox(height: 16),
                  Text(nameCtrl.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: const Text('دانشجوی بین‌الملل')),
                  const SizedBox(height: 24),
                  _buildField(label: isRtl ? 'نام و نام خانوادگی' : 'Full Name', ctrl: nameCtrl, icon: Icons.person),
                  _buildField(label: isRtl ? 'ایمیل' : 'Email', ctrl: emailCtrl, icon: Icons.email),
                  _buildField(label: isRtl ? 'شماره تماس' : 'Phone', ctrl: phoneCtrl, icon: Icons.phone),
                  const SizedBox(height: 16),
                  if (editMode) SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => setState(() => editMode = false), child: const Text('ذخیره تغییرات'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({required String label, required TextEditingController ctrl, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        enabled: editMode,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: editMode ? Colors.white : Colors.grey.shade50,
        ),
      ),
    );
  }
}
