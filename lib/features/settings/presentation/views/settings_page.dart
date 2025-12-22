import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_cubit.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Settings page for managing app preferences.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsCubit _settingsCubit;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _settingsCubit = getIt<SettingsCubit>()..loadSettings();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _settingsCubit,
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
            _settingsCubit.clearMessage();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.settings,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildAppearanceSection(context, state),
                      _buildNotificationsSection(context, state),
                      _buildVideoSettingsSection(context, state),
                      _buildStorageSection(context, state),
                      _buildAccountSection(context, state),
                      _buildAboutSection(context),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, SettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.appearance),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              // Theme selector
              ListTile(
                leading: Icon(
                  _getThemeIcon(state.themeMode),
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.theme),
                subtitle: Text(_getThemeDisplayName(state.themeMode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, state.themeMode),
              ),
              const Divider(height: 1, indent: 56),
              // Language selector
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.language),
                subtitle: Text(state.settings.languageDisplayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, state.languageCode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context, SettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.notifications),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SwitchListTile(
            secondary: Icon(
              state.notificationsEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(AppStrings.enableNotifications),
            subtitle: const Text(AppStrings.notificationsDescription),
            value: state.notificationsEnabled,
            onChanged: (value) => _settingsCubit.setNotificationsEnabled(value),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSettingsSection(BuildContext context, SettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.videoSettings),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              // Video quality
              ListTile(
                leading: Icon(
                  Icons.high_quality,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.videoQuality),
                subtitle: Text(_getQualityDisplayName(state.videoQuality)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    _showVideoQualityDialog(context, state.videoQuality),
              ),
              const Divider(height: 1, indent: 56),
              // Auto-play
              SwitchListTile(
                secondary: Icon(
                  Icons.play_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.autoPlay),
                subtitle: const Text(AppStrings.autoPlayDescription),
                value: state.autoPlayEnabled,
                onChanged: (value) => _settingsCubit.setAutoPlayEnabled(value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageSection(BuildContext context, SettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.storage),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(
              Icons.cleaning_services,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(AppStrings.clearCache),
            subtitle: const Text(AppStrings.clearCacheDescription),
            trailing: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: state.isLoading ? null : () => _settingsCubit.clearCache(),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, SettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.account),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              AppStrings.signOut,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _showSignOutDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, AppStrings.about),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.version),
                trailing: Text(
                  _appVersion,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.developer),
                trailing: Text(
                  AppStrings.developerName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: Icon(
                  Icons.email_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.contact),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showContactDialog(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppStrings.themeLight;
      case ThemeMode.dark:
        return AppStrings.themeDark;
      case ThemeMode.system:
        return AppStrings.themeSystem;
    }
  }

  String _getQualityDisplayName(String quality) {
    if (quality == 'auto') {
      return AppStrings.qualityAuto;
    }
    return quality;
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeDisplayName(mode)),
              value: mode,
              groupValue: currentMode,
              onChanged: (value) {
                if (value != null) {
                  _settingsCubit.setThemeMode(value);
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text(AppStrings.arabic),
              value: 'ar',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  _settingsCubit.setLanguage(value);
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text(AppStrings.english),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  _settingsCubit.setLanguage(value);
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoQualityDialog(BuildContext context, String currentQuality) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.videoQuality),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppSettings.videoQualityOptions.map((quality) {
            return RadioListTile<String>(
              title: Text(_getQualityDisplayName(quality)),
              value: quality,
              groupValue: currentQuality,
              onChanged: (value) {
                if (value != null) {
                  _settingsCubit.setVideoQuality(value);
                  Navigator.pop(dialogContext);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.signOut),
        content: const Text(AppStrings.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              Navigator.pop(dialogContext);
              final success = await _settingsCubit.signOut();
              if (success && mounted) {
                navigator.popUntil((route) => route.isFirst);
              }
            },
            child: Text(
              AppStrings.confirm,
              style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.contact),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText('Email: hmdy7486@gmail.com'),
            SizedBox(height: 8),
            SelectableText('Phone: +201019793768'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
        ],
      ),
    );
  }
}
