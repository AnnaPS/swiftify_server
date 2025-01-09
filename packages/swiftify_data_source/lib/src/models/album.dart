// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

/// Enum representing the id of the album
enum AlbumIdEnum {
  /// Taylor Swift album
  @JsonValue('taylor_swift')
  taylorSwift,

  /// Lover album
  @JsonValue('lover')
  lover,

  /// Red (Taylor's version) album
  @JsonValue('red')
  red,

  /// Fearless (Taylor's version) album
  @JsonValue('fearless')
  fearless,

  /// Speak Now (Taylor's version) album
  @JsonValue('speak_now')
  speakNow,

  /// Fearless (Taylor's Version) album
  @JsonValue('1989')
  nineteenEightyNine,

  /// Reputation album
  @JsonValue('reputation')
  reputation,

  /// Midnights album
  @JsonValue('midnights')
  midnights,

  /// Evermore album
  @JsonValue('evermore')
  evermore,

  /// Folklore album
  @JsonValue('folklore')
  folklore;

  const AlbumIdEnum();
}

/// {@template album}
/// A class representing an album
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class Album extends Equatable {
  /// {@macro album}
  const Album({
    this.title = '',
    this.coverImage = '',
    this.releaseDate,
    this.id = AlbumIdEnum.taylorSwift,
  });

  /// Converts a [Map<String, dynamic>] to an [Album] object.
  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  /// The album id
  final AlbumIdEnum id;

  /// The title of the album
  final String title;

  /// The album cover image in URL format
  final String coverImage;

  /// The release date of the album
  final DateTime? releaseDate;

  @override
  List<Object?> get props => [
        title,
        coverImage,
        id,
        releaseDate,
      ];
}
