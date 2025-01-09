import 'package:swiftify_data_source/swiftify_data_source.dart';
import 'package:test/test.dart';

void main() {
  group('Album', () {
    final album = Album(
      id: AlbumIdEnum.reputation,
      title: 'Reputation',
      coverImage: 'albumCover',
      releaseDate: DateTime(2021, 1, 12),
    );

    final album2 = Album(
      id: AlbumIdEnum.red,
      title: 'Red',
      coverImage: 'albumCover2',
      releaseDate: DateTime(2021, 1, 13),
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
        'releaseDate': DateTime(2021, 1, 12).toIso8601String(),
      };

      final album = Album.fromJson(json);

      expect(album, equals(album));
    });
  });
}
