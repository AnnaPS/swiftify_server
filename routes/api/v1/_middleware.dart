import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

final _swiftifyRepository = SwiftifyDataRepository();
const _fileDatabase = FileDatabase();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<SwiftifyDataSource>((_) => _swiftifyRepository))
      .use(provider<FileDatabase>((_) => _fileDatabase));
}
