import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/favorites/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSwiftifyDataSource extends Mock implements SwiftifyDataSource {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('favorites', () {
    late RequestContext context;
    late Request request;
    late Uri uri;
    late SwiftifyDataSource dataSource;

    const favorites = [
      Album(
        albumId: 1,
        title: 'Album 1',
        releaseDate: '2021-01-01',
        coverAlbum: 'https://example.com',
      ),
    ];

    setUp(() {
      context = _MockRequestContext();
      request = _MockRequest();
      uri = _MockUri();
      dataSource = _MockSwiftifyDataSource();

      when(() => context.read<SwiftifyDataSource>()).thenReturn(dataSource);
      when(() => context.request).thenReturn(request);
      when(() => request.uri).thenReturn(uri);
      when(() => uri.queryParameters).thenReturn({});
    });

    setUpAll(() {
      registerFallbackValue(favorites);
    });

    group('GET /favorites ', () {
      test('returns a list of favorite albums and responds with a 200',
          () async {
        when(() => dataSource.getFavoriteAlbums()).thenReturn(favorites);
        when(() => request.method).thenReturn(HttpMethod.get);
        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          response.json(),
          completion(
            equals(
              favorites.map((album) => album.toJson()).toList(),
            ),
          ),
        );

        verify(() => dataSource.getFavoriteAlbums()).called(1);
      });

      test(
          'return a HttpStatus.internalServerError when '
          'response.json throws an error.', () async {
        when(() => dataSource.getAlbums()).thenThrow(Exception());
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });

    group('POST ', () {
      test('adds a favorite album and responds with a 201', () async {
        const album = Album(
          albumId: 2,
          title: 'Album 2',
          releaseDate: '2021-01-01',
          coverAlbum: 'https://example.com',
        );

        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer((_) async => album.toJson());

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.created));
        verify(() => dataSource.addFavoriteAlbums(album: album)).called(1);
      });

      test('responds with a 500 when an error occurs', () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenThrow(Exception());

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });

    group('responds with a 405', () {
      test('when method is DELETE', () async {
        when(() => request.method).thenReturn(HttpMethod.delete);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is HEAD', () async {
        when(() => request.method).thenReturn(HttpMethod.head);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is OPTIONS', () async {
        when(() => request.method).thenReturn(HttpMethod.options);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is PATCH', () async {
        when(() => request.method).thenReturn(HttpMethod.patch);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is PUT', () async {
        when(() => request.method).thenReturn(HttpMethod.put);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    });
  });
}
