import 'package:eng_alaa_hammed/core/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageService secureStorageService;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    secureStorageService = SecureStorageService(storage: mockStorage);
  });

  group('SecureStorageService', () {
    group('Access Token', () {
      test('saveAccessToken should write token to storage', () async {
        when(() => mockStorage.write(key: 'access_token', value: 'test_token'))
            .thenAnswer((_) async {});

        await secureStorageService.saveAccessToken('test_token');

        verify(() => mockStorage.write(key: 'access_token', value: 'test_token'))
            .called(1);
      });

      test('getAccessToken should return token from storage', () async {
        when(() => mockStorage.read(key: 'access_token'))
            .thenAnswer((_) async => 'stored_token');

        final result = await secureStorageService.getAccessToken();

        expect(result, 'stored_token');
        verify(() => mockStorage.read(key: 'access_token')).called(1);
      });

      test('getAccessToken should return null when no token stored', () async {
        when(() => mockStorage.read(key: 'access_token'))
            .thenAnswer((_) async => null);

        final result = await secureStorageService.getAccessToken();

        expect(result, null);
      });

      test('hasAccessToken should return true when token exists', () async {
        when(() => mockStorage.read(key: 'access_token'))
            .thenAnswer((_) async => 'valid_token');

        final result = await secureStorageService.hasAccessToken();

        expect(result, true);
      });

      test('hasAccessToken should return false when token is null', () async {
        when(() => mockStorage.read(key: 'access_token'))
            .thenAnswer((_) async => null);

        final result = await secureStorageService.hasAccessToken();

        expect(result, false);
      });

      test('hasAccessToken should return false when token is empty', () async {
        when(() => mockStorage.read(key: 'access_token'))
            .thenAnswer((_) async => '');

        final result = await secureStorageService.hasAccessToken();

        expect(result, false);
      });

      test('deleteAccessToken should remove token from storage', () async {
        when(() => mockStorage.delete(key: 'access_token'))
            .thenAnswer((_) async {});

        await secureStorageService.deleteAccessToken();

        verify(() => mockStorage.delete(key: 'access_token')).called(1);
      });
    });

    group('Refresh Token', () {
      test('saveRefreshToken should write token to storage', () async {
        when(() => mockStorage.write(key: 'refresh_token', value: 'refresh_token'))
            .thenAnswer((_) async {});

        await secureStorageService.saveRefreshToken('refresh_token');

        verify(() => mockStorage.write(key: 'refresh_token', value: 'refresh_token'))
            .called(1);
      });

      test('getRefreshToken should return token from storage', () async {
        when(() => mockStorage.read(key: 'refresh_token'))
            .thenAnswer((_) async => 'stored_refresh_token');

        final result = await secureStorageService.getRefreshToken();

        expect(result, 'stored_refresh_token');
      });

      test('deleteRefreshToken should remove token from storage', () async {
        when(() => mockStorage.delete(key: 'refresh_token'))
            .thenAnswer((_) async {});

        await secureStorageService.deleteRefreshToken();

        verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
      });
    });

    group('User Info', () {
      test('saveUserEmail should write email to storage', () async {
        when(() => mockStorage.write(key: 'user_email', value: 'test@example.com'))
            .thenAnswer((_) async {});

        await secureStorageService.saveUserEmail('test@example.com');

        verify(() => mockStorage.write(key: 'user_email', value: 'test@example.com'))
            .called(1);
      });

      test('getUserEmail should return email from storage', () async {
        when(() => mockStorage.read(key: 'user_email'))
            .thenAnswer((_) async => 'user@example.com');

        final result = await secureStorageService.getUserEmail();

        expect(result, 'user@example.com');
      });

      test('saveUserName should write name to storage', () async {
        when(() => mockStorage.write(key: 'user_name', value: 'Test User'))
            .thenAnswer((_) async {});

        await secureStorageService.saveUserName('Test User');

        verify(() => mockStorage.write(key: 'user_name', value: 'Test User'))
            .called(1);
      });

      test('getUserName should return name from storage', () async {
        when(() => mockStorage.read(key: 'user_name'))
            .thenAnswer((_) async => 'John Doe');

        final result = await secureStorageService.getUserName();

        expect(result, 'John Doe');
      });
    });

    group('clearAll', () {
      test('should delete all stored data', () async {
        when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

        await secureStorageService.clearAll();

        verify(() => mockStorage.deleteAll()).called(1);
      });
    });

    group('saveAuthData', () {
      test('should save all auth data when all fields provided', () async {
        when(() => mockStorage.write(key: 'access_token', value: 'access_123'))
            .thenAnswer((_) async {});
        when(() => mockStorage.write(key: 'refresh_token', value: 'refresh_456'))
            .thenAnswer((_) async {});
        when(() => mockStorage.write(key: 'user_email', value: 'user@test.com'))
            .thenAnswer((_) async {});
        when(() => mockStorage.write(key: 'user_name', value: 'Test User'))
            .thenAnswer((_) async {});

        await secureStorageService.saveAuthData(
          accessToken: 'access_123',
          refreshToken: 'refresh_456',
          email: 'user@test.com',
          name: 'Test User',
        );

        verify(() => mockStorage.write(key: 'access_token', value: 'access_123'))
            .called(1);
        verify(() => mockStorage.write(key: 'refresh_token', value: 'refresh_456'))
            .called(1);
        verify(() => mockStorage.write(key: 'user_email', value: 'user@test.com'))
            .called(1);
        verify(() => mockStorage.write(key: 'user_name', value: 'Test User'))
            .called(1);
      });

      test('should save only access token when other fields are null', () async {
        when(() => mockStorage.write(key: 'access_token', value: 'access_only'))
            .thenAnswer((_) async {});

        await secureStorageService.saveAuthData(
          accessToken: 'access_only',
        );

        verify(() => mockStorage.write(key: 'access_token', value: 'access_only'))
            .called(1);
      });
    });
  });
}
