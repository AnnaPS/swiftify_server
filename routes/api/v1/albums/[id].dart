import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String albumId) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, albumId: albumId);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, {required String albumId}) async {
  try {
    final dataSource = context.read<SwiftifyDataSource>();
    final fileDatabase = context.read<FileDatabase>();

    final extraSongData = fileDatabase.readFile<List<dynamic>>(
      path: 'assets/extra_song_data.json',
    );
    final songs = await dataSource.getSongsByAlbum(albumId: albumId);

    final updatedSongData = List<Song>.from(songs);

    if (extraSongData != null) {
      for (final extraSong in extraSongData) {
        final extraSongDataId =
            ((extraSong as Map<String, dynamic>)['song_id']) as int;

        final genres = (extraSong['genres'] as List<dynamic>)
            .map((e) => e as String)
            .toList();

        for (final song in updatedSongData) {
          if (song.songId == extraSongDataId) {
            updatedSongData[updatedSongData.indexOf(song)] = song.copyWith(
              duration: extraSong['duration'] as String,
              genres: genres,
            );
          }
        }
      }
    }

    final songsJson = updatedSongData.map((song) => song.toJson()).toList();

    return Response.json(body: songsJson);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}
