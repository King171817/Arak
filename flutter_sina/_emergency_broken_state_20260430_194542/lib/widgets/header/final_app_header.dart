import 'package:flutter/material.dart';

class FinalAppHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final Widget? bottomContent;

  const FinalAppHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions = const <Widget>[],
    this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            if (leading != null) leading!,
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...actions,
          ],
        ),
        if (bottomContent != null) ...<Widget>[
          const SizedBox(height: 12),
          bottomContent!,
        ],
      ],
    );
  }
}
