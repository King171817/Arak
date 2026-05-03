import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../data/mock/mock_units.dart';
import '../../models/auth/app_lang.dart';
import '../../models/units/unit_model.dart';
import '../../state/app_state.dart';
import 'communication/units_communication_screen.dart';

class UnitsScreen extends StatelessWidget {
  final ValueChanged<String>? onOpenUnit;

  const UnitsScreen({
    super.key,
    this.onOpenUnit,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return Container(
      decoration: AppDecorations.pageBackground(context),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: <Widget>[
          ListTile(
            dense: true,
            leading: const Icon(Icons.account_balance_outlined, size: 22),
            title: Text(
              appText(lang, 'units'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              'ارتباط با واحدهای دانشگاه',
              style: TextStyle(fontSize: 11),
            ),
          ),
          const Divider(height: 12),
          ...mockUnits.map((UnitModel unit) {
            return ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Icon(unit.icon, size: 18),
              title: Text(
                appText(lang, unit.keyName),
                style: const TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                appText(lang, 'enter_section'),
                style: const TextStyle(fontSize: 10),
              ),
              trailing: const Icon(Icons.chevron_right, size: 16),
              onTap: () {
                if (onOpenUnit != null) {
                  onOpenUnit!(unit.keyName);
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UnitsCommunicationScreen(
                      unitKey: unit.keyName,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
