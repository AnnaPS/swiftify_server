import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final dataSource = context.read<SwiftifyDataSource>();
    final fileDatabase = context.read<FileDatabase>();

    final albums = await dataSource.getAlbums();

    final extraAlbumData = fileDatabase.readFile<List<dynamic>>(
      path: 'extra_album_data.json',
    );

    final updatedAlbum = List<Album>.from(albums);

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

    final albumsJson = updatedAlbum.map((album) => album.toJson()).toList();

    return Response.json(body: albumsJson);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}
