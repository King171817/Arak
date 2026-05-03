import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';
import '../../screens/student/profile/student_profile_screen.dart';

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

  final LayerLink profileLink = LayerLink();
  final LayerLink languageLink = LayerLink();
  final LayerLink notificationsLink = LayerLink();

  void closeHeaderPanel() {
    if (openedHeaderPanel == null) return;

    setState(() {
      openedHeaderPanel = null;
    });
  }

  void toggleHeaderPanel(String panel) {
    setState(() {
      openedHeaderPanel = openedHeaderPanel == panel ? null : panel;
    });
  }

  LayerLink activeLink() {
    switch (openedHeaderPanel) {
      case 'profile':
        return profileLink;
      case 'language':
        return languageLink;
      case 'notifications':
        return notificationsLink;
      default:
        return languageLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final String? floatingText = appState.visibleFloatingAnnouncementText();
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool compact = screenWidth < 560;
    final double panelWidth = openedHeaderPanel == 'language'
        ? (compact ? screenWidth - 32 : 220)
        : openedHeaderPanel == 'notifications'
            ? (compact ? screenWidth - 32 : 320)
            : (compact ? screenWidth - 32 : 300);

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: closeHeaderPanel,
          child: Container(
            decoration: AppDecorations.pageBackground(context),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: AppHeader(
                        title: appText(lang, widget.titleKey),
                        profileLink: profileLink,
                        languageLink: languageLink,
                        notificationsLink: notificationsLink,
                        unreadCount:
                            appState.getUnreadNotificationCountForCurrentRole(),
                                                                        
                      ),
                    ),
                    if (floatingText != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
                        child: GestureDetector(
                          onTap: appState.dismissFloatingAnnouncementForThisSession,
                          child: FloatingAnnouncementBanner(
                            message: floatingText,
                            onClose:
                                appState.dismissFloatingAnnouncementForThisSession,
                          ),
                        ),
                      ),
                    Expanded(child: widget.body),
                  ],
                ),
                if (openedHeaderPanel != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: false,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: closeHeaderPanel,
                        child: Stack(
                          children: <Widget>[
                            CompositedTransformFollower(
                              link: activeLink(),
                              showWhenUnlinked: false,
                              targetAnchor: isRtlLang(lang)
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              followerAnchor: isRtlLang(lang)
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              offset: Offset(isRtlLang(lang) ? 0 : 0, 6),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {},
                                child: SizedBox(
                                  width: panelWidth,
                                  child: _HeaderPanelContent(
                                    panel: openedHeaderPanel!,
                                    onClose: closeHeaderPanel,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: const FloatingSupportButton(),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: AppBottomNav(
              currentIndex: widget.currentIndex,
              onTap: (int index) {
                closeHeaderPanel();
                widget.onBottomTap(index);
              },
              items: widget.bottomItems,
            ),
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
    final AppLang lang = appState.selectedLang;

    Widget child;

    if (panel == 'language') {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            appText(lang, 'language'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppLang.values.map((AppLang item) {
              return ChoiceChip(
                label: Text(langCode(item)),
                selected: appState.selectedLang == item,
                onSelected: (_) {
                  appState.setLanguage(item);
                  onClose();
                },
              );
            }).toList(),
          ),
        ],
      );
    } else if (panel == 'notifications') {
      final notifications = appState.getCurrentRoleNotifications();
      final bool shouldScroll = notifications.length > 3;

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            appText(lang, 'notifications'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (notifications.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('اعلانی وجود ندارد.'),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: shouldScroll ? 280 : 210,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: shouldScroll
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final item = notifications[index];

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      item.unread
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                      color: item.unread ? AppColors.accent : null,
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
            ),
        ],
      );
    } else {
      final user = appState.currentUser;

      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user?.displayName ?? 'کاربر مهمان',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user?.username ?? '-',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          ListTile(
            dense: true,
            leading: const Icon(Icons.badge_outlined),
            title: const Text('نقش'),
            subtitle: Text(appState.currentRole.name),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.account_balance_outlined),
            title: const Text('واحد'),
            subtitle: Text(
              appState.currentUnitKey.isEmpty
                  ? '-'
                  : appText(lang, appState.currentUnitKey),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              onClose();

              if (appState.currentRole.name == 'student') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentProfileScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.edit_outlined),
            label: Text(
              isRtlLang(lang) ? 'ویرایش پروفایل' : 'Edit Profile',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              appState.logout();
              onClose();
            },
            icon: const Icon(Icons.logout),
            label: Text(appText(lang, 'logout')),
          ),
        ],
      );
    }

    return Material(
      elevation: 16,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}






