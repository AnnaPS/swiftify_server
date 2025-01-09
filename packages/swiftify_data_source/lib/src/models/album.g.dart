// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      title: json['title'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      id: $enumDecodeNullable(_$AlbumIdEnumEnumMap, json['id']) ??
          AlbumIdEnum.taylorSwift,
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
