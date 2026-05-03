import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';

class OtherServicesScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const OtherServicesScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<AppState>().selectedLang;
    final width = MediaQuery.of(context).size.width;
    final columns = width > 900 ? 3 : 2;

    final services = <_ServiceItem>[
      _ServiceItem(Icons.currency_exchange, t(lang, 'exchange_money')),
      _ServiceItem(Icons.flight_takeoff, t(lang, 'flight_ticket')),
      _ServiceItem(Icons.local_taxi, t(lang, 'taxi')),
      _ServiceItem(Icons.translate, t(lang, 'translation')),
      _ServiceItem(Icons.hotel, t(lang, 'hotel')),
      _ServiceItem(Icons.school, t(lang, 'training_courses')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t(lang, 'other_services')),
        leading: onBack == null ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Container(
        decoration: AppDecorations.pageBackground(context),
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 3.8,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.title} ${t(lang, 'under_development')}')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 22, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String title;

  const _ServiceItem(this.icon, this.title);
}

