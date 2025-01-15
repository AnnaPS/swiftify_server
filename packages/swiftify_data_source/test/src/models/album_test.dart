import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Album', () {
    const album = Album(
      albumId: 1,
      title: 'Reputation',
      coverAlbum: 'coverAlbum',
      releaseDate: '2017-11-10',
    );

    const album2 = Album(
      albumId: 2,
      title: 'Red',
      coverAlbum: 'coverAlbum2',
      releaseDate: '2012-10-22',
    );

    test('supports value comparisons', () {
      expect(album, equals(album));
      expect(album, isNot(equals(album2)));
    });

    test('fromJson', () {
      final json = <String, dynamic>{
        'title': 'Taylor Swift',
        'id': 'taylor_swift',
        'cover_album': 'coverAlbum',
        'releaseDate': '2006-10-24',
      };

      final album = Album.fromJson(json);

      expect(album, equals(album));
    });

    test('toJson', () {
      final json = <String, dynamic>{
        'title': 'Reputation',
        'album_id': 1,
        'cover_album': 'coverAlbum',
        'release_date': '2017-11-10',
        'artist_id': 1,
      };

      expect(album.toJson(), equals(json));
    });

    group('copyWith', () {
      test('returns updated album', () {
        final copiedAlbum = album.copyWith(
          albumId: 1,
          title: 'Reputation2',
          coverAlbum: 'coverAlbum',
          releaseDate: '2017-11-10',
          artistId: 1,
        );

        expect(copiedAlbum.albumId, equals(1));
        expect(copiedAlbum.title, equals('Reputation2'));
      });

      test('returns the same object', () {
        final copiedAlbum = album.copyWith();

        expect(copiedAlbum, equals(album));
      });
    });
  });
}
