import 'dart:ui';

import 'en_us.dart';
import 'es_es.dart';
import 'pt_br.dart';
import 'translation.dart';
import 'package:flutter/foundation.dart';

class I18n {
  I18n._();
  static final instance = I18n._();

  static Translation strings = PtBr();

  Locale locale = const Locale('pt', 'BR');

  static final localeNotifier = ValueNotifier<Locale>(const Locale('pt', 'BR'));

  static void load(Locale locale) {
    instance.locale = locale;
    localeNotifier.value = locale;

    switch (locale.languageCode) {
      case 'en':
      case 'en-us':
        strings = EnUs();
        break;
      case 'es':
      case 'es-es':
        strings = EsEs();
        break;
      case 'pt':
      case 'pt-br':
      default:
        strings = PtBr();
    }
  }
}
