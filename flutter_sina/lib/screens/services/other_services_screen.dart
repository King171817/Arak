import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
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
    final bool rtl = isRtlLang(lang);

    final List<_FutureServiceItem> services = <_FutureServiceItem>[
      _FutureServiceItem(Icons.translate, 'ترجمه مدارک', 'شرکت ترجمه / واحد بین‌الملل', true, true),
      _FutureServiceItem(Icons.print_outlined, 'پرینت و کپی', 'مرکز چاپ دانشگاه / شرکت همکار', true, false),
      _FutureServiceItem(Icons.local_taxi_outlined, 'تاکسی', 'شرکت حمل‌ونقل همکار', true, true),
      _FutureServiceItem(Icons.volunteer_activism_outlined, 'خدمات رفاهی', 'اداره رفاه / پیمانکار', true, true),
      _FutureServiceItem(Icons.sports_soccer_outlined, 'ورزش', 'اداره تربیت‌بدنی', false, false),
      _FutureServiceItem(Icons.health_and_safety_outlined, 'بیمه', 'شرکت بیمه همکار', true, true),
      _FutureServiceItem(Icons.currency_exchange, 'چنج پول', 'شرکت مالی مجاز / راهنما', true, true),
      _FutureServiceItem(Icons.local_library_outlined, 'کتابخانه', 'کتابخانه دانشگاه', false, false),
      _FutureServiceItem(Icons.map_outlined, 'نقشه دانشگاه', 'مدیریت سامانه', false, false),
      _FutureServiceItem(Icons.psychology_outlined, 'مشاوره', 'مرکز مشاوره دانشگاه', false, true),
      _FutureServiceItem(Icons.hotel_outlined, 'هتل', 'هتل / مرکز اقامتی همکار', true, true),
      _FutureServiceItem(Icons.flight_outlined, 'بلیط هواپیما', 'آژانس مسافرتی همکار', true, true),
      _FutureServiceItem(Icons.school_outlined, 'دوره آموزشی', 'مرکز آموزش آزاد / واحد آموزشی', true, false),
      _FutureServiceItem(Icons.support_agent_outlined, 'پشتیبانی خدمات', 'مرکز پشتیبانی سامانه', false, false),
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
              title: Text(rtl ? 'بازگشت' : 'Back', style: const TextStyle(fontSize: 13)),
              onTap: onBack,
            ),
          Container(
            decoration: AppDecorations.headerDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: <Widget>[
                const Icon(Icons.apps_outlined, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rtl ? 'مرکز خدمات دانشجویی و سازمانی' : 'Student and Partner Services Center',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rtl
                ? 'هر خدمت در آینده می‌تواند توسط شرکت، سازمان، واحد دانشگاه یا پیمانکار مدیریت شود.'
                : 'Each service can later be managed by a company, organization, university unit or contractor.',
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: services.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 820 ? 3 : 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 4.2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _ServiceFutureCard(item: services[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceFutureCard extends StatelessWidget {
  final _FutureServiceItem item;

  const _ServiceFutureCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          children: <Widget>[
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    item.providerType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (item.externalProvider)
              const Icon(Icons.business_outlined, size: 15, color: AppColors.textSecondary),
            if (item.needsApproval)
              const Icon(Icons.verified_outlined, size: 15, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _FutureServiceItem {
  final IconData icon;
  final String title;
  final String providerType;
  final bool externalProvider;
  final bool needsApproval;

  const _FutureServiceItem(
    this.icon,
    this.title,
    this.providerType,
    this.externalProvider,
    this.needsApproval,
  );
}


