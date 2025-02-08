import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

final _swiftifyRepository = SwiftifyDataRepository();

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use((handler) {
    return (RequestContext context) async {
      final origin =
          context.request.headers['origin'] ?? 'http://localhost:5173';

      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          shelf.ACCESS_CONTROL_ALLOW_ORIGIN: origin,
        },
      );
    };
  }).use(provider<SwiftifyDataSource>((_) => _swiftifyRepository));
}
