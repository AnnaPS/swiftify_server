import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/albums/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSwiftifyDataSource extends Mock implements SwiftifyDataSource {}

class _MockFileDatabase extends Mock implements FileDatabase {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('GET /albums', () {
    late RequestContext context;
    late Request request;
    late Uri uri;
    late SwiftifyDataSource dataSource;
    late FileDatabase fileDatabase;

    const albums = [
      Album(
        albumId: 1,
        title: 'Album 1',
        releaseDate: '2021-01-01',
      ),
    ];

    const albumsExtraData = [
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
      fileDatabase = _MockFileDatabase();

      when(() => context.read<FileDatabase>()).thenReturn(fileDatabase);
      when(() => context.read<SwiftifyDataSource>()).thenReturn(dataSource);
      when(() => context.request).thenReturn(request);
      when(() => request.uri).thenReturn(uri);
      when(() => uri.queryParameters).thenReturn({});
    });

    setUpAll(() {
      registerFallbackValue(albums);
    });

    group('responds with a 200', () {
      test('returns a list of albums.', () async {
        when(() => dataSource.getAlbums()).thenAnswer((_) async => albums);
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          response.json(),
          completion(
            equals(
              albums.map((album) => album.toJson()).toList(),
            ),
          ),
        );

        verify(() => dataSource.getAlbums()).called(1);
      });

      test('returns a list of albums with updated cover.', () async {
        final extraAlbumData = [
          {
            'album_id': 1,
            'cover_album': 'https://example.com',
          },
        ];

        when(() => dataSource.getAlbums()).thenAnswer((_) async => albums);
        when(
          () => fileDatabase.readFile<List<dynamic>>(
            path: any(named: 'path'),
          ),
        ).thenAnswer((_) => extraAlbumData);
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context);

        expect(
          response.json(),
          completion(
            equals(
              albumsExtraData.map((album) => album.toJson()).toList(),
            ),
          ),
        );
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

      test('when method is POST', () async {
        when(() => request.method).thenReturn(HttpMethod.post);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    });
  });
}
