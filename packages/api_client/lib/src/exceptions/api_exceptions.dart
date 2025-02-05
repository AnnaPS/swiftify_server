/// {@template api_exception}
/// Base exception for ApiClient.
/// {@endtemplate}
abstract class ApiException implements Exception {
  /// {@macro api_exception}
  const ApiException(this.error);

  /// Error originally thrown in the API layer.
  /// Passed through to be reported in the upper layer.
  final Object error;
}

/// {@template network_exception}
/// Umbrella for all the exceptions that can be thrown by the API.
/// {@endtemplate}
class NetworkException extends ApiException {
  /// {@macro network_exception}
  const NetworkException(super.error);

  @override
  String toString() => '[NetworkException] $error';
}

/// {@template bad_request_exception}
/// 400 Bad Request.
/// {@endtemplate}
class BadRequestException extends ApiException {
  /// {@macro bad_request_exception}
  const BadRequestException(super.error);

  @override
  String toString() => '[BadRequestException] $error';
}

/// {@template unauthorized_exception}
/// 401 Unauthorized.
/// {@endtemplate}
class UnauthorizedException extends ApiException {
  /// {@macro unauthorized_exception}
  const UnauthorizedException(super.error);

  @override
  String toString() => '[UnauthorizedException] $error';
}

/// {@template forbidden_exception}
/// 403 Forbidden.
/// {@endtemplate}
class ForbiddenException extends ApiException {
  /// {@macro forbidden_exception}
  const ForbiddenException(super.error);

  @override
  String toString() => '[ForbiddenException] $error';
}

/// {@template internal_server_error_exception}
/// 500 Internal Server Error.
/// {@endtemplate}
class InternalServerErrorException extends ApiException {
  /// {@macro internal_server_error_exception}
  const InternalServerErrorException(super.error);

  @override
  String toString() => '[InternalServerErrorException] $error';
}

/// {@template not_found_exception}
/// 404 Not Found.
/// {@endtemplate}
class NotFoundException extends ApiException {
  /// {@macro not_found_exception}
  const NotFoundException(super.error);

  @override
  String toString() => '[NotFoundException] $error';
}

/// {@template deserialization_exception}
/// Exception thrown when the response body is empty.
/// {@endtemplate}
class DeserializationException extends ApiException {
  /// Exception thrown when the response body is empty.
  const DeserializationException.emptyResponseBody()
      : super('Empty response body');

  @override
  String toString() => '[DeserializationException] $error';
}
