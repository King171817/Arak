import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../data/mock/mock_units.dart';
import '../../models/auth/app_role.dart';
import '../../models/units/other_service_model.dart';
import '../../state/app_state.dart';

class OtherServicesScreen extends StatelessWidget {
  const OtherServicesScreen({super.key});

  List<OtherService> _servicesForRole(AppRole role) {
    if (role == AppRole.student) {
      return studentOtherServices;
    }

    return staffOtherServices;
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;
    final List<OtherService> services = _servicesForRole(appState.currentRole);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (BuildContext context, int index) {
        final OtherService service = services[index];

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (service.assetPath.isNotEmpty)
                    Image.asset(
                      service.assetPath,
                      width: 48,
                      height: 48,
                      errorBuilder: (_, __, ___) {
                        return const Icon(Icons.apps, size: 48);
                      },
                    )
                  else
                    const Icon(Icons.apps, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(
                    appText(lang, service.titleKey),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    appText(lang, service.subtitleKey),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
