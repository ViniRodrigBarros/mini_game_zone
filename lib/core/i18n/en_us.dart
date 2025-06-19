import 'translation.dart';

class EnUs implements Translation {
  @override
  String get test => 'test';
  @override
  String get settingsTitle => 'Settings';
  @override
  String get languageLabel => 'Language';
  @override
  String get homeTitle => 'Mini Game Zone';
  @override
  String get splashLoading => 'Loading...';
  @override
  String get tttTitle => 'Tic Tac Toe';
  @override
  String get tttChooseMode => 'Choose game mode:';
  @override
  String get ttt1Player => '1 Player';
  @override
  String get ttt2Players => '2 Players';
  @override
  String get tttWinner => 'Winner';
  @override
  String get tttDraw => 'Draw!';
  @override
  String get tttTurn => 'Turn';
  @override
  String get tttRestart => 'Restart';
  @override
  String get minigameMemory => 'Memory Game';
  @override
  String get minigameQuiz => 'Quiz';
  @override
  String get minigameHangman => 'Hangman';
  @override
  String get minigameSudoku => 'Sudoku';
  @override
  String get minigamePuzzle => 'Puzzle';
  @override
  String get minigameTicTacToe => 'Tic Tac Toe';
  @override
  String get hangmanWin => 'Congratulations! You guessed: {word}';
  @override
  String get hangmanLose => 'You lost! The word was: {word}';
}
