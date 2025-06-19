import 'package:flutter/material.dart';
import './app_config.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

abstract class AppConfigViewModel extends State<AppConfig> {
  Locale selectedLocale = I18n.instance.locale;

  void changeLanguage(Locale locale) {
    setState(() {
      selectedLocale = locale;
      I18n.load(locale);
    });
  }
}
