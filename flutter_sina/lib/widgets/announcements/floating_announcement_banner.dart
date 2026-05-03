import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/auth/app_lang.dart';
import '../../models/floating_message.dart';
import '../../state/app_state.dart';

class FloatingAnnouncementBanner extends StatefulWidget {
  final Widget child;

  const FloatingAnnouncementBanner({
    super.key,
    required this.child,
  });

  @override
  State<FloatingAnnouncementBanner> createState() => _FloatingAnnouncementBannerState();
}

class _FloatingAnnouncementBannerState extends State<FloatingAnnouncementBanner> {
  final dismissedInSession = <String>{};

  final demoMessages = <FloatingMessage>[
    FloatingMessage(
      id: 'demo-global-1',
      texts: {
        AppLang.fa: 'اطلاعیه مهم: لطفاً اطلاعات پروفایل خود را بررسی کنید.',
        AppLang.en: 'Important notice: Please review your profile information.',
        AppLang.ar: 'إشعار مهم: يرجى مراجعة معلومات ملفك الشخصي.',
      },
      startAt: DateTime(2020),
      endAt: DateTime(2035),
      targetRoles: const [],
      targetUnits: const [],
      targetUserIds: const [],
      allRoles: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    final visible = demoMessages.where((m) {
      return !dismissedInSession.contains(m.id) &&
          m.canShowFor(
            userId: appState.currentUser?.id ?? 'guest',
            role: appState.currentUser?.role.name ?? 'guest',
            unit: '',
          );
    }).toList();

    if (visible.isEmpty) return widget.child;

    final message = visible.first;

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 12,
          right: 12,
          top: 12,
          child: SafeArea(
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.campaign_outlined, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message.textFor(lang),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => dismissedInSession.add(message.id)),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

