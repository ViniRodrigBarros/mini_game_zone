import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();

  static final AudioManager _instance = AudioManager._();
  static AudioManager get instance => _instance;

  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  String? _currentAudioPath;
  bool _isInitialized = false;

  /// Inicializa o AudioManager
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      _audioPlayer = AudioPlayer();

      // Configura o player para loop
      await _audioPlayer!.setReleaseMode(ReleaseMode.loop);

      // Adiciona listeners para detectar mudanças de estado
      _audioPlayer!.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
        log(
          '🎵 Estado do áudio: ${_isPlaying ? "Tocando" : "Parado"} - $state',
        );
      });

      _isInitialized = true;
      log('🎵 AudioManager inicializado com sucesso');
    } catch (e) {
      log('❌ Erro ao inicializar AudioManager: $e');
      _isInitialized = false;
    }
  }

  /// Inicializa o AudioManager (método público)
  Future<void> initialize() async {
    await _initialize();
  }

  /// Toca um áudio em loop até ser parado
  /// [audioPath] - Caminho do arquivo de áudio (ex: 'assets/audio/background.wav')
  Future<void> playAudioInLoop(String audioPath) async {
    try {
      // Inicializa se necessário
      await _initialize();

      if (!_isInitialized || _audioPlayer == null) {
        log('❌ AudioManager não foi inicializado corretamente');
        return;
      }

      if (_isPlaying && _currentAudioPath == audioPath) {
        // Se já está tocando o mesmo áudio, não faz nada
        log('🎵 Áudio já está tocando: $audioPath');
        return;
      }

      // Para o áudio atual se estiver tocando
      if (_isPlaying) {
        await stopAudio();
      }

      log('🎵 Carregando áudio: $audioPath');

      // Carrega e toca o áudio em loop
      await _audioPlayer!.play(AssetSource(audioPath));

      _isPlaying = true;
      _currentAudioPath = audioPath;

      log('🎵 Tocando áudio em loop: $audioPath');
    } catch (e) {
      log('❌ Erro ao tocar áudio: $e');
      _isPlaying = false;
      _currentAudioPath = null;
    }
  }

  /// Para o áudio que está tocando
  Future<void> stopAudio() async {
    try {
      if (_audioPlayer != null && _isPlaying) {
        await _audioPlayer!.stop();
      }
      _isPlaying = false;
      _currentAudioPath = null;
      log('🔇 Áudio parado');
    } catch (e) {
      log('❌ Erro ao parar áudio: $e');
    }
  }

  /// Pausa o áudio (pode ser retomado)
  Future<void> pauseAudio() async {
    try {
      if (_audioPlayer != null && _isPlaying) {
        await _audioPlayer!.pause();
        log('⏸️ Áudio pausado');
      }
    } catch (e) {
      log('❌ Erro ao pausar áudio: $e');
    }
  }

  /// Retoma o áudio pausado
  Future<void> resumeAudio() async {
    try {
      if (_audioPlayer != null && !_isPlaying && _currentAudioPath != null) {
        await _audioPlayer!.resume();
        log('▶️ Áudio retomado');
      }
    } catch (e) {
      log('❌ Erro ao retomar áudio: $e');
    }
  }

  /// Verifica se há áudio tocando
  bool get isPlaying => _isPlaying;

  /// Retorna o caminho do áudio atual
  String? get currentAudioPath => _currentAudioPath;

  /// Ajusta o volume (0.0 a 1.0)
  Future<void> setVolume(double volume) async {
    try {
      if (_audioPlayer != null) {
        final clampedVolume = volume.clamp(0.0, 1.0);
        await _audioPlayer!.setVolume(clampedVolume);
        log('🔊 Volume ajustado para: ${(clampedVolume * 100).toInt()}%');
      }
    } catch (e) {
      log('❌ Erro ao ajustar volume: $e');
    }
  }

  /// Libera recursos
  Future<void> dispose() async {
    try {
      await stopAudio();
      if (_audioPlayer != null) {
        await _audioPlayer!.dispose();
        _audioPlayer = null;
      }
      _isInitialized = false;
      log('🧹 Recursos de áudio liberados');
    } catch (e) {
      log('❌ Erro ao liberar recursos de áudio: $e');
    }
  }
}
