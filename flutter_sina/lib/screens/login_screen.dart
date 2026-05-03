import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/auth/app_role.dart';
import '../models/users/app_user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: 'test_student@zigurat.com');
  final passwordController = TextEditingController(text: 'Test123456');

  bool loading = false;
  String? error;

  Future<void> login() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          error = 'ایمیل و رمز عبور الزامی است';
        });
        return;
      }

      // شبیه‌سازی ورود
      await Future.delayed(const Duration(milliseconds: 500));

      // تعیین نقش بر اساس ایمیل
      AppRole role = AppRole.student;
      String unitKey = 'all';

      if (email.contains('admin')) {
        role = AppRole.superAdmin;
      } else if (email.contains('prof')) {
        role = AppRole.professor;
      } else if (email.contains('manager')) {
        role = AppRole.educationManager;
      }

      // ایجاد کاربر
      final user = AppUserModel(
        id: email,
        username: email.split('@')[0],
        displayName: email.split('@')[0],
        role: role,
        unitKey: unitKey,
        permissions: [],
      );

      // بروزرسانی AppState
      if (!mounted) return;
      final appState = context.read<AppState>();
      appState.login(user);
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

  void fillUser(String email) {
    setState(() {
      emailController.text = email;
      passwordController.text = 'Test123456';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'ورود به اپلیکیشن دانشگاه',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        textDirection: TextDirection.ltr,
                        decoration: const InputDecoration(
                          labelText: 'ایمیل',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        textDirection: TextDirection.ltr,
                        decoration: const InputDecoration(
                          labelText: 'رمز عبور',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (error != null)
                        Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : login,
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text('ورود'),
                        ),
                      ),
                      const Divider(height: 32),
                      const Text(
                        'تست سریع:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () => fillUser('student1@test.com'),
                            child: const Text('دانشجو'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('prof1@test.com'),
                            child: const Text('استاد'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('officer1@test.com'),
                            child: const Text('کارشناس'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('manager1@test.com'),
                            child: const Text('مدیر'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin@test.com'),
                            child: const Text('ادمین'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
