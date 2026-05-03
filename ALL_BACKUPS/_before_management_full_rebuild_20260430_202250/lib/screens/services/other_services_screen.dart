import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../state/app_state.dart';

class OtherServicesScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const OtherServicesScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final List<_ServiceItem> services = <_ServiceItem>[
      _ServiceItem(Icons.translate, 'ترجمه مدارک'),
      _ServiceItem(Icons.print_outlined, 'پرینت و کپی'),
      _ServiceItem(Icons.local_taxi_outlined, 'تاکسی'),
      _ServiceItem(Icons.volunteer_activism_outlined, 'خدمات رفاهی'),
      _ServiceItem(Icons.sports_soccer_outlined, 'ورزش'),
      _ServiceItem(Icons.health_and_safety_outlined, 'بیمه'),
      _ServiceItem(Icons.currency_exchange, 'چنج پول'),
      _ServiceItem(Icons.local_library_outlined, 'کتابخانه'),
      _ServiceItem(Icons.map_outlined, 'نقشه دانشگاه'),
      _ServiceItem(Icons.psychology_outlined, 'مشاوره'),
      _ServiceItem(Icons.hotel_outlined, 'هتل'),
      _ServiceItem(Icons.flight_outlined, 'بلیط هواپیما'),
      _ServiceItem(Icons.school_outlined, 'دوره آموزشی'),
      _ServiceItem(Icons.support_agent_outlined, 'پشتیبانی خدمات'),
    ];

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          if (onBack != null)
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              leading: const Icon(Icons.arrow_back, size: 20),
              title: const Text('بازگشت', style: TextStyle(fontSize: 13)),
              onTap: onBack,
            ),
          const ListTile(
            dense: true,
            visualDensity: VisualDensity(horizontal: -2, vertical: -3),
            leading: Icon(Icons.apps_outlined, size: 20),
            title: Text(
              'سایر خدمات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              'خدمات دانشجویی و رفاهی',
              style: TextStyle(fontSize: 10),
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            itemCount: services.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 4.6,
            ),
            itemBuilder: (BuildContext context, int index) {
              final _ServiceItem item = services[index];

              return _CompactServiceCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _CompactServiceCard extends StatelessWidget {
  final _ServiceItem item;

  const _CompactServiceCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    item.icon,
                    size: 17,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

