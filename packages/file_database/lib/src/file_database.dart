import 'dart:convert';
import 'dart:io';

/// {@template file_database}
/// A generic class to manage Files
/// {@endtemplate}
class FileDatabase {
  /// {@macro file_database}
  const FileDatabase();

  /// Read the file and return the content as generic type.
  /// If the file does not exist, it throws an exception.
  /// If the file is not a valid, it throws an exception.
  T? readFile<T>({required String path}) {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        return null;
      }
      return jsonDecode(file.readAsStringSync()) as T?;
    } catch (e, st) {
      Error.throwWithStackTrace(Exception(e), st);
    }
  }

  /// Write the content to the file.
  /// If the file does not exist, it creates a new file.
  /// If the file is not a valid, it throws an exception.
  void writeFile<T>({required String path, required T content}) {
    try {
      File(path).writeAsStringSync(jsonEncode(content));
    } catch (e, st) {
      Error.throwWithStackTrace(Exception(e), st);
    }
  }

  /// Create a new file if the file does not exist.
  void createFileIfNotExists({required String path}) {
    try {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync();
      }
    } catch (e, st) {
      Error.throwWithStackTrace(Exception(e), st);
    }
  }

  /// Delete the file.
  void deleteFile({required String path}) {
    try {
      final file = File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e, st) {
      Error.throwWithStackTrace(Exception(e), st);
    }
  }
}
