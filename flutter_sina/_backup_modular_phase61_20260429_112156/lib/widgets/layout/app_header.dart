import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onNotificationsTap;
  final int unreadCount;

  const AppHeader({
    super.key,
    required this.title,
    this.onProfileTap,
    this.onLanguageTap,
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
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final String logoKey = appState.selectedLogoKey;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: logoColor(logoKey).withValues(alpha: 0.10),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: logoColor(logoKey).withValues(alpha: 0.14),
            child: Icon(
              logoIcon(logoKey),
              color: logoColor(logoKey),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onProfileTap,
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            onPressed: onLanguageTap,
            icon: const Icon(Icons.language),
          ),
          Stack(
            children: <Widget>[
              IconButton(
                onPressed: onNotificationsTap,
                icon: const Icon(Icons.notifications_none),
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
