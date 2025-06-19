import 'package:flutter/material.dart';
import './splash_view_model.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class SplashView extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(I18n.strings.splashLoading),
          ],
        ),
      ),
    );
  }
}
