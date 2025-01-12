import 'package:api_client/api_client.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

/// {@template swiftify_repository}
/// A package to request data to firestore.
/// {@endtemplate}
class SwiftifyRepository implements SwiftifyDataSource {
  /// {@macro swiftify_repository}
  SwiftifyRepository({
    ApiClient? apiClient,
  }) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  @override
  Future<List<Album>> getAlbums() async => _apiClient.getAlbums();

  @override
  Future<List<Song>> getSongsByAlbum({required String albumId}) async =>
      _apiClient.getSongsByAlbum(albumId: albumId);

  @override
  Future<String> getLyricsBySong({required String songId}) async =>
      _apiClient.getLyricsBySong(songId: songId);
}
