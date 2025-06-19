import 'package:flutter/material.dart';
import './tap_the_dot_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class TapTheDotView extends TapTheDotViewModel {
  //TODO armazenar o score e o tempo no local storage
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(I18n.strings.minigameTapTheDot),
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
            const SizedBox(height: 4),
            Text(
              'Tempo: $timeLeft',
              style: TextStyle(
                fontSize: 18,
                color: highlight,
                fontWeight: FontWeight.bold,
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
                    if (isPlaying && !isGameOver)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        left: dotX,
                        top: dotY,
                        child: GestureDetector(
                          onTap: tapDot,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: highlight,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: highlight.withValues(alpha: 0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (!isPlaying && !isGameOver)
                      const Center(
                        child: Text(
                          'Toque em Iniciar para começar',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
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
