import 'dart:ui';

import 'package:flutter/material.dart';

class TicTacToeCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final bool highlight;
  final Color primary;
  final Color secondary;
  const TicTacToeCell({
    super.key,
    required this.value,
    required this.onTap,
    required this.highlight,
    required this.primary,
    required this.secondary,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: value == '' ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: value == ''
              ? Colors.white.withOpacity(0.5)
              : (highlight
                    ? secondary.withOpacity(0.8)
                    : primary.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: value == '' ? Colors.grey.withOpacity(0.2) : Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: value == ''
                ? null
                : Text(
                    value,
                    key: ValueKey(value),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
