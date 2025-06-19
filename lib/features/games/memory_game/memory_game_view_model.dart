import 'package:flutter/material.dart';
import '../../../core/core.dart';

import 'dart:math';

abstract class MemoryGameViewModel extends State<MemoryGame> {
  late List<MemoryCard> cards;
  int? firstSelected;
  int? secondSelected;
  bool waiting = false;
  int moves = 0;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final icons = [
      Icons.star,
      Icons.cake,
      Icons.pets,
      Icons.favorite,
      Icons.flash_on,
      Icons.music_note,
      Icons.sports_soccer,
      Icons.emoji_emotions,
    ];
    final allIcons = [...icons, ...icons];
    allIcons.shuffle(Random());
    cards = List.generate(
      allIcons.length,
      (i) => MemoryCard(icon: allIcons[i]),
    );
    firstSelected = null;
    secondSelected = null;
    waiting = false;
    moves = 0;
    matches = 0;
    setState(() {});
  }

  void onCardTap(int index) async {
    if (waiting || cards[index].revealed || cards[index].matched) return;
    setState(() {
      if (firstSelected == null) {
        firstSelected = index;
        cards[index].revealed = true;
      } else if (secondSelected == null && index != firstSelected) {
        secondSelected = index;
        cards[index].revealed = true;
        moves++;
        waiting = true;
      }
    });
    if (firstSelected != null && secondSelected != null) {
      await Future.delayed(const Duration(milliseconds: 800));
      final a = cards[firstSelected!];
      final b = cards[secondSelected!];
      if (a.icon == b.icon) {
        setState(() {
          a.matched = true;
          b.matched = true;
          matches++;
        });
      } else {
        setState(() {
          a.revealed = false;
          b.revealed = false;
        });
      }
      setState(() {
        firstSelected = null;
        secondSelected = null;
        waiting = false;
      });
    }
  }

  void restartGame() {
    _initGame();
  }

  bool get isGameOver => matches == cards.length ~/ 2;
}
