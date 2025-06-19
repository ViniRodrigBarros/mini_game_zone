import 'package:flutter/material.dart';
import './snake_game_view.dart';

class SnakeGame extends StatefulWidget {
  static const route = '/SnakeGame/';
  const SnakeGame({super.key});

  @override
  SnakeGameView createState() => SnakeGameView();
}
