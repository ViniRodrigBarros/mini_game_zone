import 'package:flutter/material.dart';
import './hangman.dart';
import 'dart:math';

abstract class HangmanViewModel extends State<Hangman> {
  static const List<String> _words = [
    'FLUTTER',
    'DART',
    'MOBILE',
    'WIDGET',
    'STATE',
    'GOOGLE',
    'ANDROID',
    'APPLE',
  ];
  late String word;
  late List<String> guessed;
  late List<String> wrong;
  int maxTries = 6;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final rand = Random();
    word = _words[rand.nextInt(_words.length)];
    guessed = [];
    wrong = [];
    setState(() {});
  }

  void guessLetter(String letter) {
    if (guessed.contains(letter) || wrong.contains(letter) || isGameOver) {
      return;
    }
    setState(() {
      if (word.contains(letter)) {
        guessed.add(letter);
      } else {
        wrong.add(letter);
      }
    });
  }

  void restartGame() {
    _initGame();
  }

  bool get isWin => word.split('').every((l) => guessed.contains(l));
  bool get isLose => wrong.length >= maxTries;
  bool get isGameOver => isWin || isLose;
}
