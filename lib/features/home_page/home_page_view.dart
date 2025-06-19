import 'package:flutter/material.dart';

import 'package:mini_game_zone/core/components/minigame_button.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

import '../../core/core.dart';
import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: I18n.localeNotifier,
      builder: (context, locale, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.strings.homeTitle),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: I18n.strings.settingsTitle,
                onPressed: toConfig,
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: minigames.length,
                itemBuilder: (context, index) {
                  final minigame = minigames[index];
                  String title;
                  switch (minigame['route']) {
                    case MemoryGame.route:
                      title = I18n.strings.minigameMemory;
                      break;
                    case '/quiz':
                      title = I18n.strings.minigameQuiz;
                      break;
                    case Hangman.route:
                      title = I18n.strings.minigameHangman;
                      break;
                    case '/sudoku':
                      title = I18n.strings.minigameSudoku;
                      break;
                    case '':
                      title = 'Flappy bird';
                      break;
                    case '/tic_tac_toe':
                      title = I18n.strings.minigameTicTacToe;
                      break;
                    default:
                      title = minigame['title'] as String;
                  }
                  return MinigameButton(
                    title: title,
                    icon: minigame['icon'] as IconData,
                    onTap: () {
                      navigateToGame(minigame['route'] as String);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
