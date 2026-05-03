import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/auth/app_lang.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ProfessorDashboardScreen extends StatelessWidget {
  final VoidCallback? onOpenClasses;
  final VoidCallback? onOpenMessages;
  final VoidCallback? onOpenServices;

  const ProfessorDashboardScreen({
    super.key,
    this.onOpenClasses,
    this.onOpenMessages,
    this.onOpenServices,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DashboardCard(
          title: appText(lang, 'classes'),
          subtitle: isRtlLang(lang)
              ? 'مشاهده کلاس‌های من و شروع کلاس'
              : 'View my classes and start live class',
          icon: Icons.school_outlined,
          onTap: onOpenClasses,
        ),
        DashboardCard(
          title: appText(lang, 'managers_chat'),
          subtitle: isRtlLang(lang)
              ? 'گفتگو با مدیران واحدهای دانشگاه'
              : 'Chat with university unit managers',
          icon: Icons.chat_outlined,
          onTap: onOpenMessages,
        ),
        DashboardCard(
          title: appText(lang, 'services'),
          subtitle: isRtlLang(lang)
              ? 'خدمات قابل استفاده استاد'
              : 'Professor available services',
          icon: Icons.apps_outlined,
          onTap: onOpenServices,
        ),
      ],
    );
  }
}
