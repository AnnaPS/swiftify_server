// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('SwiftifyRepository', () {
    late ApiClient apiClient;
    late SwiftifyDataRepository repository;

    setUp(() {
      apiClient = _MockApiClient();
      repository = SwiftifyDataRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(SwiftifyDataRepository(), isNotNull);
    });

    test('can be instantiated with an apiClient', () {
      expect(SwiftifyDataRepository(apiClient: apiClient), isNotNull);
    });

    group('getAlbums', () {
      test('returns a List<Album>>', () async {
        final response = [
          {'id': 1, 'title': 'Album 1', 'releaseDate': '2020-01-01'},
          {'id': 2, 'title': 'Album 2', 'releaseDate': '2021-01-01'},
        ];
        when(() => apiClient.get<List<dynamic>>(any()))
            .thenAnswer((_) async => response);
        await repository.getAlbums();

        verify(() => apiClient.get<List<dynamic>>('albums')).called(1);
        expect(repository.getAlbums(), completion(isA<List<Album>>()));
      });
    });

    group('getSongsByAlbum', () {
      test('returns a list of songs with lyrics', () async {
        final songsResponse = [
          {'song_id': 1, 'title': 'Song 1', 'album_id': 1},
          {'song_id': 2, 'title': 'Song 2', 'album_id': 1},
        ];

        final lyricsResponse = {'lyrics': 'Lyrics'};

        when(() => apiClient.get<List<dynamic>>('albums/1'))
            .thenAnswer((_) async => songsResponse);
        when(() => apiClient.get<Map<String, dynamic>>('lyrics/1'))
            .thenAnswer((_) async => lyricsResponse);
        when(() => apiClient.get<List<dynamic>>(any()))
            .thenAnswer((_) async => songsResponse);
        when(() => apiClient.get<Map<String, dynamic>>(any()))
            .thenAnswer((_) async => lyricsResponse);

        await repository.getSongsByAlbum(albumId: '1');

        verify(() => apiClient.get<List<dynamic>>('albums/1')).called(1);
        verify(() => apiClient.get<Map<String, dynamic>>('lyrics/1')).called(1);
      });
    });

    group('getLyricsBySong', () {
      test('returns the lyrics of a song', () async {
        final response = {'lyrics': 'Lyrics'};
        when(() => apiClient.get<Map<String, dynamic>>(any()))
            .thenAnswer((_) async => response);

        await repository.getLyricsBySong(songId: '1');

        verify(() => apiClient.get<Map<String, dynamic>>('lyrics/1')).called(1);
        expect(response.values.first, equals('Lyrics'));
      });
    });
  });
}
