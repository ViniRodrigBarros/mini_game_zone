import 'package:flutter/material.dart';
import './snake_game.dart';
import 'dart:async';
import 'dart:math';

enum Direction { up, down, left, right }

abstract class SnakeGameViewModel extends State<SnakeGame> {
  static const int rows = 20;
  static const int cols = 20;
  static const Duration tick = Duration(milliseconds: 120);

  List<Point<int>> snake = [];
  Point<int> food = const Point(10, 10);
  Direction direction = Direction.right;
  Direction? nextDirection;
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
    snake = [const Point(5, 10), const Point(4, 10), const Point(3, 10)];
    direction = Direction.right;
    nextDirection = null;
    food = _randomFood();
    score = 0;
    isPlaying = false;
    isGameOver = false;
    gameLoop?.cancel();
    setState(() {});
  }

  Point<int> _randomFood() {
    final rand = Random();
    Point<int> pos;
    do {
      pos = Point(rand.nextInt(cols), rand.nextInt(rows));
    } while (snake.contains(pos));
    return pos;
  }

  void startGame() {
    if (isPlaying) return;
    isPlaying = true;
    isGameOver = false;
    gameLoop = Timer.periodic(tick, (_) => _update());
    setState(() {});
  }

  void changeDirection(Direction d) {
    // Impede reversão direta
    if ((direction == Direction.up && d == Direction.down) ||
        (direction == Direction.down && d == Direction.up) ||
        (direction == Direction.left && d == Direction.right) ||
        (direction == Direction.right && d == Direction.left)) {
      return;
    }
    nextDirection = d;
  }

  void _update() {
    if (nextDirection != null) {
      direction = nextDirection!;
      nextDirection = null;
    }
    final head = snake.first;
    Point<int> newHead;
    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }
    // Colisão
    if (newHead.x < 0 ||
        newHead.x >= cols ||
        newHead.y < 0 ||
        newHead.y >= rows ||
        snake.contains(newHead)) {
      isGameOver = true;
      isPlaying = false;
      gameLoop?.cancel();
      setState(() {});
      return;
    }
    snake = [newHead, ...snake];
    if (newHead == food) {
      score++;
      food = _randomFood();
    } else {
      snake.removeLast();
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
