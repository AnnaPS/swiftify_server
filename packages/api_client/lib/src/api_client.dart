import 'dart:convert';
import 'dart:io';

import 'package:swiftify_data_source/swiftify_data_source.dart';

/// {@template http_client}
/// A package to manage Http calls.
/// {@endtemplate}
// https://taylor-swift-api.sarbo.workers.dev
class ApiClient {
  /// {@macro http_client}
  ApiClient({
    HttpClient? httpClient,
  }) : _httpClient = httpClient ?? HttpClient();

  /// The [HttpClient] used to make requests.
  final HttpClient _httpClient;

  /// Base url for the API
  static const baseUrl = 'https://taylor-swift-api.sarbo.workers.dev';

  /// Fetches a list of albums from the API
  Future<List<Album>> getAlbums() async {
    final uri = Uri.parse('$baseUrl/albums');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody) as List<dynamic>;

      return data
          .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
          .toList();
    } else {
      // TODO(ana): add error handling
      throw Exception('Failed to fetch album data');
    }
  }

  /// Fetches a list of songs by album id from the API.
  /// The [albumId] is the id of the album to fetch songs for.
  Future<List<Song>> getSongsByAlbum({required String albumId}) async {
    final uri = Uri.parse('$baseUrl/albums/$albumId');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody) as List<dynamic>;

      final albums = data
          .map((songJson) => Song.fromJson(songJson as Map<String, dynamic>))
          .toList();

      final updatedAlbums = <Song>[];

      for (final song in albums) {
        updatedAlbums.add(song.copyWith(albumId: int.parse(albumId)));
      }

      return updatedAlbums;
    } else {
      throw Exception('Failed to fetch song data');
    }
  }
}
