import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './app_config.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'package:mini_game_zone/core/managers/audio_manager.dart.dart';

abstract class AppConfigViewModel extends State<AppConfig> {
  Locale selectedLocale = I18n.instance.locale;
  bool isAudioPlaying = false;
  final _audioManager = Modular.get<AudioManager>();

  @override
  void initState() {
    super.initState();
    // Verifica se o áudio está tocando ao inicializar
    isAudioPlaying = _audioManager.isPlaying;
  }

  void changeLanguage(Locale locale) {
    setState(() {
      selectedLocale = locale;
      I18n.load(locale);
    });
  }

  /// Inicia o áudio de fundo em loop
  Future<void> startBackgroundAudio() async {
    try {
      await _audioManager.playAudioInLoop('audio/background.wav');
      setState(() {
        isAudioPlaying = true;
      });
    } catch (e) {
      log('❌ Erro ao iniciar áudio de fundo: $e');
    }
  }

  /// Para o áudio de fundo
  Future<void> stopBackgroundAudio() async {
    try {
      await _audioManager.stopAudio();
      setState(() {
        isAudioPlaying = false;
      });
    } catch (e) {
      log('❌ Erro ao parar áudio de fundo: $e');
    }
  }

  /// Alterna o estado do áudio (liga/desliga)
  Future<void> toggleBackgroundAudio() async {
    if (isAudioPlaying) {
      await stopBackgroundAudio();
    } else {
      await startBackgroundAudio();
    }
  }
}
