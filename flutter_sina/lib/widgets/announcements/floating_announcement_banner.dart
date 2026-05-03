import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/admin_advanced_repository.dart';
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
  final repository = AdminAdvancedRepository();

  bool loading = true;
  String? error;
  List<dynamic> messages = <dynamic>[];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final result = await repository.fetchFloatingMessages();
      if (!mounted) return;
      setState(() {
        messages = result;
        loading = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        messages = <dynamic>[];
        loading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    if (loading || error != null || messages.isEmpty) {
      return widget.child;
    }

    final visible = messages.where((m) {
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
