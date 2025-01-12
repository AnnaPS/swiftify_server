// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

/// {@template song}
/// A class representing a song
/// {@endtemplate}
@JsonSerializable(fieldRename: FieldRename.snake)
class Song extends Equatable {
  /// {@macro song}
  const Song({
    this.title = '',
    this.albumId = 0,
    this.songId = 0,
  });

  /// Create a [Song] from a Map<String, dynamic>
  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  /// Convert a [Song] to a Map<String, dynamic>
  Map<String, dynamic> toJson() => _$SongToJson(this);

  /// The title of the song
  final String title;

  /// The album id of the song
  final int albumId;

  /// The id of the song
  final int songId;

  @override
  List<Object?> get props => [
        title,
        albumId,
        songId,
      ];

  Song copyWith({
    String? title,
    int? albumId,
    int? songId,
  }) {
    return Song(
      title: title ?? this.title,
      albumId: albumId ?? this.albumId,
      songId: songId ?? this.songId,
    );
  }
}
