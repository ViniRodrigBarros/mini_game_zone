import 'translation.dart';

class PtBr implements Translation {
  @override
  String get test => 'teste';
  @override
  String get settingsTitle => 'Configurações';
  @override
  String get languageLabel => 'Idioma';
  @override
  String get homeTitle => 'Mini Game Zone';
  @override
  String get splashLoading => 'Carregando...';
  @override
  String get tttTitle => 'Jogo da Velha';
  @override
  String get tttChooseMode => 'Escolha o modo de jogo:';
  @override
  String get ttt1Player => '1 Jogador';
  @override
  String get ttt2Players => '2 Jogadores';
  @override
  String get tttWinner => 'Vencedor';
  @override
  String get tttDraw => 'Empate!';
  @override
  String get tttTurn => 'Vez de';
  @override
  String get tttRestart => 'Reiniciar';
  @override
  String get minigameMemory => 'Jogo da Memória';
  @override
  String get minigameSnakeGame => 'Snake Game';
  @override
  String get minigameHangman => 'Forca';
  @override
  String get minigameSudoku => 'Sudoku';
  @override
  String get minigamePuzzle => 'Quebra-cabeça';
  @override
  String get minigameTicTacToe => 'Jogo da Velha';
  @override
  String get hangmanWin => 'Parabéns! Você acertou: {word}';
  @override
  String get hangmanLose => 'Você perdeu! Era: {word}';
  @override
  String get minigamePong => 'Pong';
  @override
  String get minigameTapTheDot => 'Toque no Ponto';
  @override
  String get minigameRhythmTap => 'Rhythm Tap';
  @override
  String get minigameMazeRunner => 'Labirinto';
}
