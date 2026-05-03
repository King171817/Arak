import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../models/auth/app_lang.dart';
import '../../models/auth/app_role.dart';
import '../../state/app_state.dart';
import '../../screens/student/profile/student_profile_screen.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final LayerLink profileLink;
  final LayerLink languageLink;
  final LayerLink notificationsLink;
  final int unreadCount;

  const AppHeader({
    super.key,
    required this.title,
    required this.profileLink,
    required this.languageLink,
    required this.notificationsLink,
    this.onProfileTap,
    this.onNotificationsTap,
    this.unreadCount = 0,
  });

  IconData logoIcon(String key) {
    switch (key) {
      case 'international':
        return Icons.public;
      case 'education':
        return Icons.school;
      case 'event':
        return Icons.celebration_outlined;
      case 'default':
      default:
        return Icons.account_balance_outlined;
    }
  }

  Color logoColor(String key) {
    switch (key) {
      case 'international':
        return Colors.blue;
      case 'education':
        return Colors.deepPurple;
      case 'event':
        return Colors.orange;
      case 'default':
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final String logoKey = appState.selectedLogoKey;
    final bool compact = MediaQuery.of(context).size.width < 560;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: compact ? 116 : 134,
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  AppAssets.arakGif,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFF1565C0),
                            Color(0xFF1E88E5),
                            Color(0xFF26A69A),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.14),
                        Colors.black.withValues(alpha: 0.48),
                      ],
                    ),
                  ),
                ),

                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _HeaderProfileMenu(),
                      _HeaderLanguageMenu(),
                      _HeaderNotificationsMenu(unreadCount: unreadCount),
                    ],
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: compact ? 46 : 56,
                        height: compact ? 46 : 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          logoIcon(logoKey),
                          color: logoColor(logoKey),
                          size: compact ? 25 : 31,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'دانشگاه اراک',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: compact ? 13 : 16,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 54),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: compact ? 9 : 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                PositionedDirectional(
                  start: 10,
                  bottom: 7,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: compact ? 130 : 210),
                    child: Text(
                      appState.currentUser?.displayName ?? 'Arak University',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w600,
                        fontSize: compact ? 9 : 11,
                      ),
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

class _HeaderProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final user = appState.currentUser;
    final AppLang lang = appState.selectedLang;
    final bool rtl = isRtlLang(lang);

    return PopupMenuButton<String>(
      tooltip: appText(lang, 'profile'),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 220,
        maxWidth: 280,
      ),
      position: PopupMenuPosition.under,
      onSelected: (String value) {
        if (value == 'edit_profile') {
          if (appState.currentRole == AppRole.student) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: StudentProfileScreen(),
                ),
              ),
            );
          }
        }

        if (value == 'logout') {
          appState.logout();
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            enabled: false,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user?.displayName ?? 'کاربر',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.username ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        appState.currentRole.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'edit_profile',
            enabled: appState.currentRole == AppRole.student,
            height: 34,
            child: Row(
              children: <Widget>[
                const Icon(Icons.edit_outlined, size: 16),
                const SizedBox(width: 8),
                Text(
                  rtl ? 'ویرایش پروفایل' : 'Edit Profile',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'logout',
            height: 34,
            child: Row(
              children: <Widget>[
                const Icon(Icons.logout, size: 16),
                const SizedBox(width: 8),
                Text(
                  appText(lang, 'logout'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ];
      },
      child: const _HeaderMenuIcon(icon: Icons.person_outline),
    );
  }
}

class _HeaderLanguageMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();

    return PopupMenuButton<AppLang>(
      tooltip: 'language',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 150,
      ),
      position: PopupMenuPosition.under,
      onSelected: appState.setLanguage,
      itemBuilder: (BuildContext context) {
        return AppLang.values.map((AppLang item) {
          final bool selected = appState.selectedLang == item;

          return PopupMenuItem<AppLang>(
            value: item,
            height: 32,
            child: Row(
              children: <Widget>[
                Icon(
                  selected ? Icons.check_circle : Icons.language,
                  size: 14,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 7),
                Text(
                  langCode(item),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: const _HeaderMenuIcon(icon: Icons.language),
    );
  }
}

class _HeaderNotificationsMenu extends StatelessWidget {
  final int unreadCount;

  const _HeaderNotificationsMenu({
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;
    final notifications = appState.getCurrentRoleNotifications();

    return PopupMenuButton<String>(
      tooltip: appText(lang, 'notifications'),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 240,
        maxWidth: 320,
      ),
      position: PopupMenuPosition.under,
      onSelected: (String id) {
        if (id.isNotEmpty) {
          appState.markNotificationAsRead(id);
        }
      },
      itemBuilder: (BuildContext context) {
        if (notifications.isEmpty) {
          return <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              enabled: false,
              height: 34,
              child: Text(
                'اعلانی وجود ندارد.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ];
        }

        return notifications.take(6).map((item) {
          return PopupMenuItem<String>(
            value: item.id,
            height: 52,
            child: Row(
              children: <Widget>[
                Icon(
                  item.unread
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  size: 17,
                  color: item.unread ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const _HeaderMenuIcon(icon: Icons.notifications_none),
          if (unreadCount > 0)
            PositionedDirectional(
              top: -5,
              end: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderMenuIcon extends StatelessWidget {
  final IconData icon;

  const _HeaderMenuIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsetsDirectional.only(start: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.34),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 17,
      ),
    );
  }
}



