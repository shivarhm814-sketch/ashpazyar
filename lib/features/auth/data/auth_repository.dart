import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';

/// Talks to the existing FastAPI auth endpoints and persists the issued token.
class AuthRepository {
  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? const TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  Future<void> login({required String identifier, required String password}) async {
    final response = await _apiClient.post('/auth/login', body: {
      'identifier': identifier,
      'password': password,
    });
    await _tokenStorage.saveToken(response['token'] as String);
  }

  Future<void> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    final response = await _apiClient.post('/auth/register', body: {
      'name': name,
      'identifier': identifier,
      'password': password,
    });
    await _tokenStorage.saveToken(response['token'] as String);
  }

  Future<void> logout() => _tokenStorage.clearToken();

  Future<bool> hasSession() async => (await _tokenStorage.readToken())?.isNotEmpty ?? false;
}
