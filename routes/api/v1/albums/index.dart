import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  try {
    final dataSource = context.read<SwiftifyDataSource>();

    final albums = await dataSource.getAlbums();

    return Response.json(body: albums);
  } catch (e) {
    return Response.json(
      body: 'error: $e',
      statusCode: HttpStatus.internalServerError,
    );
  }
}
