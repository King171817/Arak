import 'package:flutter/material.dart';
import '../core/http/api_service.dart';
import 'login_screen.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  bool loading = true;
  String? error;
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final data = await ApiService.getAdminRequests();
      setState(() {
        requests = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await ApiService.updateRequestStatus(requestId: id, status: status);
      await loadRequests();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget statusButton(String id, String status, String label) {
    return OutlinedButton(
      onPressed: () => updateStatus(id, status),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('پنل مدیریت درخواست‌ها'),
          actions: [
            IconButton(
              onPressed: loadRequests,
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : requests.isEmpty
                    ? const Center(child: Text('درخواستی وجود ندارد'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final item = requests[index];
                          final status = item['status'] ?? 'pending';
                          final id = item['id'];

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['requestNumber'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('نوع: ${item['type']}'),
                                  Text('اولویت: ${item['priority']}'),
                                  Text('کاربر: ${item['userId']}'),
                                  Text('جزئیات: ${item['details'] ?? ''}'),
                                  const SizedBox(height: 8),
                                  Chip(
                                    label: Text(status),
                                    backgroundColor: statusColor(status).withValues(alpha: 0.15),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      statusButton(id, 'pending', 'در انتظار'),
                                      statusButton(id, 'in_progress', 'در حال انجام'),
                                      statusButton(id, 'completed', 'تکمیل شد'),
                                      statusButton(id, 'rejected', 'رد شد'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
