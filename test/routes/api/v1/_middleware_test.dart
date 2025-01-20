import 'package:dart_frog/dart_frog.dart';
import 'package:file_database/file_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

import '../../../../routes/api/v1/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockSwiftifyDataRepository extends Mock
    implements SwiftifyDataRepository {}

void main() {
  group('middleware', () {
    late SwiftifyDataRepository swiftifyDataRepository;

    setUp(() {
      swiftifyDataRepository = _MockSwiftifyDataRepository();
    });

    test('provides SwiftifyDataSource and FileDatabase', () async {
      final handler = middleware((_) => Response());
      final request = Request.get(Uri.parse('http://localhost/'));
      final context = _MockRequestContext();

      when(() => context.request).thenReturn(request);
      when(() => context.provide<SwiftifyDataSource>(any()))
          .thenReturn(context);
      when(() => context.provide<FileDatabase>(any())).thenReturn(context);

      when(() => context.read<SwiftifyDataRepository>())
          .thenReturn(swiftifyDataRepository);

      await handler(context);

      final swiftify =
          verify(() => context.provide<SwiftifyDataSource>(captureAny()))
              .captured
              .single as SwiftifyDataSource Function();

      expect(swiftify(), isA<SwiftifyDataSource>());
    });
  });
}
