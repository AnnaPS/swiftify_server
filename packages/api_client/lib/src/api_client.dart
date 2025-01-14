import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

/// {@template http_client}
/// A package to manage Http calls to the API.
/// {@endtemplate}
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
    final responseBody = await get<List<dynamic>>('albums');
    return responseBody
        .map((albumJson) => Album.fromJson(albumJson as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  }

  /// Fetches a list of songs by album id from the API.
  /// The [albumId] is the id of the album to fetch songs for.
  Future<List<Song>> getSongsByAlbum({required String albumId}) async {
    final responseBody = await get<List<dynamic>>('albums/$albumId');

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

  /// Fetches lyrics for a song by song id from the API.
  /// The [songId] is the id of the song to fetch lyrics for.
  Future<String> getLyricsBySong({required String songId}) async {
    final data = await get<Map<String, dynamic>>('lyrics/$songId');
    return data['lyrics'] as String;
  }

  bool _isSuccessful(int statusCode) => statusCode >= 200 && statusCode < 300;

  Future<T> _handleResponse<T>(
    HttpClientResponse response,
  ) async {
    if (_isSuccessful(response.statusCode)) {
      final result = await response.transform(utf8.decoder).join();
      return jsonDecode(result) as T;
    } else {
      throw _handleHttpError(response.statusCode, response, StackTrace.current);
    }
  }

  /// Handles the statusCode from the API
  /// Note: This is a simplified version of a real-world implementation.
  /// In a real-world scenario, you would have more detailed error handling.
  Exception _handleHttpError(
    int statusCode,
    Object error,
    StackTrace stackTrace,
  ) {
    final exception = switch (statusCode) {
      400 => BadRequestException(error),
      401 => UnauthorizedException(error),
      403 => ForbiddenException(error),
      404 => NotFoundException(error),
      500 => InternalServerErrorException(error),
      _ => NetworkException(error),
    };
    Error.throwWithStackTrace(exception, stackTrace);
  }

  /// GET request to [path].
  /// Returns a [Map] with the response body.
  Future<T> get<T>(String path) async {
    final uri = Uri.parse('$_baseUrl/$path');
    final request = await _httpClient.getUrl(uri);
    final response = await request.close();

    return _handleResponse(response);
  }
}
