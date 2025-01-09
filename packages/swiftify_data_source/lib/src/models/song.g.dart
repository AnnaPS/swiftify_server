// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      albumId: $enumDecodeNullable(_$AlbumIdEnumEnumMap, json['albumId']) ??
          AlbumIdEnum.taylorSwift,
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      lyrics: json['lyrics'] as String? ?? '',
      trackNumber: (json['trackNumber'] as num?)?.toInt() ?? 0,
      videoUrl: json['videoUrl'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

const _$AlbumIdEnumEnumMap = {
  AlbumIdEnum.taylorSwift: 'taylor_swift',
  AlbumIdEnum.lover: 'lover',
  AlbumIdEnum.red: 'red',
  AlbumIdEnum.fearless: 'fearless',
  AlbumIdEnum.speakNow: 'speak_now',
  AlbumIdEnum.nineteenEightyNine: '1989',
  AlbumIdEnum.reputation: 'reputation',
  AlbumIdEnum.midnights: 'midnights',
  AlbumIdEnum.evermore: 'evermore',
  AlbumIdEnum.folklore: 'folklore',
};
