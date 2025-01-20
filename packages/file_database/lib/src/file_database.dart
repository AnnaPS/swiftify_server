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
  /// If the file is not valid, it throws an exception.
  T? readFile<T>({required String path, File? file}) {
    final fileToRead = file ?? File(path);
    if (fileToRead.existsSync()) {
      return jsonDecode(fileToRead.readAsStringSync()) as T?;
    }
    return null;
  }

  /// Write the content to the file.
  /// If the file does not exist, it creates a new file.
  /// If the file is not valid, it throws an exception.
  void writeFile<T>({required String path, required T content, File? file}) {
    (file ?? File(path)).writeAsStringSync(jsonEncode(content));
  }

  /// Create a new file if the file does not exist.
  void createFileIfNotExists({required String path, File? file}) {
    final fileToCreate = file ?? File(path);
    if (!fileToCreate.existsSync()) {
      fileToCreate.createSync();
    }
  }

  /// Delete the file.
  void deleteFile({required String path, File? file}) {
    final fileToDelete = file ?? File(path);
    if (fileToDelete.existsSync()) {
      fileToDelete.deleteSync();
    }
  }
}
