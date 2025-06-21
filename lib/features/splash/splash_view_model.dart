import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/core.dart';

abstract class SplashViewModel extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Modular.get<AudioManager>().initialize().catchError((error) {
        log('⚠️ AudioManager não pôde ser inicializado: $error');
      });
      Modular.get<NavigatorManager>().to(HomePage.route);
    });
  }

  // Add your state and logic here
}
