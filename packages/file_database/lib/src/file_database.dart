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
      return jsonDecode(File(path).readAsStringSync()) as T?;
    } catch (e, st) {
      Error.throwWithStackTrace(Exception(e), st);
    }
  }
}
