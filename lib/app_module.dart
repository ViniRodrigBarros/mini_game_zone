import 'package:flutter_modular/flutter_modular.dart';

import 'core/core.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    i
      ..addSingleton<StorageManager>(() => StorageManager.instance)
      ..addSingleton<NavigatorManager>(() => NavigatorManager.instance);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r
      ..child('/', child: (context) => const Splash())
      ..child(HomePage.route, child: (context) => const HomePage())
      ..child(AppConfig.route, child: (context) => const AppConfig())
      //Games
      ..child(FlappyBird.route, child: (context) => const FlappyBird())
      ..child(MemoryGame.route, child: (context) => const MemoryGame())
      ..child(Hangman.route, child: (context) => const Hangman())
      ..child(Sudoku.route, child: (context) => const Sudoku())
      ..child(SnakeGame.route, child: (context) => const SnakeGame())
      ..child(TicTacToe.route, child: (context) => const TicTacToe())
      ..child(Pong.route, child: (context) => const Pong())
      ..child(TapTheDot.route, child: (context) => const TapTheDot())
      ..child(MazeRunnerView.route, child: (context) => const MazeRunnerView());
  }
}
