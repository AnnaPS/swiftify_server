import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Song', () {
    const song = Song(
      albumId: 1,
      songId: 1,
      title: 'title',
      lyrics: 'lyrics',
    );

    const song2 = Song(
      albumId: 2,
      songId: 2,
      title: 'title',
      lyrics: 'lyrics',
    );

    test('supports value comparisons', () {
      expect(song, equals(song));
      expect(song, isNot(equals(song2)));
    });

    test('fromJson', () {
      final json = <String, dynamic>{
        'title': 'title',
        'lyrics': 'lyrics',
        'album_id': 1,
      };

      final song = Song.fromJson(json);

      expect(song, equals(song));
    });

    test('toJson', () {
      final json = <String, dynamic>{
        'title': 'title',
        'lyrics': 'lyrics',
        'album_id': 1,
        'song_id': 1,
      };

      expect(song.toJson(), json);
    });

    group('copyWith', () {
      test('returns updated song', () {
        final copiedSong = song.copyWith(
          albumId: 2,
          songId: 2,
          title: 'title',
          lyrics: 'lyrics',
        );

        expect(copiedSong.albumId, equals(2));
        expect(song.songId, equals(1));
      });

      test('returns the same object', () {
        final copiedSong = song.copyWith();

        expect(copiedSong, equals(song));
      });
    });
  });
}
