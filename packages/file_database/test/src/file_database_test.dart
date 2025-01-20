// ignore_for_file: prefer_const_constructors

import 'dart:convert';
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
      test('should return parsed data from a valid JSON file when', () {
        const jsonData = '{"name": "Taylor", "age": 33}';
        when(() => file.readAsStringSync()).thenReturn(jsonData);
        when(() => file.existsSync()).thenReturn(true);

        final result = fileDatabase.readFile<Map<String, dynamic>>(
          path: 'test/src/fake_test_data.json',
          file: file,
        );

        expect(result, isA<Map<String, dynamic>>());
        expect(result?['name'], 'Taylor');
        expect(result?['age'], 33);
      });

      test('should return null if the file does not exist', () {
        when(() => file.existsSync()).thenReturn(false);

        final result = fileDatabase.readFile<Map<String, dynamic>>(
          path: 'test/src/fake_test_data.json',
          file: file,
        );

        expect(result, isNull);
      });

      test('should use the path to create a new file if no file is provided',
          () {
        final realFile = File('test/src/fake_test_data.json');
        const jsonData = '{"name": "Taylor", "age": 33}';

        // Write the JSON data to the real file for the test
        realFile.writeAsStringSync(jsonData);

        final result = fileDatabase.readFile<Map<String, dynamic>>(
          path: 'test/src/fake_test_data.json',
        );

        expect(result, isA<Map<String, dynamic>>());
        expect(result?['name'], 'Taylor');
        expect(result?['age'], 33);

        // Clean up the real file after the test
        realFile.deleteSync();
      });

      test('should return null if the file does not exist', () {
        when(() => file.existsSync()).thenReturn(false);

        final result = fileDatabase.readFile<Map<String, dynamic>>(
          path: 'test/src/fake_test_data.json',
          file: file,
        );

        expect(result, isNull);
      });
    });

    group('writeFile', () {
      test('should write data to a file', () {
        const jsonData = '{"name": "Taylor", "age": 33}';
        when(() => file.writeAsStringSync(jsonEncode(jsonData)))
            .thenAnswer((_) {});

        fileDatabase.writeFile(
          path: 'test/src/fake_test_data.json',
          content: jsonData,
          file: file,
        );

        verify(() => file.writeAsStringSync(jsonEncode(jsonData))).called(1);
      });
    });

    group('createFileIfNotExists', () {
      test('should create a new file if it does not exist', () {
        when(() => file.existsSync()).thenReturn(false);
        when(() => file.createSync()).thenAnswer((_) {});

        fileDatabase.createFileIfNotExists(
          path: 'test/src/fake_test_data.json',
          file: file,
        );

        verify(() => file.existsSync()).called(1);
        verify(() => file.createSync()).called(1);
      });

      test('should not create a new file if it already exists', () {
        when(() => file.existsSync()).thenReturn(true);

        fileDatabase.createFileIfNotExists(
          path: 'test/src/fake_test_data.json',
          file: file,
        );

        verify(() => file.existsSync()).called(1);
        verifyNever(() => file.createSync());
      });

      test('should use the path to create a new file if no file is provided',
          () {
        final realFile = File('test/src/fake_test_data.json');

        fileDatabase.createFileIfNotExists(
          path: 'test/src/fake_test_data.json',
        );

        expect(realFile.existsSync(), isTrue);

        // Clean up the real file after the test
        realFile.deleteSync();
      });
    });
  });
}
