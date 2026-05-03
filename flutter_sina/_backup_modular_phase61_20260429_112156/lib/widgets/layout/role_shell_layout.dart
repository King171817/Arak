import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

class RoleShellLayout extends StatefulWidget {
  final String titleKey;
  final int currentIndex;
  final List<BottomNavigationBarItem> bottomItems;
  final ValueChanged<int> onBottomTap;
  final Widget body;

  const RoleShellLayout({
    super.key,
    required this.titleKey,
    required this.currentIndex,
    required this.bottomItems,
    required this.onBottomTap,
    required this.body,
  });

  @override
  State<RoleShellLayout> createState() => _RoleShellLayoutState();
}

class _RoleShellLayoutState extends State<RoleShellLayout> {
  String? openedHeaderPanel;

  void closeHeaderPanel() {
    if (openedHeaderPanel == null) return;
    setState(() {
      openedHeaderPanel = null;
    });
  }

  void openHeaderPanel(String panel) {
    setState(() {
      openedHeaderPanel = panel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final String? floatingText = appState.visibleFloatingAnnouncementText();

    return Directionality(
      textDirection: textDirectionOf(appState.selectedLang),
      child: AppDismissibleShell(
        onDismiss: closeHeaderPanel,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  AppHeader(
                    title: appText(appState.selectedLang, widget.titleKey),
                    unreadCount: appState.getUnreadNotificationCountForCurrentRole(),
                    onProfileTap: () => openHeaderPanel('profile'),
                    onLanguageTap: () => openHeaderPanel('language'),
                    onNotificationsTap: () => openHeaderPanel('notifications'),
                  ),
                  if (floatingText != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: FloatingAnnouncementBanner(
                        message: floatingText,
                        onClose: appState.dismissFloatingAnnouncementForThisSession,
                      ),
                    ),
                  Expanded(child: widget.body),
                ],
              ),
              if (openedHeaderPanel != null)
                Positioned(
                  top: 76,
                  left: 16,
                  right: 16,
                  child: _HeaderPanelContent(
                    panel: openedHeaderPanel!,
                    onClose: closeHeaderPanel,
                  ),
                ),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: widget.currentIndex,
            onTap: (int index) {
              closeHeaderPanel();
              widget.onBottomTap(index);
            },
            items: widget.bottomItems,
          ),
        ),
      ),
    );
  }
}

class _HeaderPanelContent extends StatelessWidget {
  final String panel;
  final VoidCallback onClose;

  const _HeaderPanelContent({
    required this.panel,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    Widget child;

    if (panel == 'language') {
      child = Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AppLang.values.map((AppLang lang) {
          return ChoiceChip(
            label: Text(langCode(lang)),
            selected: appState.selectedLang == lang,
            onSelected: (_) {
              appState.setLanguage(lang);
              onClose();
            },
          );
        }).toList(),
      );
    } else if (panel == 'notifications') {
      final notifications = appState.getCurrentRoleNotifications();

      child = notifications.isEmpty
          ? const Text('اعلانی وجود ندارد.')
          : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: notifications.length > 3 ? 260 : 160,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      item.unread
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    onTap: () {
                      appState.markNotificationAsRead(item.id);
                      onClose();
                    },
                  );
                },
              ),
            );
    } else {
      final user = appState.currentUser;
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user?.displayName ?? 'کاربر مهمان',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(user?.username ?? '-'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              appState.logout();
              onClose();
            },
            icon: const Icon(Icons.logout),
            label: Text(appText(appState.selectedLang, 'logout')),
          ),
        ],
      );
    }

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: child,
      ),
    );
  }
}

