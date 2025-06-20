import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';

enum TetrisPiece { I, O, T, S, Z, J, L }

enum Direction { left, right, down }

class TetrisViewModel extends ChangeNotifier {
  static const int rows = 20;
  static const int cols = 10;
  static const Duration initialTick = Duration(milliseconds: 500);

  // Estado do jogo
  List<List<int>> board = [];
  List<Point<int>> currentPiece = [];
  List<Point<int>> nextPiece = [];
  TetrisPiece currentPieceType = TetrisPiece.I;
  TetrisPiece nextPieceType = TetrisPiece.I;
  int currentX = 0;
  int currentY = 0;
  int score = 0;
  int level = 1;
  int linesCleared = 0;
  bool isPlaying = false;
  bool isGameOver = false;
  bool isPaused = false;
  Timer? gameLoop;

  // Definição das peças
  static const Map<TetrisPiece, List<List<Point<int>>>> pieceDefinitions = {
    TetrisPiece.I: [
      [Point(0, 0), Point(1, 0), Point(2, 0), Point(3, 0)],
      [Point(1, 0), Point(1, 1), Point(1, 2), Point(1, 3)],
      [Point(0, 1), Point(1, 1), Point(2, 1), Point(3, 1)],
      [Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3)],
    ],
    TetrisPiece.O: [
      [Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)],
    ],
    TetrisPiece.T: [
      [Point(1, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
      [Point(1, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
      [Point(0, 1), Point(1, 1), Point(2, 1), Point(1, 2)],
      [Point(1, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
    ],
    TetrisPiece.S: [
      [Point(1, 0), Point(2, 0), Point(0, 1), Point(1, 1)],
      [Point(1, 0), Point(1, 1), Point(2, 1), Point(2, 2)],
      [Point(1, 1), Point(2, 1), Point(0, 2), Point(1, 2)],
      [Point(0, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
    ],
    TetrisPiece.Z: [
      [Point(0, 0), Point(1, 0), Point(1, 1), Point(2, 1)],
      [Point(2, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
      [Point(0, 1), Point(1, 1), Point(1, 2), Point(2, 2)],
      [Point(1, 0), Point(0, 1), Point(1, 1), Point(0, 2)],
    ],
    TetrisPiece.J: [
      [Point(0, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
      [Point(1, 0), Point(2, 0), Point(1, 1), Point(1, 2)],
      [Point(0, 1), Point(1, 1), Point(2, 1), Point(2, 2)],
      [Point(1, 0), Point(1, 1), Point(0, 2), Point(1, 2)],
    ],
    TetrisPiece.L: [
      [Point(2, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
      [Point(1, 0), Point(1, 1), Point(1, 2), Point(2, 2)],
      [Point(0, 1), Point(1, 1), Point(2, 1), Point(0, 2)],
      [Point(0, 0), Point(1, 0), Point(1, 1), Point(1, 2)],
    ],
  };

  static const Map<TetrisPiece, Color> pieceColors = {
    TetrisPiece.I: Colors.cyan,
    TetrisPiece.O: Colors.yellow,
    TetrisPiece.T: Colors.purple,
    TetrisPiece.S: Colors.green,
    TetrisPiece.Z: Colors.red,
    TetrisPiece.J: Colors.blue,
    TetrisPiece.L: Colors.orange,
  };

  int currentRotation = 0;
  final Random random = Random();

  TetrisViewModel() {
    _resetGame();
  }

  void _resetGame() {
    board = List.generate(rows, (y) => List.generate(cols, (x) => 0));
    score = 0;
    level = 1;
    linesCleared = 0;
    isPlaying = false;
    isGameOver = false;
    isPaused = false;
    gameLoop?.cancel();
    _generateNewPiece();
    notifyListeners();
  }

  void startGame() {
    if (isPlaying) return;
    isPlaying = true;
    isGameOver = false;
    isPaused = false;
    _generateNewPiece();
    gameLoop = Timer.periodic(_getCurrentTick(), (_) => _update());
    notifyListeners();
  }

  void pauseGame() {
    if (!isPlaying || isGameOver) return;
    isPaused = !isPaused;
    if (isPaused) {
      gameLoop?.cancel();
    } else {
      gameLoop = Timer.periodic(_getCurrentTick(), (_) => _update());
    }
    notifyListeners();
  }

  Duration _getCurrentTick() {
    return Duration(milliseconds: max(50, 500 - (level - 1) * 50));
  }

  void _generateNewPiece() {
    if (nextPiece.isEmpty) {
      nextPieceType = _getRandomPiece();
      nextPiece = pieceDefinitions[nextPieceType]![0];
    }

    currentPieceType = nextPieceType;
    currentPiece = List.from(nextPiece);
    currentRotation = 0;
    currentX = cols ~/ 2 - 1;
    currentY = 0;

    nextPieceType = _getRandomPiece();
    nextPiece = pieceDefinitions[nextPieceType]![0];

    if (!_isValidPosition(currentX, currentY, currentPiece)) {
      isGameOver = true;
      isPlaying = false;
      gameLoop?.cancel();
    }
  }

  TetrisPiece _getRandomPiece() {
    final pieces = TetrisPiece.values;
    return pieces[random.nextInt(pieces.length)];
  }

  void movePiece(Direction direction) {
    if (!isPlaying || isGameOver || isPaused) return;

    int newX = currentX;
    int newY = currentY;

    switch (direction) {
      case Direction.left:
        newX--;
        break;
      case Direction.right:
        newX++;
        break;
      case Direction.down:
        newY++;
        break;
    }

    if (_isValidPosition(newX, newY, currentPiece)) {
      currentX = newX;
      currentY = newY;
      notifyListeners();
    } else if (direction == Direction.down) {
      _placePiece();
    }
  }

  void rotatePiece() {
    if (!isPlaying || isGameOver || isPaused) return;

    final rotations = pieceDefinitions[currentPieceType]!;
    final nextRotation = (currentRotation + 1) % rotations.length;
    final rotatedPiece = rotations[nextRotation];

    if (_isValidPosition(currentX, currentY, rotatedPiece)) {
      currentRotation = nextRotation;
      currentPiece = List.from(rotatedPiece);
      notifyListeners();
    }
  }

  bool _isValidPosition(int x, int y, List<Point<int>> piece) {
    for (final point in piece) {
      final boardX = x + point.x;
      final boardY = y + point.y;

      if (boardX < 0 || boardX >= cols || boardY >= rows) {
        return false;
      }

      if (boardY >= 0 && board[boardY][boardX] != 0) {
        return false;
      }
    }
    return true;
  }

  void _placePiece() {
    for (final point in currentPiece) {
      final boardX = currentX + point.x;
      final boardY = currentY + point.y;
      if (boardY >= 0) {
        board[boardY][boardX] = pieceColors[currentPieceType]!.toARGB32();
      }
    }

    _clearLines();
    _generateNewPiece();
  }

  void _clearLines() {
    int linesToClear = 0;
    for (int y = rows - 1; y >= 0; y--) {
      if (board[y].every((cell) => cell != 0)) {
        board.removeAt(y);
        board.insert(0, List.generate(cols, (x) => 0));
        linesToClear++;
        y++; // Recheck the same row
      }
    }

    if (linesToClear > 0) {
      linesCleared += linesToClear;
      score += _calculateScore(linesToClear);
      level = (linesCleared ~/ 10) + 1;

      // Update game speed
      if (isPlaying) {
        gameLoop?.cancel();
        gameLoop = Timer.periodic(_getCurrentTick(), (_) => _update());
      }
    }
  }

  int _calculateScore(int lines) {
    switch (lines) {
      case 1:
        return 100 * level;
      case 2:
        return 300 * level;
      case 3:
        return 500 * level;
      case 4:
        return 800 * level;
      default:
        return 0;
    }
  }

  void _update() {
    if (!isPlaying || isGameOver || isPaused) return;
    movePiece(Direction.down);
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
