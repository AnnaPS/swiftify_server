// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiftify_data_repository/swiftify_data_repository.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('SwiftifyRepository', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('can be instantiated', () {
      expect(SwiftifyDataRepository(), isNotNull);
    });

    test('can be instantiated with an apiClient', () {
      expect(SwiftifyDataRepository(apiClient: apiClient), isNotNull);
    });

    test('getAlbums calls apiClient.getAlbums', () async {
      final repository = SwiftifyDataRepository(apiClient: apiClient);
      when(() => apiClient.getAlbums()).thenAnswer((_) async => []);
      await repository.getAlbums();
      verify(() => apiClient.getAlbums()).called(1);
    });

    test('getSongsByAlbum calls apiClient.getSongsByAlbum', () async {
      final repository = SwiftifyDataRepository(apiClient: apiClient);
      when(() => apiClient.getSongsByAlbum(albumId: any(named: 'albumId')))
          .thenAnswer((_) async => []);
      await repository.getSongsByAlbum(albumId: '1');
      verify(() => apiClient.getSongsByAlbum(albumId: '1')).called(1);
    });

    test('getLyricsBySong calls apiClient.getLyricsBySong', () async {
      final repository = SwiftifyDataRepository(apiClient: apiClient);
      when(() => apiClient.getLyricsBySong(songId: any(named: 'songId')))
          .thenAnswer((_) async => '');
      await repository.getLyricsBySong(songId: '1');
      verify(() => apiClient.getLyricsBySong(songId: '1')).called(1);
    });
  });
}
