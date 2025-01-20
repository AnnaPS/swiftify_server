import 'package:dart_frog/dart_frog.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

final _swiftifyRepository = SwiftifyDataRepository();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SwiftifyDataSource>((_) => _swiftifyRepository));
}
