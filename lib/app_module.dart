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
      ..child(MemoryGame.route, child: (context) => const MemoryGame())
      ..child(Hangman.route, child: (context) => const Hangman())
      ..child(TicTacToe.route, child: (context) => const TicTacToe());
  }
}
