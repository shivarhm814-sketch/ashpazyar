import 'package:flutter/material.dart';

import '../../../../core/demo/demo_auth_repository.dart';
import '../../../../core/demo/demo_mode.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../pantry/presentation/pages/pantry_page.dart';
import '../../data/auth_repository.dart';
import '../widgets/ashpazyar_logo_mark.dart';
import '../widgets/ashpazyar_wordmark.dart';
import '../widgets/auth_text_field.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthRepository _authRepository =
      widget.authRepository ?? (isDemoMode ? DemoAuthRepository() : AuthRepository());
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _authRepository.login(
        identifier: _identifierController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PantryPage()),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'ورود انجام نشد. ایمیل/شماره یا رمز عبور را بررسی کن.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AshpazyarLogoMark(),
                      const SizedBox(height: 18),
                      const AshpazyarWordmark(),
                      const SizedBox(height: 18),
                      Text(
                        'کم‌هزینه بپز، خوشمزه بخور، هیچ‌چیز رو دور نریز.',
                        textAlign: TextAlign.center,
                        style: AppText.body(color: AppColors.tagline, height: 1.9).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AuthTextField(
                        label: 'ایمیل یا شماره موبایل',
                        controller: _identifierController,
                        hint: 'مثلا 0912xxxxxxx',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        label: 'رمز عبور',
                        controller: _passwordController,
                        hint: '••••••••',
                        obscureText: true,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(_error!, style: AppText.bodySoft(color: AppColors.tomato)),
                      ],
                      const SizedBox(height: 6),
                      PrimaryButton(
                        label: _submitting ? 'در حال ورود...' : 'ورود',
                        onPressed: _submitting ? null : _submit,
                        enabled: !_submitting,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: GestureDetector(
                            onTap: _submitting
                                ? null
                                : () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => RegisterPage(authRepository: _authRepository)),
                                    ),
                            child: RichText(
                              text: TextSpan(
                                style: AppText.bodySoft(),
                                children: [
                                  const TextSpan(text: 'حساب نداری؟ '),
                                  TextSpan(
                                    text: 'ثبت‌نام کن',
                                    style: AppText.bodySoft(color: AppColors.tomato).copyWith(fontWeight: FontWeight.w600),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
