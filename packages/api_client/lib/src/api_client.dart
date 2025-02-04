import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';

/// {@template http_client}
/// A package to manage Http calls to the API.
/// {@endtemplate}
class ApiClient {
  /// {@macro http_client}
  ApiClient({
    Dio? dio,
    String? baseUrl,
  })  : _dio = dio ??
            Dio(
                // BaseOptions(
                //   headers: {
                //     'Access-Control-Allow-Origin': '*',
                //     'Access-Control-Allow-Methods':
                //         'GET, POST, PUT, DELETE, OPTIONS',
                //     'Access-Control-Allow-Headers':
                //         'Origin, Content-Type, X-Auth-Token',
                //     'Content-Type': 'application/json',
                //   },
                // ),
                ),
        _baseUrl = baseUrl ?? 'https://taylor-swift-api.sarbo.workers.dev';

  /// The [Dio] used to make requests.
  final Dio _dio;

  /// Base url for the API
  final String _baseUrl;

  bool _isSuccessful(Response<dynamic> response) {
    final statusCode = response.statusCode ?? -1;
    return statusCode >= 200 && statusCode < 300;
  }

  T? _handleResponse<T>(Response<T> response) {
    final data = response.data;

    if (_isSuccessful(response)) {
      return data;
    } else {
      throw const DeserializationException.emptyResponseBody();
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

  /// Makes a GET request to the API.
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? body,
  }) async {
    late final Response<T> response;
    try {
      response = await _dio.get(
        '$_baseUrl/$path',
        data: body,
        queryParameters: queryParameters,
        //options: Options(headers: headers),
      );
    } catch (error, stackTrace) {
      _handleHttpError(
        (error is DioException) ? error.response?.statusCode ?? -1 : -1,
        error,
        stackTrace,
      );
    }

    return _handleResponse(response);
  }
}
