import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State class for settings.
class SettingsState extends Equatable {
  final AppSettings settings;
  final bool isLoading;
  final String? message;

  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = false,
    this.message,
  });

  ThemeMode get themeMode => settings.themeMode;
  String get languageCode => settings.languageCode;
  Locale get locale => Locale(settings.languageCode);
  bool get notificationsEnabled => settings.notificationsEnabled;
  String get videoQuality => settings.videoQuality;
  bool get autoPlayEnabled => settings.autoPlayEnabled;

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoading,
    String? message,
    bool clearMessage = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, message];
}
