// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:file_database/file_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFile extends Mock implements File {}

void main() {
  group('FileDatabase', () {
    late FileDatabase fileDatabase;
    late _MockFile file;

    setUp(() {
      fileDatabase = FileDatabase();
      file = _MockFile();
    });

    group('readFile', () {
      test('should return parsed data from a valid JSON file', () {
        const jsonData = '{"name": "Taylor", "age": 33}';
        when(() => file.readAsStringSync()).thenReturn(jsonData);

        final result = fileDatabase.readFile<Map<String, dynamic>>(
          path: 'test/src/fake_test_data.json',
        );

        expect(result, isA<Map<String, dynamic>>());
        expect(result?['name'], 'Taylor');
        expect(result?['age'], 33);
      });

      test('should throw an exception when the file does not exist', () {
        when(() => file.readAsStringSync()).thenThrow(Exception());

        expect(
          () => fileDatabase.readFile<Map<String, dynamic>>(path: 'any_path'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
