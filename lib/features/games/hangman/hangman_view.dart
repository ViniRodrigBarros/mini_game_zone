import 'package:flutter/material.dart';
import './hangman_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class HangmanView extends HangmanViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final secondary = Theme.of(context).colorScheme.secondary;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(I18n.strings.minigameHangman),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${I18n.strings.tttRestart}: ${maxTries - wrong.length}',
                style: TextStyle(
                  fontSize: 18,
                  color: secondary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.split('').map((l) {
                  final revealed = guessed.contains(l) || isGameOver;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: revealed
                          ? primary
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primary, width: 2),
                    ),
                    child: Text(
                      revealed ? l : '',
                      style: TextStyle(
                        fontSize: 28,
                        color: revealed ? Colors.white : Colors.black26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        letterSpacing: 2,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: alphabet.map((l) {
                  final used = guessed.contains(l) || wrong.contains(l);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: used
                          ? Colors.grey.withValues(alpha: 0.3)
                          : highlight,
                      foregroundColor: used ? Colors.black26 : Colors.white,
                      minimumSize: const Size(40, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: used || isGameOver ? null : () => guessLetter(l),
                    child: Text(l),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              if (isGameOver) ...[
                Text(
                  isWin
                      ? I18n.strings.hangmanWin.replaceFirst('{word}', word)
                      : I18n.strings.hangmanLose.replaceFirst('{word}', word),
                  style: TextStyle(
                    fontSize: 20,
                    color: isWin ? highlight : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
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
                  onPressed: restartGame,
                  icon: const Icon(Icons.refresh),
                  label: Text(I18n.strings.tttRestart),
                ),
              ],
              if (!isGameOver) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
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
                  onPressed: restartGame,
                  icon: const Icon(Icons.refresh),
                  label: Text(I18n.strings.tttRestart),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
