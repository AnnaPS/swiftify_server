import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../../routes/api/v1/albums/[id].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockSwiftifyDataSource extends Mock implements SwiftifyDataSource {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('GET albums/[id]', () {
    late RequestContext context;
    late Request request;
    late Uri uri;
    late SwiftifyDataSource dataSource;

    const songs = [
      Song(
        songId: 1,
        title: 'Song 1',
        albumId: 23,
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
    });
  });
}
