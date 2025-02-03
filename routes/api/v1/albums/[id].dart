import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String albumId) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, albumId: albumId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(
  RequestContext context, {
  required String albumId,
}) async {
  try {
    final dataSource = context.read<SwiftifyDataSource>();
    final songs = await dataSource.getSongsByAlbum(albumId: albumId);

    return Response.json(body: songs);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}
