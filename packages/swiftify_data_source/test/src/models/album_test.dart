import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Album', () {
    const album = Album(
      albumId: 1,
      title: 'Reputation',
      albumCover: 'albumCover',
      releaseDate: '2017-11-10',
    );

    const album2 = Album(
      albumId: 2,
      title: 'Red',
      albumCover: 'albumCover2',
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
        'coverImage': 'coverImage',
        'releaseDate': '2006-10-24',
      };

      final album = Album.fromJson(json);

      expect(album, equals(album));
    });
  });
}
