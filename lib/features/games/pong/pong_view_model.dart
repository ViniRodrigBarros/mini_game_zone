import 'package:flutter/material.dart';
import './pong.dart';
import 'dart:async';
import 'dart:math';

abstract class PongViewModel extends State<Pong> {
  static const double width = 360;
  static const double height = 600;
  static const double paddleWidth = 80;
  static const double paddleHeight = 16;
  static const double ballSize = 18;
  static const double paddleY = height - 40;

  double paddleX = width / 2 - paddleWidth / 2;
  double ballX = width / 2 - ballSize / 2;
  double ballY = height / 2 - ballSize / 2;
  double ballVX = 4;
  double ballVY = -4;
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
    paddleX = width / 2 - paddleWidth / 2;
    ballX = width / 2 - ballSize / 2;
    ballY = height / 2 - ballSize / 2;
    ballVX = 4 * (Random().nextBool() ? 1 : -1);
    ballVY = -4;
    score = 0;
    isPlaying = false;
    isGameOver = false;
    gameLoop?.cancel();
    setState(() {});
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

  void movePaddle(double dx) {
    paddleX += dx;
    paddleX = paddleX.clamp(0, width - paddleWidth);
    setState(() {});
  }

  void _update() {
    ballX += ballVX;
    ballY += ballVY;
    // Colisão com paredes
    if (ballX <= 0 || ballX + ballSize >= width) ballVX *= -1;
    if (ballY <= 0) ballVY *= -1;
    // Colisão com raquete
    if (ballY + ballSize >= paddleY &&
        ballX + ballSize >= paddleX &&
        ballX <= paddleX + paddleWidth &&
        ballY + ballSize <= paddleY + paddleHeight) {
      ballVY *= -1;
      ballY = paddleY - ballSize;
      score++;
    }
    // Game over
    if (ballY > height) {
      isGameOver = true;
      isPlaying = false;
      gameLoop?.cancel();
    }
    setState(() {});
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
