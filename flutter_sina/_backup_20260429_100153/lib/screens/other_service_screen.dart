import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';

class OtherServiceScreen extends StatelessWidget {
  final String serviceKey;
  const OtherServiceScreen({super.key, required this.serviceKey});

  IconData _getServiceIcon(String key) {
    switch (key) {
      case 'taxi': return Icons.local_taxi;
      case 'translation': return Icons.translate;
      case 'insurance': return Icons.health_and_safety;
      case 'bank': return Icons.account_balance;
      case 'restaurant': return Icons.restaurant;
      case 'gym': return Icons.fitness_center;
      case 'library': return Icons.library_books;
      case 'printing': return Icons.print;
      default: return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context);
    final AppLang selectedLang = appState.selectedLang;
    final bool isRtl = isRtlLang(selectedLang);
    final String title = appText(selectedLang, serviceKey);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.12),
                      ),
                      child: Icon(
                        _getServiceIcon(serviceKey),
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRtl
                          ? 'این بخش به زودی فعال خواهد شد'
                          : 'This section will be available soon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: Text(isRtl ? 'بازگشت' : 'Back'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
