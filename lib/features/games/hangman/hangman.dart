import 'package:flutter/material.dart';
import './hangman_view.dart';

class Hangman extends StatefulWidget {
  static const route = '/Hangman/';
  const Hangman({super.key});

  @override
  HangmanView createState() => HangmanView();
}
