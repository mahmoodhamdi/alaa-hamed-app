import 'package:eng_alaa_hammed/core/config/config.dart';
import 'package:eng_alaa_hammed/core/theme/app_theme.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'التطبيق الديني',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // تغيير تلقائي بين الفاتح والداكن
      locale: Config.locale,
      localizationsDelegates: Config.localizationsDelegates,
      supportedLocales: Config.supportedLocales,
      builder: Config.builder,
      home: HomePage(),
    );
  }
}
