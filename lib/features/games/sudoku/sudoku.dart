import 'package:flutter/material.dart';
import './sudoku_view.dart';

class Sudoku extends StatefulWidget {
  static const route = '/Sudoku/';
  const Sudoku({super.key});

  @override
  SudokuView createState() => SudokuView();
}
