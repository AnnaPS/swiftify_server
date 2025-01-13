import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
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
  final dataSource = context.read<SwiftifyDataSource>();
  final songs = await dataSource.getSongsByAlbum(albumId: albumId);

  final songsJson = songs.map((song) => song.toJson()).toList();

  return Response.json(body: songsJson);
}
