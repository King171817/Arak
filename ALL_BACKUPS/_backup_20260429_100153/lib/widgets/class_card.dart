import 'package:flutter/material.dart';
import '../models/entities.dart';

class ClassCard extends StatelessWidget {
  final UniversityClass item;
  final VoidCallback onTap;
  final Widget? trailing;
  final String? statusText;

  const ClassCard({super.key, required this.item, required this.onTap, this.trailing, this.statusText});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                backgroundColor: item.isActive ? Colors.green.withOpacity(.16) : Colors.orange.withOpacity(.14),
                child: Icon(Icons.class_, color: item.isActive ? Colors.green : Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('استاد: ${item.professorName}', style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text('${item.semester} • ${item.schedule} • ${item.studentIds.length} دانشجو', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    if (statusText != null) ...<Widget>[
                      const SizedBox(height: 5),
                      Text(statusText!, style: TextStyle(color: item.isActive ? Colors.green : Colors.orange, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing! else const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
