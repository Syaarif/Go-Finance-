import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TextSizeOption {
  small(0.9, 'Kecil'),
  medium(1.0, 'Sedang'),
  large(1.15, 'Besar');

  const TextSizeOption(this.scale, this.label);

  final double scale;
  final String label;
}

enum LanguageOption {
  system,
  indonesian,
  english;

  Locale? get locale => switch (this) {
        LanguageOption.system => null,
        LanguageOption.indonesian => const Locale('id', 'ID'),
        LanguageOption.english => const Locale('en', 'US'),
      };
}

class ThemeProvider extends ChangeNotifier {
  static const _preferenceKey = 'gf_theme_mode_v1';
  static const _textSizePreferenceKey = 'gf_text_size_v1';
  static const _languagePreferenceKey = 'gf_language_v1';

  ThemeMode _themeMode = ThemeMode.system;
  TextSizeOption _textSize = TextSizeOption.medium;
  LanguageOption _language = LanguageOption.system;

  ThemeMode get themeMode => _themeMode;
  TextSizeOption get textSize => _textSize;
  LanguageOption get language => _language;
  Locale? get locale => _language.locale;
  double get textScale => _textSize.scale;

  String get themeLabel => labelFor(_themeMode);

  static String labelFor(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
        return 'Mengikuti Sistem';
    }
  }

  static Future<ThemeProvider> load() async {
    final provider = ThemeProvider();
    final preferences = await SharedPreferences.getInstance();
    final savedMode = preferences.getString(_preferenceKey);
    provider._themeMode = switch (savedMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
    provider._textSize = TextSizeOption.values.firstWhere(
      (option) => option.name == preferences.getString(_textSizePreferenceKey),
      orElse: () => TextSizeOption.medium,
    );
    provider._language = LanguageOption.values.firstWhere(
      (option) => option.name == preferences.getString(_languagePreferenceKey),
      orElse: () => LanguageOption.system,
    );
    return provider;
  }

  Future<bool> setThemeMode(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_preferenceKey, mode.name);
    if (!saved) return false;

    _themeMode = mode;
    notifyListeners();
    return true;
  }

  Future<bool> setTextSize(TextSizeOption textSize) async {
    final preferences = await SharedPreferences.getInstance();
    final saved =
        await preferences.setString(_textSizePreferenceKey, textSize.name);
    if (!saved) return false;

    _textSize = textSize;
    notifyListeners();
    return true;
  }

  Future<bool> setLanguage(LanguageOption language) async {
    final preferences = await SharedPreferences.getInstance();
    final saved =
        await preferences.setString(_languagePreferenceKey, language.name);
    if (!saved) return false;

    _language = language;
    notifyListeners();
    return true;
  }
}
