import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/favorites/[id].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSwiftifyDataSource extends Mock implements SwiftifyDataSource {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('favorites by id', () {
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

    group('DELETE /favorites/[id] ', () {
      test('delete a favorite album and respond with a 204', () async {
        when(
          () => dataSource.deleteFavoriteAlbum(
            albumId: any(named: 'albumId'),
          ),
        ).thenAnswer((_) async {});
        when(() => request.method).thenReturn(HttpMethod.delete);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.noContent));
        verify(() => dataSource.deleteFavoriteAlbum(albumId: '1')).called(1);
      });

      test('respond with a 500 when an exception is thrown', () async {
        when(
          () => dataSource.deleteFavoriteAlbum(
            albumId: any(named: 'albumId'),
          ),
        ).thenThrow(Exception());
        when(() => request.method).thenReturn(HttpMethod.delete);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.internalServerError));
        verify(() => dataSource.deleteFavoriteAlbum(albumId: '1')).called(1);
      });
    });

    group('responds with a 405', () {
      test('when method is HEAD', () async {
        when(() => request.method).thenReturn(HttpMethod.head);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is OPTIONS', () async {
        when(() => request.method).thenReturn(HttpMethod.options);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is PATCH', () async {
        when(() => request.method).thenReturn(HttpMethod.patch);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is PUT', () async {
        when(() => request.method).thenReturn(HttpMethod.put);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
      test('when method is GET', () async {
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

      test('when method is POST', () async {
        when(() => request.method).thenReturn(HttpMethod.post);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    });
  });
}
