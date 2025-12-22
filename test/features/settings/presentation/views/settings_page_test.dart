import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Developer Info Constants', () {
    test('should have correct Arabic developer name', () {
      expect(AppStrings.developerName, 'محمود حمدي');
    });

    test('should have correct English developer name', () {
      expect(AppStrings.developerNameEn, 'Mahmoud Hamdi');
    });

    test('should have correct GitHub link', () {
      expect(AppStrings.developerGithub, 'https://github.com/mahmoodhamdi');
    });

    test('GitHub link should be a valid URL', () {
      expect(AppStrings.developerGithub, startsWith('https://'));
      expect(AppStrings.developerGithub, contains('github.com'));
    });

    test('developer name should not be empty', () {
      expect(AppStrings.developerName, isNotEmpty);
      expect(AppStrings.developerNameEn, isNotEmpty);
    });
  });

  group('Settings Page Strings', () {
    test('should have settings title defined', () {
      expect(AppStrings.settings, isNotEmpty);
      expect(AppStrings.settingsEn, isNotEmpty);
    });

    test('should have correct Arabic settings value', () {
      expect(AppStrings.settings, 'الإعدادات');
    });

    test('should have correct English settings value', () {
      expect(AppStrings.settingsEn, 'Settings');
    });

    test('should have appearance section strings', () {
      expect(AppStrings.appearance, isNotEmpty);
      expect(AppStrings.appearanceEn, isNotEmpty);
      expect(AppStrings.theme, isNotEmpty);
      expect(AppStrings.themeEn, isNotEmpty);
      expect(AppStrings.language, isNotEmpty);
      expect(AppStrings.languageEn, isNotEmpty);
    });

    test('should have correct Arabic appearance values', () {
      expect(AppStrings.appearance, 'المظهر');
      expect(AppStrings.theme, 'السمة');
      expect(AppStrings.language, 'اللغة');
    });

    test('should have theme mode strings', () {
      expect(AppStrings.themeLight, isNotEmpty);
      expect(AppStrings.themeLightEn, isNotEmpty);
      expect(AppStrings.themeDark, isNotEmpty);
      expect(AppStrings.themeDarkEn, isNotEmpty);
      expect(AppStrings.themeSystem, isNotEmpty);
      expect(AppStrings.themeSystemEn, isNotEmpty);
    });

    test('should have correct Arabic theme values', () {
      expect(AppStrings.themeLight, 'فاتح');
      expect(AppStrings.themeDark, 'داكن');
      expect(AppStrings.themeSystem, 'تلقائي');
    });

    test('should have notifications section strings', () {
      expect(AppStrings.notifications, isNotEmpty);
      expect(AppStrings.notificationsEn, isNotEmpty);
      expect(AppStrings.enableNotifications, isNotEmpty);
      expect(AppStrings.enableNotificationsEn, isNotEmpty);
      expect(AppStrings.notificationsDescription, isNotEmpty);
      expect(AppStrings.notificationsDescriptionEn, isNotEmpty);
    });

    test('should have video settings section strings', () {
      expect(AppStrings.videoSettings, isNotEmpty);
      expect(AppStrings.videoSettingsEn, isNotEmpty);
      expect(AppStrings.videoQuality, isNotEmpty);
      expect(AppStrings.videoQualityEn, isNotEmpty);
      expect(AppStrings.autoPlay, isNotEmpty);
      expect(AppStrings.autoPlayEn, isNotEmpty);
      expect(AppStrings.autoPlayDescription, isNotEmpty);
      expect(AppStrings.autoPlayDescriptionEn, isNotEmpty);
    });

    test('should have storage section strings', () {
      expect(AppStrings.storage, isNotEmpty);
      expect(AppStrings.storageEn, isNotEmpty);
      expect(AppStrings.clearCache, isNotEmpty);
      expect(AppStrings.clearCacheEn, isNotEmpty);
      expect(AppStrings.clearCacheDescription, isNotEmpty);
      expect(AppStrings.clearCacheDescriptionEn, isNotEmpty);
    });

    test('should have account section strings', () {
      expect(AppStrings.account, isNotEmpty);
      expect(AppStrings.accountEn, isNotEmpty);
      expect(AppStrings.signOut, isNotEmpty);
      expect(AppStrings.signOutEn, isNotEmpty);
      expect(AppStrings.signOutConfirmation, isNotEmpty);
      expect(AppStrings.signOutConfirmationEn, isNotEmpty);
    });

    test('should have about section strings', () {
      expect(AppStrings.about, isNotEmpty);
      expect(AppStrings.aboutEn, isNotEmpty);
      expect(AppStrings.version, isNotEmpty);
      expect(AppStrings.versionEn, isNotEmpty);
      expect(AppStrings.developer, isNotEmpty);
      expect(AppStrings.developerEn, isNotEmpty);
      expect(AppStrings.contact, isNotEmpty);
      expect(AppStrings.contactEn, isNotEmpty);
    });

    test('should have correct Arabic about values', () {
      expect(AppStrings.about, 'حول التطبيق');
      expect(AppStrings.version, 'الإصدار');
      expect(AppStrings.developer, 'المطور');
      expect(AppStrings.contact, 'تواصل معنا');
    });

    test('should have dialog button strings', () {
      expect(AppStrings.cancel, isNotEmpty);
      expect(AppStrings.cancelEn, isNotEmpty);
      expect(AppStrings.confirm, isNotEmpty);
      expect(AppStrings.confirmEn, isNotEmpty);
    });

    test('should have correct Arabic dialog values', () {
      expect(AppStrings.cancel, 'إلغاء');
      expect(AppStrings.confirm, 'تأكيد');
    });

    test('should have language options', () {
      expect(AppStrings.arabic, isNotEmpty);
      expect(AppStrings.english, isNotEmpty);
    });

    test('should have correct language option values', () {
      expect(AppStrings.arabic, 'العربية');
      expect(AppStrings.english, 'English');
    });
  });
}
