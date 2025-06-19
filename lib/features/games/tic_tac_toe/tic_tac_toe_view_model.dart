import 'package:flutter/material.dart';
import './tic_tac_toe.dart';

abstract class TicTacToeViewModel extends State<TicTacToe> {
  int? gameMode; // 1 para single, 2 para multiplayer
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String? winner;
  bool get isBoardFull => !board.contains('');

  void selectMode(int mode) {
    setState(() {
      gameMode = mode;
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
    });
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
    });
  }

  void makeMove(int index) {
    if (board[index] != '' || winner != null) return;
    setState(() {
      board[index] = currentPlayer;
      winner = checkWinner();
      if (winner == null && !isBoardFull) {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
    if (gameMode == 1 &&
        currentPlayer == 'O' &&
        winner == null &&
        !isBoardFull) {
      aiMove();
    }
  }

  void aiMove() {
    // Simples: pega o primeiro espaço vazio
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        makeMove(i);
        break;
      }
    }
  }

  String? checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        return a;
      }
    }
    return null;
  }
}
