import 'package:flutter/material.dart';
import './tetris_view.dart';

class Tetris extends StatefulWidget {
  static const route = '/Tetris/';
  const Tetris({super.key});

  @override
  State<Tetris> createState() => TetrisView();
}
