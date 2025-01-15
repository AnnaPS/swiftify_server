// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      title: json['title'] as String? ?? '',
      albumId: (json['album_id'] as num?)?.toInt() ?? 0,
      songId: (json['song_id'] as num?)?.toInt() ?? 0,
      lyrics: json['lyrics'] as String? ?? '',
      duration: json['duration'] as String?,
      genres:
          (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'title': instance.title,
      'album_id': instance.albumId,
      'song_id': instance.songId,
      'duration': instance.duration,
      'genres': instance.genres,
      'lyrics': instance.lyrics,
    };
