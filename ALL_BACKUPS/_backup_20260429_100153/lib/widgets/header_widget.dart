import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helpers.dart';
import '../models/app_state.dart';
import '../screens/profile_screen.dart';

class HeaderWithInteractiveSidePanel extends StatelessWidget {
  final String? activePanel;
  final void Function(String key) onPanelToggle;
  const HeaderWithInteractiveSidePanel({super.key, required this.activePanel, required this.onPanelToggle});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLang = appState.selectedLang;
    final isRtl = isRtlLang(selectedLang);
    final isDarkMode = appState.isDarkMode;
    final unreadCount = appState.getUnreadCount();

    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withOpacity(0.20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode ? [const Color(0xFF1E293B), const Color(0xFF0F172A)] : [Colors.green.shade700, Colors.green.shade500],
                ),
              ),
            ),
            Positioned.fill(child: Container(color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.3))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)]),
                    child: const Icon(Icons.account_balance_outlined, size: 40, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text('اپلیکیشن ارتباط با دانشگاه', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('ارتباط ساده‌تر دانشجویان بین‌الملل با واحدهای دانشگاه', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Positioned(
              top: 8, right: isRtl ? 16 : null, left: isRtl ? null : 16,
              child: Column(
                children: [
                  _HeaderActionIcon(icon: Icons.person_outline, isActive: activePanel == 'profile', onTap: () => onPanelToggle('profile')),
                  const SizedBox(height: 10),
                  _HeaderActionIcon(icon: Icons.language, isActive: activePanel == 'language', onTap: () => onPanelToggle('language')),
                  const SizedBox(height: 10),
                  _HeaderActionIcon(icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined, isActive: false, onTap: appState.toggleTheme),
                  const SizedBox(height: 10),
                  _HeaderActionIcon(icon: Icons.notifications_none, isActive: activePanel == 'notifications', showBlinkDot: unreadCount > 0, onTap: () => onPanelToggle('notifications')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderActionIcon extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool showBlinkDot;
  const _HeaderActionIcon({required this.icon, required this.isActive, required this.onTap, this.showBlinkDot = false});

  @override
  State<_HeaderActionIcon> createState() => _HeaderActionIconState();
}

class _HeaderActionIconState extends State<_HeaderActionIcon> with SingleTickerProviderStateMixin {
  bool hovering = false;
  late AnimationController blinkController;

  @override
  void initState() {
    super.initState();
    blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);
  }

  @override
  void dispose() {
    blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: widget.isActive || hovering ? Colors.green.withOpacity(0.12) : Theme.of(context).colorScheme.surface.withOpacity(0.85),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(widget.icon, color: Colors.black87, size: 20),
            ),
            if (widget.showBlinkDot)
              Positioned(
                top: 2, right: 2,
                child: FadeTransition(
                  opacity: blinkController,
                  child: Container(width: 11, height: 11, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
