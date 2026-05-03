import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../core/theme/theme.dart';
import '../../models/auth/app_lang.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

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
  bool loading = false;

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    final AppState appState = context.read<AppState>();

    try {
      await appState.loginWithRepository(
        username: userCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      if (!mounted) return;

      widget.onLoggedIn?.call();
    } catch (error) {
      if (!mounted) return;

      final String errorText = error.toString().contains('account_locked')
          ? (appState.selectedLang == AppLang.fa
              ? 'حساب یا نقش شما توسط مدیر اصلی قفل شده است'
              : appState.selectedLang == AppLang.ar
                  ? 'تم قفل حسابك أو دورك من قبل المدير الرئيسي'
                  : 'Your account or role has been locked by the super admin')
          : (appState.selectedLang == AppLang.fa
              ? 'نام کاربری یا رمز عبور اشتباه است'
              : appState.selectedLang == AppLang.ar
                  ? 'اسم المستخدم أو كلمة المرور غير صحيحة'
                  : 'Username or password is incorrect');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorText)),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final AppLang lang = appState.selectedLang;

    return Directionality(
      textDirection: textDirectionOf(lang),
      child: Scaffold(
        floatingActionButton: const FloatingSupportButton(),
        body: Container(
          decoration: AppDecorations.pageBackground(context),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -90,
                right: -80,
                child: _LoginGlow(
                  size: 230,
                  color: AppColors.primary.withValues(alpha: 0.16),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -80,
                child: _LoginGlow(
                  size: 280,
                  color: AppColors.secondary.withValues(alpha: 0.16),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 470),
                    child: Container(
                      decoration: AppDecorations.cardDecoration,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: const Icon(
                              Icons.account_balance_outlined,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            appText(lang, 'app_name'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            appText(lang, 'university_app'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
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
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: loading ? null : login,
                              icon: loading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.login),
                              label: Text(appText(lang, 'login')),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Test accounts:\n'
                              'Student: admin / 1234\n'
                              'Professor: prof1 / 1234\n'
                              'Education Manager: admin2 / 1234\n'
                              'Super Admin: sina / 1234\n'
                              'Education Officer: edu_officer1 / 1234',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _LoginGlow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

