import 'package:api_client/api_client.dart';
import 'package:file_database/file_database.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

/// {@template swiftify_data_repository}
/// A package to request data to the data providers.
/// {@endtemplate}
class SwiftifyDataRepository implements SwiftifyDataSource {
  /// {@macro swiftify_data_repository}
  SwiftifyDataRepository({
    ApiClient? apiClient,
    FileDatabase? fileDatabase,
  })  : _apiClient = apiClient ??
            ApiClient(
              baseUrl: 'https://taylor-swift-api.sarbo.workers.dev',
            ),
        _fileDatabase = fileDatabase ?? const FileDatabase();

  final ApiClient _apiClient;
  final FileDatabase _fileDatabase;

  @override
  Future<List<Album>> getAlbums() async {
    final responseBody = await _apiClient.get<List<dynamic>>('albums');
    final extraAlbumData = _fileDatabase.readFile<List<dynamic>>(
      path: 'assets/extra_album_data.json',
    );

    final updatedAlbum = List<dynamic>.from(responseBody)
        .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
        .toList();

    if (extraAlbumData != null) {
      for (final extraAlbum in extraAlbumData) {
        final extraAlbumDataId =
            ((extraAlbum as Map<String, dynamic>)['album_id']) as int;

        for (final album in updatedAlbum) {
          if (album.albumId == extraAlbumDataId) {
            updatedAlbum[updatedAlbum.indexOf(album)] = album.copyWith(
              coverAlbum: extraAlbum['cover_album'] as String,
            );
          }
        }
      }
    }

    return updatedAlbum..sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  }

  @override
  Future<List<Song>> getSongsByAlbum({required String albumId}) async {
    final responseBody = await _apiClient.get<List<dynamic>>('albums/$albumId');
    final extraSongData = _fileDatabase.readFile<List<dynamic>>(
      path: 'assets/extra_song_data.json',
    );

    final songs = responseBody
        .map((songJson) => Song.fromJson(songJson as Map<String, dynamic>))
        .toList();

    // Add lyrics to each song.
    final updatedSongs = await Future.wait(
      songs.map((song) async {
        final lyrics = await getLyricsBySong(songId: song.songId.toString());
        return song.copyWith(lyrics: lyrics, albumId: int.parse(albumId));
      }).toList(),
    );

    // Add extra data to each song
    if (extraSongData != null) {
      for (final extraSong in extraSongData) {
        final extraSongDataId =
            ((extraSong as Map<String, dynamic>)['song_id']) as int;

        final genres = (extraSong['genres'] as List<dynamic>)
            .map((e) => e as String)
            .toList();

        for (final song in updatedSongs) {
          if (song.songId == extraSongDataId) {
            updatedSongs[updatedSongs.indexOf(song)] = song.copyWith(
              duration: extraSong['duration'] as String,
              genres: genres,
            );
          }
        }
      }
    }

    return updatedSongs;
  }

  @override
  Future<String> getLyricsBySong({required String songId}) async {
    try {
      final data = await _apiClient.get<Map<String, dynamic>>('lyrics/$songId');
      return data['lyrics'] as String;
    } catch (e) {
      return '';
    }
  }

  @override
  List<Album> getFavoriteAlbums() {
    final favorites =
        _fileDatabase.readFile<List<dynamic>>(path: 'assets/favorites.json');

    if (favorites == null) return <Album>[];

    return favorites
        .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
        .toList();
  }

  @override
  void addFavoriteAlbums({required Album album}) {
    const path = 'assets/favorites.json';
    final favorites = _fileDatabase.readFile<List<dynamic>>(path: path);

    if (favorites == null) {
      _fileDatabase
        ..createFileIfNotExists(path: path)
        ..writeFile<List<dynamic>>(path: path, content: [album.toJson()]);
    } else {
      final updatedFavorites = List<Map<String, dynamic>>.from(favorites);
      final albumIndex = updatedFavorites
          .indexWhere((element) => element['album_id'] == album.albumId);

      /// If the album is not found, it will be added to the local file.
      if (albumIndex == -1) {
        updatedFavorites.add(album.toJson());
      } else {
        /// If the album is found, it will throw an exception.
        throw Exception(
          'Album already exists in the favorites file',
        );
      }

      _fileDatabase.writeFile<List<dynamic>>(
        path: path,
        content: updatedFavorites,
      );
    }
  }

  @override
  void deleteFavoriteAlbum({required String albumId}) {
    const path = 'assets/favorites.json';

    final favorites = _fileDatabase.readFile<List<dynamic>>(path: path);

    if (favorites == null) {
      throw Exception('File favorites.json does not exist');
    }

    final updatedFavorites = List<Map<String, dynamic>>.from(favorites);
    final albumIndex = updatedFavorites
        .indexWhere((element) => element['album_id'] == int.tryParse(albumId));

    if (albumIndex == -1) {
      throw Exception(
        'Album does not exist in the favorites file',
      );
    }

    updatedFavorites.removeAt(albumIndex);
    _fileDatabase.writeFile<List<dynamic>>(
      path: path,
      content: updatedFavorites,
    );

    // if the file is empty, delete the file
    if (updatedFavorites.isEmpty) {
      _fileDatabase.deleteFile(path: path);
    }
  }
}
