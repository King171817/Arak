import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'create_request_screen.dart';
import 'login_screen.dart';

class StudentRequestsScreen extends StatefulWidget {
  const StudentRequestsScreen({super.key});

  @override
  State<StudentRequestsScreen> createState() => _StudentRequestsScreenState();
}

class _StudentRequestsScreenState extends State<StudentRequestsScreen> {
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
      final data = await ApiService.getMyRequests();
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('درخواست‌های من'),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
            );
            loadRequests();
          },
          icon: const Icon(Icons.add),
          label: const Text('درخواست جدید'),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : requests.isEmpty
                    ? const Center(child: Text('هنوز درخواستی ثبت نشده است'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final item = requests[index];
                          final status = item['status'] ?? 'pending';

                          return Card(
                            child: ListTile(
                              title: Text(item['requestNumber'] ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('نوع: ${item['type']}'),
                                  Text('اولویت: ${item['priority']}'),
                                  Text('جزئیات: ${item['details'] ?? ''}'),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(status),
                                backgroundColor: statusColor(status).withValues(alpha: 0.15),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
