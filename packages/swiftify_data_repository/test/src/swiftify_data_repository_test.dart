// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:file_database/file_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockFileDatabase extends Mock implements FileDatabase {}

void main() {
  group('SwiftifyRepository', () {
    late ApiClient apiClient;
    late SwiftifyDataRepository repository;
    late FileDatabase fileDatabase;

    const newFavorite = Album(
      albumId: 2,
      title: 'Album 2',
      releaseDate: '2020-02-02',
    );

    final album = Album(
      albumId: 1,
      title: 'Album 1',
      releaseDate: '2020-01-01',
    );
    final favoritesResponse = [album.toJson()];

    setUp(() {
      apiClient = _MockApiClient();
      fileDatabase = _MockFileDatabase();
      repository = SwiftifyDataRepository(
        apiClient: apiClient,
        fileDatabase: fileDatabase,
      );
    });

    test('can be instantiated', () {
      expect(SwiftifyDataRepository(), isNotNull);
    });

    test('can be instantiated with an apiClient', () {
      expect(SwiftifyDataRepository(apiClient: apiClient), isNotNull);
    });

    group('getAlbums', () {
      test('returns a list of albums with coverAlbum', () async {
        final response = [
          {'album_id': 1, 'title': 'Album 1', 'releaseDate': '2020-01-01'},
          {'album_id': 2, 'title': 'Album 2', 'releaseDate': '2021-01-01'},
        ];
        when(() => apiClient.get<List<dynamic>>(any()))
            .thenAnswer((_) async => response);

        when(
          () => fileDatabase.readFile<List<dynamic>>(
            path: any(named: 'path'),
          ),
        ).thenReturn([
          {'album_id': 1, 'cover_album': 'Cover 1'},
          {'album_id': 2, 'cover_album': 'Cover 2'},
        ]);

        final albums = await repository.getAlbums();

        verify(() => apiClient.get<List<dynamic>>('albums')).called(1);
        expect(repository.getAlbums(), completion(isA<List<Album>>()));
        expect(albums.first.coverAlbum, equals('Cover 1'));
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

        when(
          () => fileDatabase.readFile<List<dynamic>>(
            path: any(named: 'path'),
          ),
        ).thenReturn([
          {
            'song_id': 1,
            'genres': ['pop', 'rock'],
            'duration': '3:30',
          },
          {
            'song_id': 2,
            'genres': ['pop', 'rock'],
            'duration': '3:30',
          },
        ]);

        final songs = await repository.getSongsByAlbum(albumId: '1');

        expect(songs.first.lyrics, equals('Lyrics'));
        expect(songs.first.genres, equals(['pop', 'rock']));
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

      test('returns an empty string if an error occurs', () async {
        when(() => apiClient.get<Map<String, dynamic>>(any()))
            .thenThrow(Exception());

        await repository.getLyricsBySong(songId: '1');

        verify(() => apiClient.get<Map<String, dynamic>>('lyrics/1')).called(1);
        expect(repository.getLyricsBySong(songId: '1'), completion(equals('')));
      });
    });

    group('getFavoriteAlbums', () {
      test('return a empty list when there are no favorite albums', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(null);

        final albums = repository.getFavoriteAlbums();

        expect(albums, isEmpty);
      });

      test('return a list of favorite albums', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn([
          {'album_id': 1, 'title': 'Album 1', 'releaseDate': '2020-01-01'},
          {'album_id': 2, 'title': 'Album 2', 'releaseDate': '2021-01-01'},
        ]);

        final albums = repository.getFavoriteAlbums();

        expect(albums, isNotEmpty);
        expect(albums.first.albumId, equals(1));
      });
    });

    group('addFavoriteAlbums', () {
      test('add a favorite when it does not exist in the favorites list', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(favoritesResponse);

        when(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async {});

        repository.addFavoriteAlbums(album: newFavorite);

        verify(
          () => fileDatabase.readFile<List<dynamic>>(
            path: any(named: 'path'),
          ),
        ).called(1);
        verify(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).called(1);
      });

      test('throws an exception when the album already exists in the favorites',
          () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(favoritesResponse);

        expect(
          () => repository.addFavoriteAlbums(album: album),
          throwsA(isA<Exception>()),
        );
      });

      test('creates a new file if the file does not exist', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(null);

        when(
          () => fileDatabase.createFileIfNotExists(path: any(named: 'path')),
        ).thenAnswer((_) async {});
        when(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async {});

        repository.addFavoriteAlbums(album: newFavorite);

        verify(
          () => fileDatabase.createFileIfNotExists(path: any(named: 'path')),
        ).called(1);

        verify(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).called(1);
      });
    });
    group('deleteFavoriteAlbum', () {
      test('throws an exception when the file does not exist', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(null);

        expect(
          () => repository.deleteFavoriteAlbum(albumId: '1'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws an exception when the album does not exist in the favorites',
          () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(favoritesResponse);

        expect(
          () => repository.deleteFavoriteAlbum(albumId: '2'),
          throwsA(isA<Exception>()),
        );
      });

      test('delete the album from the favorites list', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn(favoritesResponse);

        when(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async {});

        repository.deleteFavoriteAlbum(albumId: '1');

        verify(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).called(1);
      });

      test('delete the file if the file is empty', () {
        when(
          () => fileDatabase.readFile<List<dynamic>>(path: any(named: 'path')),
        ).thenReturn([album.toJson()]);

        when(
          () => fileDatabase.writeFile<List<dynamic>>(
            path: any(named: 'path'),
            content: any(named: 'content'),
          ),
        ).thenAnswer((_) async {});

        when(
          () => fileDatabase.deleteFile(path: any(named: 'path')),
        ).thenAnswer((_) async {});

        repository.deleteFavoriteAlbum(albumId: '1');

        verify(
          () => fileDatabase.deleteFile(path: any(named: 'path')),
        ).called(1);
      });
    });
  });
}
