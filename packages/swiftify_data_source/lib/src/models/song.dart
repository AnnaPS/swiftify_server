import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:swiftify_data_source/swiftify_data_source.dart';

part 'song.g.dart';

/// {@template song}
/// A class representing a song
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class Song extends Equatable {
  /// {@macro song}
  const Song({
    this.albumId = AlbumIdEnum.taylorSwift,
    this.title = '',
    this.artist = '',
    this.duration = 0,
    this.lyrics = '',
    this.trackNumber = 0,
    this.videoUrl = '',
    this.genres = const [],
  });

  /// Create a [Song] from a JSON object
  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  /// The title of the song
  final String title;

  /// The artist of the song
  final String artist;

  /// The duration of the song
  final int duration;

  /// The lyrics of the song
  final String lyrics;

  /// The album of the song
  final AlbumIdEnum albumId;

  /// The track number of the song
  final int trackNumber;

  /// The video URL of the song
  final String videoUrl;

  final List<String> genres;

  @override
  List<Object?> get props => [
        title,
        artist,
        duration,
        lyrics,
        albumId,
        trackNumber,
        videoUrl,
        genres,
      ];
}
