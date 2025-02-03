import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(
  RequestContext context,
  String albumId,
) async {
  return switch (context.request.method) {
    HttpMethod.delete => _onDelete(context, albumId: albumId),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onDelete(
  RequestContext context, {
  required String albumId,
}) async {
  try {
    context.read<SwiftifyDataSource>().deleteFavoriteAlbum(albumId: albumId);

    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}
