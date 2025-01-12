import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:swiftify_repository/swiftify_repository.dart';

final _swiftifyRepository = SwiftifyRepository();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SwiftifyDataSource>((_) => _swiftifyRepository));
}
