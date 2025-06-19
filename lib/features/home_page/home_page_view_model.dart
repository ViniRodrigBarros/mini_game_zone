import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core.dart';

abstract class HomePageViewModel extends State<HomePage> {
  final _navigatorManager = Modular.get<NavigatorManager>();

  // Controller para a barra de pesquisa
  final TextEditingController searchController = TextEditingController();

  // Lista filtrada de jogos
  List<Map<String, dynamic>> filteredMinigames = [];

  // Lista completa de jogos
  List<Map<String, dynamic>> get allMinigames => [
    {
      'title': I18n.strings.minigameMemory,
      'icon': Icons.memory,
      'route': MemoryGame.route,
      'searchTerms': [
        'memory',
        'memoria',
        'memória',
        'jogo da memoria',
        'memory game',
        'juego de memoria',
      ],
    },
    {
      'title': I18n.strings.minigameSnakeGame,
      'icon': Icons.sports_esports,
      'route': SnakeGame.route,
      'searchTerms': [
        'snake',
        'cobra',
        'serpiente',
        'snake game',
        'jogo da cobra',
        'juego de la serpiente',
      ],
    },
    {
      'title': I18n.strings.minigameHangman,
      'icon': Icons.text_fields,
      'route': Hangman.route,
      'searchTerms': [
        'hangman',
        'forca',
        'ahorcado',
        'forca game',
        'hangman game',
        'juego del ahorcado',
      ],
    },
    {
      'title': I18n.strings.minigameSudoku,
      'icon': Icons.grid_on,
      'route': Sudoku.route,
      'searchTerms': ['sudoku', 'sudoku game', 'jogo sudoku', 'juego sudoku'],
    },
    {
      'title': 'Flappy Bird',
      'icon': Icons.flight,
      'route': FlappyBird.route,
      'searchTerms': [
        'flappy',
        'bird',
        'flappy bird',
        'pássaro',
        'ave',
        'pajaro',
      ],
    },
    {
      'title': I18n.strings.minigameTicTacToe,
      'icon': Icons.close,
      'route': TicTacToe.route,
      'searchTerms': [
        'tic tac toe',
        'jogo da velha',
        'tres en raya',
        'tic tac toe game',
        'jogo da velha game',
        'tres en raya game',
      ],
    },
    {
      'title': I18n.strings.minigamePong,
      'icon': Icons.sports_tennis,
      'route': '/Pong/',
      'searchTerms': [
        'pong',
        'tennis',
        'tenis',
        'pong game',
        'jogo pong',
        'juego pong',
      ],
    },
    {
      'title': I18n.strings.minigameTapTheDot,
      'icon': Icons.circle,
      'route': '/TapTheDot/',
      'searchTerms': [
        'tap the dot',
        'toque no ponto',
        'toca el punto',
        'dot',
        'ponto',
        'punto',
      ],
    },
    {
      'title': I18n.strings.minigameRhythmTap,
      'icon': Icons.music_note,
      'route': '/RhythmTap/',
      'searchTerms': [
        'rhythm tap',
        'ritmo',
        'musica',
        'música',
        'music',
        'rhythm',
        'tap',
      ],
    },
    {
      'title': I18n.strings.minigameMazeRunner,
      'icon': Icons.explore,
      'route': '/MazeRunner/',
      'searchTerms': [
        'maze runner',
        'labirinto',
        'laberinto',
        'maze',
        'runner',
        'explore',
        'explorar',
      ],
    },
    // Adicione mais minigames aqui
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar lista filtrada com todos os jogos
    filteredMinigames = List.from(allMinigames);

    // Adicionar listener para mudanças na pesquisa
    searchController.addListener(_filterGames);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterGames() {
    final query = searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      // Se não há pesquisa, mostrar todos os jogos
      setState(() {
        filteredMinigames = List.from(allMinigames);
      });
    } else {
      // Filtrar jogos baseado na pesquisa
      setState(() {
        filteredMinigames = allMinigames.where((game) {
          // Verificar se o título contém a pesquisa
          final title = game['title'].toString().toLowerCase();
          if (title.contains(query)) return true;

          // Verificar se algum termo de busca contém a pesquisa
          final searchTerms = game['searchTerms'] as List<String>;
          return searchTerms.any((term) => term.toLowerCase().contains(query));
        }).toList();
      });
    }
  }

  void clearSearch() {
    searchController.clear();
  }

  Future<void> navigateToGame(String route) async {
    await _navigatorManager.to(route);
  }

  Future<void> toConfig() async {
    await _navigatorManager.to(AppConfig.route);
  }
}
