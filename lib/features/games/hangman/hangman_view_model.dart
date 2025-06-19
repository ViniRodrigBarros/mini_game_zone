import 'package:flutter/material.dart';
import './hangman.dart';
import 'dart:math';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'words.dart';

abstract class HangmanViewModel extends State<Hangman> {
  List<String> get _currentWords {
    final lang = I18n.instance.locale.languageCode;
    if (lang == 'en') return HangmanWords.en;
    if (lang == 'es') return HangmanWords.es;
    return HangmanWords.pt;
  }

  late String word;
  late List<String> guessed;
  late List<String> wrong;
  int maxTries = 6;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se o idioma mudar, reinicia o jogo com palavras do novo idioma
    _initGame();
  }

  void _initGame() {
    final rand = Random();
    final words = _currentWords;
    word = words[rand.nextInt(words.length)];
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
