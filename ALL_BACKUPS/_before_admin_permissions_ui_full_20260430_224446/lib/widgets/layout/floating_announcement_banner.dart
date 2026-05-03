import 'package:flutter/material.dart';

class FloatingAnnouncementBanner extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const FloatingAnnouncementBanner({
    super.key,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (message.trim().isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(18),
      color: Colors.amber.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onClose,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.campaign_outlined),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
              const Icon(Icons.close, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
