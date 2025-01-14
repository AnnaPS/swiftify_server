import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template http_client}
/// A package to manage Http calls to the API.
/// {@endtemplate}
class ApiClient {
  /// {@macro http_client}
  ApiClient({
    HttpClient? httpClient,
    String? baseUrl,
  })  : _httpClient = httpClient ?? HttpClient(),
        _baseUrl = baseUrl ?? 'https://taylor-swift-api.sarbo.workers.dev';

  /// The [HttpClient] used to make requests.
  final HttpClient _httpClient;

  /// Base url for the API
  final String _baseUrl;

  bool _isSuccessful(int statusCode) => statusCode >= 200 && statusCode < 300;

  Future<T> _handleResponse<T>(
    HttpClientResponse response,
  ) async {
    if (_isSuccessful(response.statusCode)) {
      final result = await response.transform(utf8.decoder).join();
      return jsonDecode(result) as T;
    } else {
      throw _handleHttpError(response.statusCode, response, StackTrace.current);
    }
  }

  /// Handles the statusCode from the API
  /// Note: This is a simplified version of a real-world implementation.
  /// In a real-world scenario, you would have more detailed error handling.
  Exception _handleHttpError(
    int statusCode,
    Object error,
    StackTrace stackTrace,
  ) {
    final exception = switch (statusCode) {
      400 => BadRequestException(error),
      401 => UnauthorizedException(error),
      403 => ForbiddenException(error),
      404 => NotFoundException(error),
      500 => InternalServerErrorException(error),
      _ => NetworkException(error),
    };
    Error.throwWithStackTrace(exception, stackTrace);
  }

  /// GET request to [path].
  /// Returns a [Map] with the response body.
  Future<T> get<T>(String path) async {
    final uri = Uri.parse('$_baseUrl/$path');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    return _handleResponse(response);
  }
}
