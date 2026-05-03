import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'my_app.dart';

class AppBootstrap extends StatelessWidget {
  final Widget home;

  const AppBootstrap({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MyApp(home: home),
    );
  }
}
