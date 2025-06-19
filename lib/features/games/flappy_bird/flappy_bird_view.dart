import 'package:flutter/material.dart';
import './flappy_bird_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'dart:math';

class FlappyBirdView extends FlappyBirdViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Flappy Bird'),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: isGameOver ? null : jump,
          child: Stack(
            children: [
              // Área de jogo
              Center(
                child: Container(
                  width: 360,
                  height: 600,
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
                      // Cano
                      for (final pipe in pipes) ...[
                        Positioned(
                          left: pipe.x,
                          top: 0,
                          child: Container(
                            width: 60,
                            height: pipe.gapY - 80,
                            decoration: BoxDecoration(
                              color: highlight,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: pipe.x,
                          top: pipe.gapY + 80,
                          child: Container(
                            width: 60,
                            height: 600 - (pipe.gapY + 80),
                            decoration: BoxDecoration(
                              color: highlight,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                      // Pássaro
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 60),
                        left: 80,
                        top: birdY + 250,
                        child: Transform.rotate(
                          angle: min(velocity / 20, pi / 4),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flight,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      // Pontuação
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${I18n.strings.tttRestart}: $score',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'Montserrat',
                              ),
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
