import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../models/permissions/education_permission.dart';
import '../../../models/permissions/permission_model.dart';
import '../../../models/users/education_officer_model.dart';
import '../../../state/app_state.dart';
import '../../../widgets/widgets.dart';

class ManagerOfficersScreen extends StatelessWidget {
  const ManagerOfficersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final lang = appState.selectedLang;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        SectionCard(
          title: appText(lang, 'officers'),
          icon: Icons.admin_panel_settings_outlined,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  onPressed: appState.hasPermission(AppPermission.manageOfficers)
                      ? () {
                          final String id =
                              'eo${DateTime.now().millisecondsSinceEpoch}';
                          appState.addEducationOfficer(
                            EducationOfficerModel(
                              id: id,
                              name: 'کارشناس جدید',
                              username: 'edu_$id',
                              password: '1234',
                              permissions: const <EducationPermission>[
                                EducationPermission.viewReports,
                                EducationPermission.privateChat,
                              ],
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  label: const Text('افزودن کارشناس'),
                ),
              ),
              ...appState.educationOfficers.map((officer) {
                return ExpansionTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(officer.name),
                  subtitle: Text(officer.username),
                  children: EducationPermission.values.map((permission) {
                    final bool selected = officer.permissions.contains(permission);
                    return CheckboxListTile(
                      value: selected,
                      title: Text(permission.name),
                      onChanged: appState.hasPermission(AppPermission.manageOfficers)
                          ? (bool? value) {
                              final updated =
                                  List<EducationPermission>.from(officer.permissions);
                              if (value == true && !updated.contains(permission)) {
                                updated.add(permission);
                              } else if (value == false) {
                                updated.remove(permission);
                              }

                              appState.updateEducationOfficerPermissions(
                                officerId: officer.id,
                                permissions: updated,
                              );
                            }
                          : null,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

