import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../notifications/notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('داشبورد'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'داشبورد اصلی',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, size: 28),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.notifications, size: 28),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}












