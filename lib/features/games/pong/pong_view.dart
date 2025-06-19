import 'package:flutter/material.dart';
import './pong_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'dart:math';

class PongView extends PongViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(I18n.strings.minigamePong),
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
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (!isGameOver) movePaddle(details.delta.dx);
                },
                onTap: isPlaying ? null : startGame,
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
                      // Raquete
                      Positioned(
                        left: paddleX,
                        top: 600 - 40,
                        child: Container(
                          width: 80,
                          height: 16,
                          decoration: BoxDecoration(
                            color: highlight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      // Bola
                      Positioned(
                        left: ballX,
                        top: ballY,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
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
            ),
            const SizedBox(height: 16),
            if (!isPlaying && !isGameOver)
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
                onPressed: startGame,
                child: Text('Iniciar'),
              ),
          ],
        ),
      ),
    );
  }
}
