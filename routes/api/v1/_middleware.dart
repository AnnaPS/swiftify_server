import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

final _swiftifyRepository = SwiftifyDataRepository();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use((handler) {
    return (RequestContext context) async {
      final response = await handler(context);
      final origin = context.request.headers['origin'] ?? '';

      if (origin.startsWith('http://localhost:')) {
        return response.copyWith(
          headers: {
            ...response.headers,
            shelf.ACCESS_CONTROL_ALLOW_ORIGIN: origin,
            shelf.ACCESS_CONTROL_ALLOW_METHODS:
                'GET, POST, PUT, DELETE, OPTIONS',
            shelf.ACCESS_CONTROL_ALLOW_HEADERS: 'Content-Type, Authorization',
            shelf.ACCESS_CONTROL_ALLOW_CREDENTIALS: 'true',
          },
        );
      }
      return response;
    };
  }).use(provider<SwiftifyDataSource>((_) => _swiftifyRepository));
}
