// ignore_for_file: prefer_const_constructors
import 'package:file_database/file_database.dart';
import 'package:test/test.dart';

void main() {
  group('FileDatabase', () {
    test('can be instantiated', () {
      expect(FileDatabase(), isNotNull);
    });
  });
}
