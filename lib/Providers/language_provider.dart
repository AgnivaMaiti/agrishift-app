import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;
  Map<String, String> _localizedStrings = {};

  Map<String, String> get localizedStrings => _localizedStrings;

  Future<void> loadLanguage(Locale locale) async {
    _locale = locale;
    String jsonString =
        await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    notifyListeners();
  }
}