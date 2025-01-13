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
  Future<List<Album>> getAlbums() async => _apiClient.getAlbums();

  @override
  Future<List<Song>> getSongsByAlbum({required String albumId}) async =>
      _apiClient.getSongsByAlbum(albumId: albumId);

  @override
  Future<String> getLyricsBySong({required String songId}) async =>
      _apiClient.getLyricsBySong(songId: songId);
}
