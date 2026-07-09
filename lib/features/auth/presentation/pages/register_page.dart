import 'package:flutter/material.dart';

import '../../../../core/demo/demo_auth_repository.dart';
import '../../../../core/demo/demo_mode.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../pantry/presentation/pages/pantry_page.dart';
import '../../data/auth_repository.dart';
import '../widgets/ashpazyar_logo_mark.dart';
import '../widgets/auth_text_field.dart';

/// Sign-up screen — same auth shell/tokens as [LoginPage] (smaller logo,
/// labeled fields, one primary CTA) since the handoff only specifies Login
/// in detail; Register mirrors it 1:1 for visual consistency.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final AuthRepository _authRepository =
      widget.authRepository ?? (isDemoMode ? DemoAuthRepository() : AuthRepository());
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
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
      await _authRepository.register(
        name: _nameController.text.trim(),
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
      setState(() => _error = 'ثبت‌نام انجام نشد. دوباره امتحان کن.');
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const AshpazyarLogoMark(size: 76),
                const SizedBox(height: 14),
                Text('ثبت‌نام در آشپزیار', style: AppText.screenTitleLarge()),
                const SizedBox(height: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(label: 'نام', controller: _nameController, hint: 'مثلا: سارا'),
                    const SizedBox(height: 14),
                    AuthTextField(
                      label: 'شماره موبایل',
                      controller: _identifierController,
                      hint: 'مثلا 0912xxxxxxx',
                      keyboardType: TextInputType.phone,
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
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: _submitting ? 'در حال ثبت‌نام...' : 'ثبت‌نام',
                      onPressed: _submitting ? null : _submit,
                      enabled: !_submitting,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: _submitting ? null : () => Navigator.of(context).pop(),
                        child: RichText(
                          text: TextSpan(
                            style: AppText.bodySoft(),
                            children: [
                              const TextSpan(text: 'قبلاً ثبت‌نام کردی؟ '),
                              TextSpan(
                                text: 'وارد شو',
                                style: AppText.bodySoft(color: AppColors.tomato).copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
