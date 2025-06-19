import 'package:flutter/material.dart';
import './flappy_bird.dart';
import 'dart:async';
import 'dart:math';

abstract class FlappyBirdViewModel extends State<FlappyBird> {
  static const double gravity = 0.6;
  static const double jumpVelocity = -8;
  static const double birdWidth = 40;
  static const double birdHeight = 40;
  static const double pipeWidth = 60;
  static const double gap = 160;
  static const double pipeSpeed = 2.5;

  double birdY = 0.0;
  double velocity = 0.0;
  List<Pipe> pipes = [];
  int score = 0;
  bool isPlaying = false;
  bool isGameOver = false;
  Timer? gameLoop;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    birdY = 0.0;
    velocity = 0.0;
    pipes = [
      Pipe(x: 350, gapY: _randomGapY()),
      Pipe(x: 350 + 200, gapY: _randomGapY()),
    ];
    score = 0;
    isPlaying = false;
    isGameOver = false;
    gameLoop?.cancel();
    setState(() {});
  }

  double _randomGapY() {
    final rand = Random();
    return 100 + rand.nextDouble() * 250;
  }

  void startGame() {
    if (isPlaying) return;
    isPlaying = true;
    isGameOver = false;
    gameLoop = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _update(),
    );
    setState(() {});
  }

  void jump() {
    if (!isPlaying) startGame();
    velocity = jumpVelocity;
  }

  void _update() {
    velocity += gravity;
    birdY += velocity;
    for (final pipe in pipes) {
      pipe.x -= pipeSpeed;
    }
    // Novo pipe
    if (pipes.first.x < -pipeWidth) {
      pipes.removeAt(0);
      pipes.add(Pipe(x: pipes.last.x + 200, gapY: _randomGapY()));
      score++;
    }
    // Colisão
    if (_checkCollision()) {
      isGameOver = true;
      isPlaying = false;
      gameLoop?.cancel();
    }
    // Fora da tela
    if (birdY > 500 || birdY < -300) {
      isGameOver = true;
      isPlaying = false;
      gameLoop?.cancel();
    }
    setState(() {});
  }

  bool _checkCollision() {
    for (final pipe in pipes) {
      final birdRect = Rect.fromLTWH(80, birdY + 250, birdWidth, birdHeight);
      final topPipeRect = Rect.fromLTWH(
        pipe.x,
        0,
        pipeWidth,
        pipe.gapY - gap / 2,
      );
      final bottomPipeRect = Rect.fromLTWH(
        pipe.x,
        pipe.gapY + gap / 2,
        pipeWidth,
        600 - pipe.gapY,
      );
      if (birdRect.overlaps(topPipeRect) || birdRect.overlaps(bottomPipeRect)) {
        return true;
      }
    }
    return false;
  }

  void restartGame() {
    _resetGame();
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }
}

class Pipe {
  double x;
  double gapY;
  Pipe({required this.x, required this.gapY});
}
