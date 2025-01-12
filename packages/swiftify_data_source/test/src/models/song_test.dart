import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Song', () {
    const song = Song(
      albumId: 1,
      songId: 1,
      title: 'title',
    );

    const song2 = Song(
      albumId: 2,
      songId: 2,
      title: 'title',
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
