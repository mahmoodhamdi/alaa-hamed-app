import 'package:eng_alaa_hammed/core/config/config.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/theme/app_theme.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_cubit.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_state.dart';
import 'package:eng_alaa_hammed/features/splash/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Eng Alaa Hammed',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.themeMode,
            locale: state.locale,
            localizationsDelegates: Config.localizationsDelegates,
            supportedLocales: Config.supportedLocales,
            builder: Config.builder,
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
