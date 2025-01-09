import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Song', () {
    const song = Song(
      artist: 'artist',
      albumId: AlbumIdEnum.reputation,
      duration: 1,
      lyrics: 'lyrics',
      title: 'name',
      genres: ['genre'],
      videoUrl: 'videoUrl',
      trackNumber: 1,
    );

    const song2 = Song(
      artist: 'artist2',
      albumId: AlbumIdEnum.folklore,
      duration: 2,
      lyrics: 'lyrics2',
      title: 'name2',
      genres: ['genre2'],
      videoUrl: 'videoUrl2',
      trackNumber: 2,
    );

    test('supports value comparisons', () {
      expect(song, equals(song));
      expect(song, isNot(equals(song2)));
    });

    test('fromJson', () {
      final json = <String, dynamic>{
        'title': 'title',
        'artist': 'artist',
        'duration': 1,
        'lyrics': 'lyrics',
        'albumId': 'reputation',
        'trackNumber': 1,
        'videoUrl': 'videoUrl',
        'genres': ['genre'],
      };

      final song = Song.fromJson(json);

      expect(song, equals(song));
    });
  });
}
