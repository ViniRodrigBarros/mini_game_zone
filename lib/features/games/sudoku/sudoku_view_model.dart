import 'package:flutter/material.dart';
import './sudoku.dart';

abstract class SudokuViewModel extends State<Sudoku> {
  late List<List<int>> board;
  late List<List<bool>> fixed;
  int? selectedRow;
  int? selectedCol;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final puzzle = _generatePuzzle();
    board = puzzle.map((row) => List<int>.from(row)).toList();
    fixed = puzzle.map((row) => row.map((v) => v != 0).toList()).toList();
    selectedRow = null;
    selectedCol = null;
    isGameOver = false;
    setState(() {});
  }

  List<List<int>> _generatePuzzle() {
    // Exemplo simples (puzzle fácil, 0 = vazio)
    return [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
    ];
  }

  void selectCell(int row, int col) {
    if (fixed[row][col] || isGameOver) return;
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void fillCell(int value) {
    if (selectedRow == null ||
        selectedCol == null ||
        fixed[selectedRow!][selectedCol!] ||
        isGameOver) {
      return;
    }
    setState(() {
      board[selectedRow!][selectedCol!] = value;
      if (_checkWin()) {
        isGameOver = true;
      }
    });
  }

  void restartGame() {
    _initGame();
  }

  bool _checkWin() {
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board[row][col] == 0) return false;
      }
    }
    // Checagem simplificada (não valida regras de Sudoku)
    return true;
  }
}
