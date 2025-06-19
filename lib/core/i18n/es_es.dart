import 'translation.dart';

class EsEs implements Translation {
  @override
  String get test => 'prueba';
  @override
  String get settingsTitle => 'Configuración';
  @override
  String get languageLabel => 'Idioma';
  @override
  String get homeTitle => 'Mini Game Zone';
  @override
  String get splashLoading => 'Cargando...';
  @override
  String get tttTitle => 'Tres en Raya';
  @override
  String get tttChooseMode => 'Elige el modo de juego:';
  @override
  String get ttt1Player => '1 Jugador';
  @override
  String get ttt2Players => '2 Jugadores';
  @override
  String get tttWinner => 'Ganador';
  @override
  String get tttDraw => '¡Empate!';
  @override
  String get tttTurn => 'Turno de';
  @override
  String get tttRestart => 'Reiniciar';
  @override
  String get minigameMemory => 'Juego de Memoria';
  @override
  String get minigameSnakeGame => 'Snake Game';
  @override
  String get minigameHangman => 'Ahorcado';
  @override
  String get minigameSudoku => 'Sudoku';
  @override
  String get minigamePuzzle => 'Rompecabezas';
  @override
  String get minigameTicTacToe => 'Tres en Raya';
  @override
  String get hangmanWin => '¡Felicidades! Adivinaste: {word}';
  @override
  String get hangmanLose => '¡Perdiste! Era: {word}';
  @override
  String get minigamePong => 'Pong';
  @override
  String get minigameTapTheDot => 'Toca el Punto';
  @override
  String get minigameRhythmTap => 'Rhythm Tap';
}
