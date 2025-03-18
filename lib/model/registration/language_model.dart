import 'package:flutter/material.dart';

enum ApplicationLanguage {
  english('en', TextDirection.ltr),
  arabic('ar', TextDirection.rtl),
  hebrew('he', TextDirection.rtl);

  final String languageCode;
  final TextDirection textDirection;

  const ApplicationLanguage(this.languageCode, this.textDirection);

  static ApplicationLanguage fromLanguageCode(String? languageCode) {
    return ApplicationLanguage.values.firstWhere(
          (language) => language.languageCode == languageCode,
      orElse: () => ApplicationLanguage.english,
    );
  }
}
