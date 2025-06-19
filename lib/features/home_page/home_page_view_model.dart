import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core.dart';

abstract class HomePageViewModel extends State<HomePage> {
  final _navigatorManager = Modular.get<NavigatorManager>();
  List<Map<String, dynamic>> get minigames => [
    {
      'title': I18n.strings.minigameMemory,
      'icon': Icons.memory,
      'route': MemoryGame.route,
    },
    {'title': I18n.strings.minigameQuiz, 'icon': Icons.quiz, 'route': '/quiz'},
    {
      'title': I18n.strings.minigameHangman,
      'icon': Icons.text_fields,
      'route': Hangman.route,
    },
    {
      'title': I18n.strings.minigameSudoku,
      'icon': Icons.grid_on,
      'route': '/sudoku',
    },
    {'title': 'Flappy Bird', 'icon': Icons.flight, 'route': FlappyBird.route},
    {
      'title': I18n.strings.minigameTicTacToe,
      'icon': Icons.close,
      'route': TicTacToe.route,
    },
    // Adicione mais minigames aqui
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> navigateToGame(String route) async {
    await _navigatorManager.to(route);
  }

  Future<void> toConfig() async {
    await _navigatorManager.to(AppConfig.route);
  }
}
