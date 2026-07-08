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
      setState(() => _error = 'ورود انجام نشد. شماره موبایل یا رمز عبور را بررسی کن.');
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
        body: Stack(
          children: [
            // subtle floating ingredients — decorative only, kept small and
            // low-opacity along the bottom edge so it doesn't compete with
            // the login form above it.
            const Positioned(bottom: 96, right: 8, child: _FloatingFood(emoji: '🍅', size: 34, angle: -0.18)),
            const Positioned(bottom: 150, left: 4, child: _FloatingFood(emoji: '🥕', size: 30, angle: 0.16)),
            const Positioned(bottom: 40, left: 56, child: _FloatingFood(emoji: '🥚', size: 26, angle: 0.1)),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      const AshpazyarLogoMark(size: 124),
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
                      const SizedBox(height: 6),
                      PrimaryButton(
                        label: _submitting ? 'در حال ورود...' : 'ورود به آشپزیار',
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
          ],
        ),
      ),
    );
  }
}

/// A small, low-opacity rotated food emoji used as decorative texture near
/// the bottom of the Login screen — purely visual, never intercepts taps.
class _FloatingFood extends StatelessWidget {
  const _FloatingFood({required this.emoji, required this.size, required this.angle});

  final String emoji;
  final double size;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: angle,
        child: Opacity(
          opacity: 0.16,
          child: Text(emoji, style: TextStyle(fontSize: size)),
        ),
      ),
    );
  }
}
