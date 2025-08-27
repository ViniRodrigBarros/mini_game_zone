import 'package:flutter/material.dart';

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
            automaticallyImplyLeading: false,
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
            child: Column(
              children: [
                // Barra de pesquisa
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: _getSearchHint(),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                // Lista de jogos
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: filteredMinigames.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1,
                                ),
                            itemCount: filteredMinigames.length,
                            itemBuilder: (context, index) {
                              final minigame = filteredMinigames[index];
                              String title;
                              switch (minigame['route']) {
                                case MemoryGame.route:
                                  title = I18n.strings.minigameMemory;
                                  break;
                                case SnakeGame.route:
                                  title = I18n.strings.minigameSnakeGame;
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
                                  title = I18n.strings.tttTitle;
                                  break;
                                case '/MazeRunner/':
                                  title = I18n.strings.minigameMazeRunner;
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
              ],
            ),
          ),
        );
      },
    );
  }

  String _getSearchHint() {
    final locale = I18n.localeNotifier.value.languageCode;
    switch (locale) {
      case 'pt':
        return 'Pesquisar jogos...';
      case 'es':
        return 'Buscar juegos...';
      default:
        return 'Search games...';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateText(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubtext(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateText() {
    final locale = I18n.localeNotifier.value.languageCode;
    switch (locale) {
      case 'pt':
        return 'Nenhum jogo encontrado';
      case 'es':
        return 'No se encontraron juegos';
      default:
        return 'No games found';
    }
  }

  String _getEmptyStateSubtext() {
    final locale = I18n.localeNotifier.value.languageCode;
    switch (locale) {
      case 'pt':
        return 'Tente uma pesquisa diferente';
      case 'es':
        return 'Intenta una búsqueda diferente';
      default:
        return 'Try a different search';
    }
  }
}
