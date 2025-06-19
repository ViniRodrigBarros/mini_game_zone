import 'package:flutter/material.dart';
import './snake_game_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class SnakeGameView extends SnakeGameViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Snake Game'),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              '${I18n.strings.tttRestart}: $score',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Grid
                    for (int x = 0; x < 20; x++)
                      for (int y = 0; y < 20; y++)
                        Positioned(
                          left: x * 16.0,
                          top: y * 16.0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.05),
                              ),
                            ),
                          ),
                        ),
                    // Food
                    Positioned(
                      left: food.x * 16.0,
                      top: food.y * 16.0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: highlight,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Snake
                    for (int i = 0; i < snake.length; i++)
                      Positioned(
                        left: snake[i].x * 16.0,
                        top: snake[i].y * 16.0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: i == 0
                                ? primary
                                : primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      ),
                    // Game Over
                    if (isGameOver)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.3),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Game Over',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: highlight,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: highlight,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: restartGame,
                                  icon: const Icon(Icons.refresh),
                                  label: Text(I18n.strings.tttRestart),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Controles
            if (!isGameOver) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    iconSize: 32,
                    color: highlight,
                    onPressed: () => changeDirection(Direction.up),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 32,
                    color: highlight,
                    onPressed: () => changeDirection(Direction.left),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: isPlaying ? null : startGame,
                    child: Text(isPlaying ? 'Jogando...' : 'Iniciar'),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    iconSize: 32,
                    color: highlight,
                    onPressed: () => changeDirection(Direction.right),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 32,
                    color: highlight,
                    onPressed: () => changeDirection(Direction.down),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
