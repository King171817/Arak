import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/unit_keys.dart';
import '../../models/units/unit_model.dart';
import '../../models/units/other_service_model.dart';

final List<UnitModel> mockUnits = <UnitModel>[
  UnitModel(keyName: UnitKeys.international, icon: Icons.public, unread: 2),
  UnitModel(keyName: UnitKeys.studentServices, icon: Icons.support_agent, unread: 1),
  UnitModel(keyName: UnitKeys.education, icon: Icons.school, unread: 3),
  UnitModel(keyName: UnitKeys.consular, icon: Icons.badge, unread: 0),
  UnitModel(keyName: UnitKeys.otherServices, icon: Icons.apps, unread: 0),
];

final List<OtherService> studentOtherServices = <OtherService>[
  OtherService(
    id: 'money_exchange',
    titleKey: 'money_exchange',
    subtitleKey: 'money_exchange_subtitle',
    assetPath: AppAssets.money,
    studentVisible: true,
    staffVisible: false,
  ),
  OtherService(
    id: 'hotel',
    titleKey: 'hotel',
    subtitleKey: 'hotel_subtitle',
    assetPath: AppAssets.hotel,
    studentVisible: true,
    staffVisible: false,
  ),
  OtherService(
    id: 'taxi',
    titleKey: 'taxi',
    subtitleKey: 'taxi_subtitle',
    assetPath: AppAssets.taxi,
    studentVisible: true,
    staffVisible: false,
  ),
  OtherService(
    id: 'translation',
    titleKey: 'translation',
    subtitleKey: 'translation_subtitle',
    assetPath: AppAssets.translator,
    studentVisible: true,
    staffVisible: true,
  ),
  OtherService(
    id: 'air_ticket',
    titleKey: 'air_ticket',
    subtitleKey: 'air_ticket_subtitle',
    assetPath: AppAssets.airport,
    studentVisible: true,
    staffVisible: false,
  ),
  OtherService(
    id: 'courses',
    titleKey: 'courses',
    subtitleKey: 'courses_subtitle',
    assetPath: AppAssets.learning,
    studentVisible: true,
    staffVisible: false,
  ),
  OtherService(
    id: 'printing',
    titleKey: 'printing',
    subtitleKey: 'printing_subtitle',
    assetPath: '',
    studentVisible: true,
    staffVisible: true,
  ),
  OtherService(
    id: 'welfare',
    titleKey: 'welfare',
    subtitleKey: 'welfare_subtitle',
    assetPath: '',
    studentVisible: true,
    staffVisible: true,
  ),
];

final List<OtherService> staffOtherServices = studentOtherServices
    .where((OtherService service) => service.staffVisible)
    .toList();
