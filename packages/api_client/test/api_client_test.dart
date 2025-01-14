import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
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
    // late _MockHttpClientResponse mockSongResponse;
    // late _MockHttpClientResponse mockLyricsResponse;

    setUp(() {
      httpClient = _MockHttpClient();
      request = _MockHttpClientRequest();
      response = _MockHttpClientResponse();
      // mockSongResponse = _MockHttpClientResponse();
      // mockLyricsResponse = _MockHttpClientResponse();
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

    group('getAlbums', () {
      test('getAlbums returns a list of albums', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(200);
        when(() => response.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value(
            jsonEncode(
              [
                {'id': 1, 'title': 'Album 1', 'releaseDate': '2020-01-01'},
                {'id': 2, 'title': 'Album 2', 'releaseDate': '2021-01-01'},
              ],
            ),
          ),
        );

        final albums = await apiClient.getAlbums();

        expect(albums, isA<List<Album>>());
        expect(albums.length, 2);
        expect(albums[0].title, 'Album 1');
        expect(albums[1].title, 'Album 2');
      });
    });

    group('getSongsByAlbum', () {
      test('getSongsByAlbum fetches songs and updates them with lyrics',
          () async {
        final mockSongRequest = _MockHttpClientRequest();
        final mockLyricsRequest = _MockHttpClientRequest();
        final mockSongResponse = _MockHttpClientResponse();
        final mockLyricsResponse = _MockHttpClientResponse();
        when(() => httpClient.getUrl(any())).thenAnswer((invocation) async {
          final uri = invocation.positionalArguments.first as Uri;
          if (uri.path == '/albums/1') {
            return mockSongRequest;
          } else if (uri.path.contains('lyrics')) {
            return mockLyricsRequest;
          }
          throw Exception('Unexpected URL: ${uri.path}');
        });

        when(mockSongRequest.close).thenAnswer((_) async => mockSongResponse);
        when(mockLyricsRequest.close)
            .thenAnswer((_) async => mockLyricsResponse);

        when(() => mockSongResponse.statusCode).thenReturn(200);
        when(() => mockSongResponse.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value(
            jsonEncode([
              {'song_id': 1, 'title': 'Song 1'},
              {'song_id': 2, 'title': 'Song 2'},
            ]),
          ),
        );

        when(() => mockLyricsResponse.statusCode).thenReturn(200);
        when(() => mockLyricsResponse.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value(jsonEncode({'lyrics': 'Sample lyrics'})),
        );

        final songs = await apiClient.getSongsByAlbum(albumId: '1');

        expect(songs, isA<List<Song>>());
        expect(songs.length, 2);

        expect(songs[0].songId, 1);
        expect(songs[0].title, 'Song 1');
        expect(songs[0].lyrics, 'Sample lyrics');
        expect(songs[0].albumId, 1);
      });
    });

    group('getLyricsBySong', () {
      test('returns lyrics', () async {
        when(() => httpClient.getUrl(any())).thenAnswer((_) async => request);
        when(() => request.close()).thenAnswer((_) async => response);
        when(() => response.statusCode).thenReturn(200);
        when(() => response.transform(utf8.decoder)).thenAnswer(
          (_) => Stream.value(jsonEncode({'lyrics': 'Sample lyrics'})),
        );

        final lyrics = await apiClient.getLyricsBySong(songId: '1');

        expect(lyrics, 'Sample lyrics');
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
          apiClient.getAlbums(),
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
