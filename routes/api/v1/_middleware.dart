import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

final _swiftifyRepository = SwiftifyDataRepository();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'http://localhost:8080/',
            },
          ),
        ),
      )
      .use(provider<SwiftifyDataSource>((_) => _swiftifyRepository));
}
