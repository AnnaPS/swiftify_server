import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(
  RequestContext context,
  String albumId,
) async {
  switch (context.request.method) {
    case HttpMethod.delete:
      return _delete(context, albumId: albumId);
    case HttpMethod.get:
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _delete(
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
