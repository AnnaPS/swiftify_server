import 'package:api_client/api_client.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

/// {@template swiftify_data_repository}
/// A package to request data to firestore.
/// {@endtemplate}
class SwiftifyDataRepository implements SwiftifyDataSource {
  /// {@macro swiftify_data_repository}
  SwiftifyDataRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ??
            ApiClient(
              baseUrl: 'https://taylor-swift-api.sarbo.workers.dev',
            );

  final ApiClient _apiClient;

  @override
  Future<List<Album>> getAlbums() async {
    final responseBody = await _apiClient.get<List<dynamic>>('albums');
    return responseBody
        .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  }

  @override
  Future<List<Song>> getSongsByAlbum({required String albumId}) async {
    final responseBody = await _apiClient.get<List<dynamic>>('albums/$albumId');

    final songs = responseBody
        .map((songJson) => Song.fromJson(songJson as Map<String, dynamic>))
        .toList();

    final updatedSongs = await Future.wait(
      songs.map((song) async {
        final lyrics = await getLyricsBySong(songId: song.songId.toString());
        return song.copyWith(lyrics: lyrics, albumId: int.parse(albumId));
      }).toList(),
    );

    return updatedSongs;
  }

  @override
  Future<String> getLyricsBySong({required String songId}) async {
    final data = await _apiClient.get<Map<String, dynamic>>('lyrics/$songId');
    return data['lyrics'] as String;
  }
}
