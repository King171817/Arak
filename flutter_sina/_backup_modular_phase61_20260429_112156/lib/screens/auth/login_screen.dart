import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoggedIn;

  const LoginScreen({
    super.key,
    this.onLoggedIn,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool passwordVisible = false;

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void login() {
    final AppState appState = context.read<AppState>();

    try {
      appState.loginDemo(
        username: userCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      widget.onLoggedIn?.call();
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appState.selectedLang == AppLang.fa
                ? 'نام کاربری یا رمز عبور اشتباه است'
                : appState.selectedLang == AppLang.ar
                    ? 'اسم المستخدم أو كلمة المرور غير صحيحة'
                    : 'Username or password is incorrect',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.account_balance_outlined,
                        size: 64,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        appText(lang, 'app_name'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        appText(lang, 'university_app'),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AppLang.values.map((AppLang item) {
                          return ChoiceChip(
                            label: Text(langCode(item)),
                            selected: appState.selectedLang == item,
                            onSelected: (_) => appState.setLanguage(item),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: userCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: appText(lang, 'username'),
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passCtrl,
                        obscureText: !passwordVisible,
                        onSubmitted: (_) => login(),
                        decoration: InputDecoration(
                          labelText: appText(lang, 'password'),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: login,
                          icon: const Icon(Icons.login),
                          label: Text(appText(lang, 'login')),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'student: admin / manager: admin1-admin4 / professor: prof1 / super admin: sina / pass: 1234',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
