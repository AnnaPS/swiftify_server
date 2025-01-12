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
    String? baseUrl,
  })  : _httpClient = httpClient ?? HttpClient(),
        _baseUrl = baseUrl ?? 'https://taylor-swift-api.sarbo.workers.dev';

  /// The [HttpClient] used to make requests.
  final HttpClient _httpClient;

  /// Base url for the API
  final String _baseUrl;

  /// Fetches a list of albums from the API
  Future<List<Album>> getAlbums() async {
    final uri = Uri.parse('$_baseUrl/albums');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final data = jsonDecode(responseBody) as List<dynamic>;

      return data
          .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
    } else {
      // TODO(ana): add error handling
      throw Exception('Failed to fetch album data');
    }
  }

  /// Fetches a list of songs by album id from the API.
  /// The [albumId] is the id of the album to fetch songs for.
  Future<List<Song>> getSongsByAlbum({required String albumId}) async {
    final uri = Uri.parse('$_baseUrl/albums/$albumId');
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
        final lyric = await getLyricsBySong(songId: song.songId.toString());

        if (lyric.isNotEmpty) {
          updatedAlbums
              .add(song.copyWith(lyrics: lyric, albumId: int.parse(albumId)));
        }
      }

      return updatedAlbums;
    } else {
      throw Exception('Failed to fetch song data');
    }
  }

  /// Fetches lyrics for a song by song id from the API.
  /// The [songId] is the id of the song to fetch lyrics for.
  Future<String> getLyricsBySong({required String songId}) async {
    final uri = Uri.parse('$_baseUrl/lyrics/$songId');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final result = await response.transform(utf8.decoder).join();
      final data = jsonDecode(result) as Map<String, dynamic>;

      return data['lyrics'] as String;
    } else {
      throw Exception('Failed to fetch lyrics data');
    }
  }
}
