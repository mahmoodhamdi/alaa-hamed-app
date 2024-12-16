import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Config {
  static Widget Function(BuildContext, Widget?)? builder = (context, child) {
    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: child!,
    );
  };
  static Size designSize = const Size(360, 690);
  static Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates =
      const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static Iterable<Locale> supportedLocales = const [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];
  static Locale? locale = const Locale('ar');
}
