import '../../features/auth/data/auth_repository.dart';

/// Stands in for [AuthRepository] in the offline demo build: every call
/// succeeds instantly with no real network request, no stored session.
class DemoAuthRepository extends AuthRepository {
  @override
  Future<void> login({required String identifier, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> hasSession() async => false;
}
