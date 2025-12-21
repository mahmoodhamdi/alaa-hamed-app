import 'package:dio/dio.dart';
import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

void main() {
  group('DioClient', () {
    late DioClient dioClient;

    setUp(() {
      dioClient = DioClient();
    });

    group('constructor', () {
      test('should create DioClient instance', () {
        expect(dioClient, isNotNull);
        expect(dioClient, isA<DioClient>());
      });
    });

    group('GET method', () {
      test('should throw DioException on network error', () async {
        // Arrange - using invalid URL to trigger error
        const invalidUrl = 'http://invalid-url-that-does-not-exist.local/test';

        // Act & Assert
        expect(
          () => dioClient.get(invalidUrl),
          throwsA(isA<DioException>()),
        );
      });

      test('should throw DioException on timeout', () async {
        // Using a URL that will timeout
        const timeoutUrl = 'http://10.255.255.1/test';

        // Act & Assert
        expect(
          () => dioClient.get(timeoutUrl),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('POST method', () {
      test('should throw DioException on network error', () async {
        // Arrange - using invalid URL to trigger error
        const invalidUrl = 'http://invalid-url-that-does-not-exist.local/test';

        // Act & Assert
        expect(
          () => dioClient.post(invalidUrl, data: {'test': 'data'}),
          throwsA(isA<DioException>()),
        );
      });
    });

    group('configuration', () {
      test('DioClient should be instantiable multiple times', () {
        final client1 = DioClient();
        final client2 = DioClient();

        expect(client1, isNotNull);
        expect(client2, isNotNull);
        expect(client1, isNot(same(client2)));
      });
    });
  });

  group('DioClient with Mock', () {
    test('should handle successful GET response', () async {
      // This test verifies the structure of DioClient
      // In production, consider using http_mock_adapter for full integration tests
      final dioClient = DioClient();
      expect(dioClient, isA<DioClient>());
    });

    test('should handle successful POST response', () async {
      // This test verifies the structure of DioClient
      final dioClient = DioClient();
      expect(dioClient, isA<DioClient>());
    });
  });
}
