import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/albums/[id].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSwiftifyDataSource extends Mock implements SwiftifyDataSource {}

class _MockFileDatabase extends Mock implements FileDatabase {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('GET albums/[id]', () {
    late RequestContext context;
    late Request request;
    late Uri uri;
    late SwiftifyDataSource dataSource;
    late FileDatabase fileDatabase;

    const songs = [
      Song(
        songId: 1,
        title: 'Song 1',
        albumId: 23,
      ),
    ];

    const songsWithExtraData = [
      Song(
        songId: 1,
        title: 'Song 1',
        albumId: 23,
        duration: '3:30',
        genres: ['pop', 'rock'],
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
      registerFallbackValue(songs);
    });

    group('respons with a 200', () {
      test('return a list of songs with lyrics.', () async {
        when(() => dataSource.getSongsByAlbum(albumId: any(named: 'albumId')))
            .thenAnswer((_) async => songs);
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context, '23');

        expect(response.statusCode, equals(HttpStatus.ok));
        verify(() => dataSource.getSongsByAlbum(albumId: '23')).called(1);

        expect(
          response.json(),
          completion(
            equals(
              songs.map((song) => song.toJson()).toList(),
            ),
          ),
        );
      });

      test('return a list of songs with duration and generes', () async {
        final extraData = {
          'song_id': 1,
          'duration': '3:30',
          'genres': ['pop', 'rock'],
        };
        when(() => dataSource.getSongsByAlbum(albumId: any(named: 'albumId')))
            .thenAnswer((_) async => songs);

        when(
          () => fileDatabase.readFile<List<dynamic>>(
            path: any(named: 'path'),
          ),
        ).thenAnswer(
          (_) => [extraData],
        );
        when(() => request.method).thenReturn(HttpMethod.get);
        final response = await route.onRequest(context, '23');

        expect(response.statusCode, equals(HttpStatus.ok));

        expect(
          response.json(),
          completion(
            equals(
              songsWithExtraData.map((song) => song.toJson()).toList(),
            ),
          ),
        );

        verify(() => dataSource.getSongsByAlbum(albumId: '23')).called(1);
      });

      test(
          'return a HttpStatus.internalServerError when '
          'response.json throws an error.', () async {
        when(() => dataSource.getSongsByAlbum(albumId: any(named: 'albumId')))
            .thenThrow(Exception());
        when(() => request.method).thenReturn(HttpMethod.get);

        final response = await route.onRequest(context, '23');

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });

    group('responds with a 405', () {
      test('when method is DELETE', () async {
        when(() => request.method).thenReturn(HttpMethod.delete);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });

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

      test('when method is POST', () async {
        when(() => request.method).thenReturn(HttpMethod.post);

        final response = await route.onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    });
  });
}
