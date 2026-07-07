import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_storage.dart';

/// Thrown for any non-2xx response. [statusCode] lets repositories map
/// specific backend error codes to typed failure reasons.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin wrapper around the FastAPI backend: attaches the bearer token,
/// (de)serializes JSON, and normalizes failures to [ApiException].
class ApiClient {
  ApiClient({
    this.baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.ashpazyar.ir'),
    http.Client? httpClient,
    TokenStorage? tokenStorage,
  })  : _http = httpClient ?? http.Client(),
        _tokenStorage = tokenStorage ?? const TokenStorage();

  final String baseUrl;
  final http.Client _http;
  final TokenStorage _tokenStorage;

  Future<Map<String, String>> _headers() async {
    final token = await _tokenStorage.readToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, '$value')),
    );
    final response = await _http.get(uri, headers: await _headers());
    return _decode(response);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _http.post(
      uri,
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _http.delete(uri, headers: await _headers());
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final status = response.statusCode;
    final rawBody = response.body.isEmpty ? null : jsonDecode(response.body);

    if (status < 200 || status >= 300) {
      final message = (rawBody is Map && rawBody['detail'] != null)
          ? '${rawBody['detail']}'
          : 'درخواست با خطا مواجه شد';
      throw ApiException(status, message);
    }

    return rawBody;
  }
}
