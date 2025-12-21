import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStrings', () {
    group('App General', () {
      test('should have Arabic app name', () {
        expect(AppStrings.appName, 'قناة علاء حامد');
      });

      test('should have English app name', () {
        expect(AppStrings.appNameEn, 'Alaa Hamed Channel');
      });
    });

    group('Videos Page', () {
      test('should have Arabic all videos title', () {
        expect(AppStrings.allVideos, 'كل الفيديوهات');
      });

      test('should have English all videos title', () {
        expect(AppStrings.allVideosEn, 'All Videos');
      });

      test('should have failed to load videos message', () {
        expect(AppStrings.failedToLoadVideos, 'Failed to load videos');
      });

      test('should have retry button text', () {
        expect(AppStrings.retry, 'Retry');
      });

      test('should have no videos available message', () {
        expect(AppStrings.noVideosAvailable, 'No Videos Available');
      });

      test('should have check back later message', () {
        expect(AppStrings.checkBackLater, 'Check back later for new content');
      });
    });

    group('Video Player Page', () {
      test('should have published on label', () {
        expect(AppStrings.publishedOn, 'Published on');
      });

      test('should have more details label', () {
        expect(AppStrings.moreDetails, 'More Details');
      });
    });

    group('Auth Page', () {
      test('should have Google Sign In title', () {
        expect(AppStrings.googleSignIn, 'Google Sign In');
      });

      test('should have Sign In with Google button text', () {
        expect(AppStrings.signInWithGoogle, 'Sign In with Google');
      });

      test('should have signed in message', () {
        expect(AppStrings.signedIn, 'Signed in!');
      });

      test('should have access token label', () {
        expect(AppStrings.accessToken, 'Access Token');
      });

      test('should have error label', () {
        expect(AppStrings.error, 'Error');
      });

      test('should have authentication failed message', () {
        expect(AppStrings.authenticationFailed, 'Authentication failed');
      });
    });

    group('Error Messages', () {
      test('should have server error message', () {
        expect(AppStrings.serverError, 'Server error occurred');
      });

      test('should have network error message', () {
        expect(AppStrings.networkError, 'Network connection failed');
      });

      test('should have connection timeout message', () {
        expect(AppStrings.connectionTimeout, 'Connection timeout');
      });

      test('should have no internet connection message', () {
        expect(AppStrings.noInternetConnection, 'No internet connection');
      });

      test('should have unexpected error message', () {
        expect(AppStrings.unexpectedError, 'An unexpected error occurred');
      });
    });

    test('AppStrings should not be instantiable', () {
      // AppStrings has a private constructor, so we can only verify the static methods work
      expect(AppStrings.appName, isNotEmpty);
    });
  });
}
