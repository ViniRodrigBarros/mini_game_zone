import 'package:flutter/material.dart';
import './tap_the_dot.dart';
import 'dart:async';
import 'dart:math';

abstract class TapTheDotViewModel extends State<TapTheDot> {
  static const double areaSize = 320;
  static const double dotSize = 40;
  static const Duration gameDuration = Duration(seconds: 30);

  double dotX = 0;
  double dotY = 0;
  int score = 0;
  int timeLeft = 30;
  bool isPlaying = false;
  bool isGameOver = false;
  Timer? gameLoop;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    dotX = areaSize / 2 - dotSize / 2;
    dotY = areaSize / 2 - dotSize / 2;
    score = 0;
    timeLeft = 30;
    isPlaying = false;
    isGameOver = false;
    gameLoop?.cancel();
    timer?.cancel();
    setState(() {});
  }

  void startGame() {
    if (isPlaying) return;
    isPlaying = true;
    isGameOver = false;
    score = 0;
    timeLeft = 30;
    _moveDot();
    gameLoop = Timer.periodic(
      const Duration(milliseconds: 800),
      (_) => _moveDot(),
    );
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      timeLeft--;
      if (timeLeft <= 0) {
        isGameOver = true;
        isPlaying = false;
        gameLoop?.cancel();
        timer?.cancel();
      }
      setState(() {});
    });
    setState(() {});
  }

  void _moveDot() {
    final rand = Random();
    dotX = rand.nextDouble() * (areaSize - dotSize);
    dotY = rand.nextDouble() * (areaSize - dotSize);
    setState(() {});
  }

  void tapDot() {
    if (!isPlaying || isGameOver) return;
    score++;
    _moveDot();
    setState(() {});
  }

  void restartGame() {
    _resetGame();
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    timer?.cancel();
    super.dispose();
  }
}
