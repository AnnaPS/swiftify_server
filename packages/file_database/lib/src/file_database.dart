import 'dart:convert';
import 'dart:io';

/// {@template file_database}
/// A generic class to manage Files
/// {@endtemplate}
class FileDatabase {
  /// {@macro file_database}
  const FileDatabase();

  /// Read the file and return the content as generic type.
  /// If the file does not exist, it will return null.
  T? readFile<T>({required String path}) {
    try {
      return jsonDecode(File('assets/$path').readAsStringSync()) as T?;
    } catch (e, _) {
      throw Exception('Error reading file');
    }
  }
}

// TODO(ana): add exceptions
