import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'student_requests_screen.dart';
import 'admin_requests_screen.dart';

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
      final result = await ApiService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final role = result['user']?['role'];

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminRequestsScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentRequestsScreen()),
        );
      }
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () => fillUser('sina@zigurat.com'),
                            child: const Text('sina'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin1@zigurat.com'),
                            child: const Text('admin1'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin2@zigurat.com'),
                            child: const Text('admin2'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin3@zigurat.com'),
                            child: const Text('admin3'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin4@zigurat.com'),
                            child: const Text('admin4'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('admin@zigurat.com'),
                            child: const Text('admin دانشجو'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('prof1@zigurat.com'),
                            child: const Text('prof1'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('prof2@zigurat.com'),
                            child: const Text('prof2'),
                          ),
                          OutlinedButton(
                            onPressed: () => fillUser('test_student@zigurat.com'),
                            child: const Text('test_student'),
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
}
