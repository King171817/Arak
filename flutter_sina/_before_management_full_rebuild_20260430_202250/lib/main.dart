import 'package:flutter/material.dart';

import 'app/modular_app.dart';
import 'services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseBootstrap.initializeIfConfigured();
  runApp(const ModularApp());
}
