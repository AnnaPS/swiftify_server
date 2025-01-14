import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements HttpClient {}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('ApiClient', () {
    late ApiClient apiClient;
    late _MockHttpClient httpClient;
    late _MockHttpClientRequest request;
    late _MockHttpClientResponse response;

    setUp(() {
      httpClient = _MockHttpClient();
      request = _MockHttpClientRequest();
      response = _MockHttpClientResponse();
      apiClient = ApiClient(httpClient: httpClient);
    });

    test('can be instantiated', () {
      expect(apiClient, isNotNull);
    });

    test('can be instantiated without an http client', () {
      expect(
        ApiClient.new,
        returnsNormally,
      );
    });

    group('get', () {
      test('returns a Map<String, dynamic> when status code is 200', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(200);
        when(() => response.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value('{"key": "value"}'),
        );

        final result = await apiClient.get<Map<String, dynamic>>('');
        expect(result, {'key': 'value'});
      });
    });

    group('handleHttpError', () {
      test('throws NetworkException', () {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(1);
        when(() => response.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value(''),
        );

        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<NetworkException>()),
        );
      });

      test(
          'expected BadRequestException '
          'on 400 response', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(400);

        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<BadRequestException>()),
        );
      });

      test(
          'expected UnauthorizedException '
          'on 401 response', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(401);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test(
          'expected ForbiddenException '
          'on 403 response', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(403);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<ForbiddenException>()),
        );
      });

      test(
          'expected NotFoundException '
          'on 404 response', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(404);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<NotFoundException>()),
        );
      });

      test(
          'expected InternalServerErrorException '
          'on 500 response', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(500);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<InternalServerErrorException>()),
        );
      });
    });
  });
}
