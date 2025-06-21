import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mini_game_zone/app_module.dart';
import 'package:mini_game_zone/core/managers/audio_manager.dart.dart';

import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o AudioManager de forma não-bloqueante

  //await Modular.get<StorageManager>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modularApp = ModularApp(
      module: AppModule(),
      debugMode: kDebugMode,
      child: const AppWidget(),
    );
    return modularApp;
  }
}
