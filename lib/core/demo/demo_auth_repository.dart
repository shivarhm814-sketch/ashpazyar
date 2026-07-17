import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/auth_repository.dart';

/// Stands in for [AuthRepository] in the offline demo build: no real network
/// request, no real backend — but login still requires having registered
/// that phone number at least once, tracked in local storage on-device.
class DemoAuthRepository extends AuthRepository {
  static const _registeredKey = 'demo_registered_identifiers';

  @override
  Future<void> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final registered = prefs.getStringList(_registeredKey) ?? const [];
    if (!registered.contains(identifier.trim())) {
      throw Exception('این شماره موبایل هنوز ثبت‌نام نکرده است.');
    }
  }

  @override
  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final registered = prefs.getStringList(_registeredKey) ?? const [];
    final trimmed = identifier.trim();
    if (!registered.contains(trimmed)) {
      await prefs.setStringList(_registeredKey, [...registered, trimmed]);
    }
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> hasSession() async => false;
}
