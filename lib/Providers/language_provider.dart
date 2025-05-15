import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Map of language codes to display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
  };

  // Map of language codes to API language names
  static const Map<String, String> _apiLanguageNames = {
    'en': 'english',
    'hi': 'hindi',
    'mr': 'marathi',
  };

  Locale get locale => _locale;
  Map<String, String> _localizedStrings = {};

  Map<String, String> get localizedStrings => _localizedStrings;

  String getCurrentLanguageName() {
    return languageNames[_locale.languageCode] ?? 'English';
  }

  Future<void> loadLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    try {
      // First attempt to fetch from the backend API
      final response = await http.get(
        Uri.parse('https://agro-back-end.vercel.app/language/getlangdata'),
      ).timeout(Duration(seconds: 10)); // Add timeout to prevent hanging

      if (response.statusCode == 200) {
        List<dynamic> languagesData = json.decode(response.body);
        
        // Find the language object that matches our language code
        String apiLanguageName = _apiLanguageNames[languageCode] ?? 'english';
        Map<String, dynamic>? languageData;
        
        for (var langObj in languagesData) {
          if (langObj['language'] == apiLanguageName) {
            languageData = Map<String, dynamic>.from(langObj);
            break;
          }
        }
        
        if (languageData != null) {
          // Remove _id and language fields as they're not translations
          languageData.remove('_id');
          languageData.remove('language');
          
          // Convert to string-string map for translations
          _localizedStrings = languageData.map((key, value) => 
            MapEntry(key, value?.toString() ?? key));
            
          print('Language data loaded from API successfully for ${apiLanguageName}');
        } else {
          print('Language not found in API response. Falling back to local files.');
          await _loadFromLocalAssets(languageCode);
        }
      } else {
        // If API fails, fall back to local files
        print('API request failed with status: ${response.statusCode}. Falling back to local files.');
        await _loadFromLocalAssets(languageCode);
      }
    } catch (e) {
      // If there's any error (network, timeout, etc.), fall back to local files
      print('Error loading language from API: $e. Falling back to local files.');
      await _loadFromLocalAssets(languageCode);
    }
    notifyListeners();
  }

  // Helper method to load language from local assets
  Future<void> _loadFromLocalAssets(String languageCode) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/l10n/$languageCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      print('Error loading language from local assets: $e');
      // If the requested language file doesn't exist, fall back to English
      if (languageCode != 'en') {
        _locale = Locale('en');
        String jsonString = await rootBundle.loadString('assets/l10n/en.json');
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings =
            jsonMap.map((key, value) => MapEntry(key, value.toString()));
      }
    }
  }
}
