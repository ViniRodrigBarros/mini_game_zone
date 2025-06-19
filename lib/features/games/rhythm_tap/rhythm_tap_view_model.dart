import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

//TODO: adicionar o audio e o score no local storage e corrigir sistema de pontuação
class RhythmTapViewModel extends ChangeNotifier {
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  int combo = 0;
  int maxCombo = 0;
  double gameSpeed = 1.0;
  int level = 1;

  List<RhythmNote> notes = [];
  List<RhythmNote> activeNotes = [];
  Timer? gameTimer;
  Timer? noteTimer;
  int gameTime = 0;
  int maxGameTime = 60; // 60 segundos

  final Random random = Random();

  void startGame() {
    isPlaying = true;
    isGameOver = false;
    score = 0;
    combo = 0;
    maxCombo = 0;
    gameTime = 0;
    level = 1;
    gameSpeed = 1.0;
    notes.clear();
    activeNotes.clear();

    // Timer principal do jogo
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      gameTime++;
      if (gameTime >= maxGameTime) {
        endGame();
        return;
      }

      // Aumentar dificuldade a cada 10 segundos
      if (gameTime % 10 == 0) {
        level++;
        gameSpeed += 0.2;
      }

      notifyListeners();
    });

    // Timer para gerar notas
    noteTimer = Timer.periodic(
      Duration(milliseconds: (2000 / gameSpeed).round()),
      (timer) {
        if (isPlaying) {
          generateNote();
        }
      },
    );

    notifyListeners();
  }

  void generateNote() {
    final note = RhythmNote(
      id: DateTime.now().millisecondsSinceEpoch,
      x: random.nextDouble() * 300 + 30, // Posição X aleatória
      y: -50, // Começa fora da tela
      speed: 2.0 * gameSpeed,
      type: random.nextBool() ? NoteType.normal : NoteType.bonus,
    );

    notes.add(note);
    activeNotes.add(note);
    notifyListeners();
  }

  void tapNote(double x, double y) {
    if (!isPlaying) return;

    // Verificar se há uma nota próxima
    RhythmNote? tappedNote;
    double minDistance = double.infinity;

    for (int i = activeNotes.length - 1; i >= 0; i--) {
      final note = activeNotes[i];
      final distance = sqrt(pow(x - note.x, 2) + pow(y - note.y, 2));

      if (distance < 50 && distance < minDistance) {
        tappedNote = note;
        minDistance = distance;
      }
    }

    if (tappedNote != null) {
      // Calcular precisão
      final targetY = 550.0; // Posição alvo
      final accuracy = (targetY - tappedNote.y).abs();

      int points = 0;

      if (accuracy < 20) {
        points = tappedNote.type == NoteType.bonus ? 30 : 20;
        combo++;
      } else if (accuracy < 50) {
        points = tappedNote.type == NoteType.bonus ? 20 : 15;
        combo++;
      } else if (accuracy < 80) {
        points = tappedNote.type == NoteType.bonus ? 10 : 5;
        combo = 0;
      } else {
        points = 0;
        combo = 0;
      }

      score += points;
      if (combo > maxCombo) maxCombo = combo;

      // Remover nota
      activeNotes.remove(tappedNote);
      notes.remove(tappedNote);

      notifyListeners();
    } else {
      // Miss - quebrar combo
      combo = 0;
      notifyListeners();
    }
  }

  void updateNotes() {
    if (!isPlaying) return;

    for (int i = activeNotes.length - 1; i >= 0; i--) {
      final note = activeNotes[i];
      note.y += note.speed;

      // Remover notas que passaram da tela
      if (note.y > 650) {
        activeNotes.removeAt(i);
        notes.remove(note);
        combo = 0; // Quebrar combo por perder nota
      }
    }

    notifyListeners();
  }

  void endGame() {
    isPlaying = false;
    isGameOver = true;
    gameTimer?.cancel();
    noteTimer?.cancel();
    notifyListeners();
  }

  void restartGame() {
    startGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    noteTimer?.cancel();
    super.dispose();
  }
}

class RhythmNote {
  final int id;
  double x;
  double y;
  final double speed;
  final NoteType type;

  RhythmNote({
    required this.id,
    required this.x,
    required this.y,
    required this.speed,
    required this.type,
  });
}

enum NoteType { normal, bonus }
