import 'package:flutter/material.dart';
import '../models/unit_models.dart';

class OtherServiceCard extends StatelessWidget {
  final OtherService service;
  final VoidCallback onTap;

  const OtherServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface
              .withOpacity(dark ? 0.88 : 0.96),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.22 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: service.color.withOpacity(dark ? 0.22 : 0.12),
              ),
              child: Icon(service.icon, size: 23, color: service.color),
            ),
            const SizedBox(height: 8),
            Text(
              service.key,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
