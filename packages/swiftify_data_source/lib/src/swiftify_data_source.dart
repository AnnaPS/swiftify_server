import 'package:swiftify_data_source/swiftify_data_source.dart';

/// An interface for managing albums and songs.
abstract class SwiftifyDataSource {
  /// Fetches all albums.
  Future<List<Album>> getAlbums();

  /// Fetches all songs for the given [albumId].
  Future<List<Song>> getSongsByAlbum({required String albumId});

  /// Fetches lyrics for the given [songId].
  Future<String> getLyricsBySong({required String songId});

  /// Get favorite albums from the local file.
  /// Returns an empty list if no albums are found.
  /// Returns a list of albums if albums are found.
  List<Album> getFavoriteAlbums();

  /// Add a favorite album to the local file.
  /// If the album is not found, it will be added to the local file.
  /// If the album is found, it will be updated in the local file.
  void addFavoriteAlbums({required Album album});

  /// Delete a favorite album from the local file.
  /// The [albumId] is the unique identifier for the album.
  void deleteFavoriteAlbum({required String albumId});
}
