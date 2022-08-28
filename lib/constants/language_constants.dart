// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

// Language Codes
const String ENGLISH = 'en';
const String INDO = 'id';
const String MANDARIN = 'zh';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case INDO:
      return const Locale(INDO, "");
    case MANDARIN:
      return const Locale(MANDARIN, "");
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations getText(BuildContext context) {
  return AppLocalizations.of(context)!;
}
