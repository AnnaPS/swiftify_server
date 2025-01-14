import 'package:swiftify_data_source/swiftify_data_source.dart';

/// An interface for managing albums and songs.
abstract class SwiftifyDataSource {
  /// Fetches all albums.
  Future<List<Album>> getAlbums();

  /// Fetches all songs for the given [albumId].
  Future<List<Song>> getSongsByAlbum({required String albumId});

  /// Fetches lyrics for the given [songId].
  Future<String> getLyricsBySong({required String songId});
}
