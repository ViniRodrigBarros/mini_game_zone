import 'package:flutter/material.dart';
import './memory_game_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class MemoryGameView extends MemoryGameViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final secondary = Theme.of(context).colorScheme.secondary;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(I18n.strings.minigameMemory),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${I18n.strings.tttRestart}: $moves',
                    style: TextStyle(
                      fontSize: 18,
                      color: secondary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
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
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    final card = cards[i];
                    return GestureDetector(
                      onTap: () => onCardTap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: card.matched
                              ? highlight.withValues(alpha: 0.7)
                              : card.revealed
                              ? primary.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.10),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: card.matched
                                ? highlight
                                : card.revealed
                                ? primary
                                : Colors.grey.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: card.revealed || card.matched
                                ? Icon(card.icon, size: 36, color: Colors.white)
                                : const Icon(
                                    Icons.help_outline,
                                    size: 32,
                                    color: Colors.black26,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isGameOver) ...[
                const SizedBox(height: 24),
                Text(
                  'Parabéns! Você venceu em $moves movimentos!',
                  style: TextStyle(
                    fontSize: 20,
                    color: highlight,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
