import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
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
    final favorites = dataSource.getFavoriteAlbums();

    return Response.json(body: favorites);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final dataSource = context.read<SwiftifyDataSource>();
    final request = await context.request.json() as Map<String, dynamic>;
    final album = Album.fromJson(request);

    dataSource.addFavoriteAlbums(album: album);

    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return _handleError(e);
  }
}

Response _handleError(Object e) {
  return Response.json(
    body: 'error: $e',
    statusCode: HttpStatus.internalServerError,
  );
}
