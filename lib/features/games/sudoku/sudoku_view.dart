import 'package:flutter/material.dart';
import './sudoku_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class SudokuView extends SudokuViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(I18n.strings.minigameSudoku),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
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
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                    itemCount: 81,
                    itemBuilder: (context, i) {
                      final row = i ~/ 9;
                      final col = i % 9;
                      final isSelected =
                          selectedRow == row && selectedCol == col;
                      final isFixed = fixed[row][col];
                      return GestureDetector(
                        onTap: () => selectCell(row, col),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? highlight.withValues(alpha: 0.7)
                                : isFixed
                                ? primary.withValues(alpha: 0.7)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? highlight
                                  : isFixed
                                  ? primary
                                  : Colors.grey.withValues(alpha: 0.2),
                              width: isSelected ? 3 : 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              board[row][col] == 0
                                  ? ''
                                  : board[row][col].toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: isFixed
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isFixed ? Colors.white : Colors.black87,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!isGameOver)
                Wrap(
                  spacing: 8,
                  children: List.generate(9, (i) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: highlight,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(40, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => fillCell(i + 1),
                      child: Text('${i + 1}'),
                    );
                  }),
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
              if (isGameOver) ...[
                const SizedBox(height: 24),
                Text(
                  'Parabéns! Você completou o Sudoku!',
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
