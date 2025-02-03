import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDio extends Mock implements Dio {}

class _MockResponse extends Mock implements Response<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('ApiClient', () {
    late ApiClient apiClient;
    late _MockDio dio;
    late _MockResponse response;
    const fakeBaseUrl = 'http://baseUrl';
    const fakeResponseData = {'key': 'value'};

    setUp(() {
      dio = _MockDio();
      response = _MockResponse();
      apiClient = ApiClient(dio: dio);
      when(() => dio.options).thenReturn(
        BaseOptions(baseUrl: fakeBaseUrl),
      );
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
      test('returns data when status code is 200', () async {
        when(() => response.statusCode).thenReturn(200);
        when(() => response.data).thenReturn(fakeResponseData);

        when(
          () => dio.get<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => response);

        final data = await apiClient.get<dynamic>(
          '',
        );
        expect(
          data,
          equals(fakeResponseData),
        );
      });
    });

    group('handleHttpError', () {
      void setUpHttpError(int errorCode) {
        when(
          () => dio.get<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException.badResponse(
            statusCode: errorCode,
            requestOptions: RequestOptions(),
            response: Response(
              statusCode: errorCode,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      }

      test('throws NetworkException', () {
        setUpHttpError(1);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<NetworkException>()),
        );
      });

      test(
          'expected BadRequestException '
          'on 400 response', () async {
        setUpHttpError(400);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<BadRequestException>()),
        );
      });

      test(
          'expected UnauthorizedException '
          'on 401 response', () async {
        setUpHttpError(401);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test(
          'expected ForbiddenException '
          'on 403 response', () async {
        setUpHttpError(403);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<ForbiddenException>()),
        );
      });

      test(
          'expected NotFoundException '
          'on 404 response', () async {
        setUpHttpError(404);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<NotFoundException>()),
        );
      });

      test(
          'expected InternalServerErrorException '
          'on 500 response', () async {
        setUpHttpError(500);
        expect(
          apiClient.get<dynamic>(''),
          throwsA(isA<InternalServerErrorException>()),
        );
      });
    });
  });
}
