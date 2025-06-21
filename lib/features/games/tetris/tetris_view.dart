import 'package:flutter/material.dart';
import 'dart:math';
import './tetris_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'tetris.dart';

class TetrisView extends State<Tetris> {
  late final TetrisViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TetrisViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Tetris'),
        centerTitle: true,
        backgroundColor: primary,
        actions: [
          if (_viewModel.isPlaying && !_viewModel.isGameOver)
            IconButton(
              icon: Icon(_viewModel.isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _viewModel.pauseGame,
              tooltip: _viewModel.isPaused ? 'Continuar' : 'Pausar',
            ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return Column(
              children: [
                // Informações do jogo
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard('Score', '${_viewModel.score}', highlight),
                      _buildInfoCard('Level', '${_viewModel.level}', primary),
                      _buildInfoCard(
                        'Lines',
                        '${_viewModel.linesCleared}',
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                // Área principal do jogo
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 250, // Reduced from 300
                      child: _buildGameboard(context, primary, highlight),
                    ),
                  ),
                ),

                // Painel inferior
                _buildBottomPanel(context, primary, highlight),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameboard(BuildContext context, Color primary, Color highlight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: TetrisViewModel.cols / TetrisViewModel.rows,
          child: Stack(
            children: [
              // Grid do tabuleiro
              _buildBoard(),

              // Peça atual
              _buildCurrentPiece(),

              // Game Over
              if (_viewModel.isGameOver) _buildGameOverOverlay(highlight),

              // Overlay de início
              if (!_viewModel.isPlaying && !_viewModel.isGameOver)
                _buildStartOverlay(highlight),

              // Overlay de pausa
              if (_viewModel.isPaused) _buildPausedOverlay(highlight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(
    BuildContext context,
    Color primary,
    Color highlight,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Controles
          if (_viewModel.isPlaying && !_viewModel.isPaused)
            Row(
              children: [
                _buildControlButton(
                  icon: Icons.arrow_left,
                  onPressed: () => _viewModel.movePiece(Direction.left),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    _buildControlButton(
                      icon: Icons.rotate_right,
                      onPressed: _viewModel.rotatePiece,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    _buildControlButton(
                      icon: Icons.arrow_downward,
                      onPressed: () => _viewModel.movePiece(Direction.down),
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                _buildControlButton(
                  icon: Icons.arrow_right,
                  onPressed: () => _viewModel.movePiece(Direction.right),
                  color: Colors.blue,
                ),
              ],
            ),

          // Preview da próxima peça
          Column(
            children: [
              Text(
                'Próxima',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildNextPiecePreview(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(Color highlight) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: highlight,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Score: ${_viewModel.score}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _viewModel.restartGame,
                icon: const Icon(Icons.refresh),
                label: Text(I18n.strings.tttRestart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartOverlay(Color highlight) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.extension, size: 64, color: highlight),
              const SizedBox(height: 16),
              const Text(
                'Tetris',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38BDF8),
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Organize as peças!\nComplete linhas para pontuar.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _viewModel.startGame,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPausedOverlay(Color highlight) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pause, size: 64, color: highlight),
              const SizedBox(height: 16),
              Text(
                'Jogo Pausado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: highlight,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Toque para continuar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / TetrisViewModel.cols;
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: TetrisBoardPainter(
            board: _viewModel.board,
            cellSize: cellSize,
          ),
        );
      },
    );
  }

  Widget _buildCurrentPiece() {
    if (!_viewModel.isPlaying || _viewModel.isGameOver || _viewModel.isPaused) {
      return const SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = constraints.maxWidth / TetrisViewModel.cols;
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: TetrisPiecePainter(
            piece: _viewModel.currentPiece,
            x: _viewModel.currentX,
            y: _viewModel.currentY,
            color: TetrisViewModel.pieceColors[_viewModel.currentPieceType]!,
            cellSize: cellSize,
          ),
        );
      },
    );
  }

  Widget _buildNextPiecePreview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: TetrisPiecePainter(
            piece: _viewModel.nextPiece,
            x: 0,
            y: 0,
            color: TetrisViewModel.pieceColors[_viewModel.nextPieceType]!,
            cellSize: constraints.maxWidth / 4, // Center the 4x4 grid
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        elevation: 4,
        shadowColor: color.withValues(alpha: 0.2),
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 24),
    );
  }
}

class TetrisBoardPainter extends CustomPainter {
  final List<List<int>> board;
  final double cellSize;

  TetrisBoardPainter({required this.board, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar células do tabuleiro
    for (int y = 0; y < TetrisViewModel.rows; y++) {
      for (int x = 0; x < TetrisViewModel.cols; x++) {
        final cellValue = board[y][x];
        if (cellValue != 0) {
          final paint = Paint()
            ..color = Color(cellValue)
            ..style = PaintingStyle.fill;

          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            paint,
          );

          // Borda da célula
          final borderPaint = Paint()
            ..color = Colors.black.withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;

          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            borderPaint,
          );
        }
      }
    }

    // Grid
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int x = 0; x <= TetrisViewModel.cols; x++) {
      canvas.drawLine(
        Offset(x * cellSize, 0),
        Offset(x * cellSize, size.height),
        gridPaint,
      );
    }

    for (int y = 0; y <= TetrisViewModel.rows; y++) {
      canvas.drawLine(
        Offset(0, y * cellSize),
        Offset(size.width, y * cellSize),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TetrisPiecePainter extends CustomPainter {
  final List<Point<int>> piece;
  final int x;
  final int y;
  final Color color;
  final double cellSize;

  TetrisPiecePainter({
    required this.piece,
    required this.x,
    required this.y,
    required this.color,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final point in piece) {
      final rect = Rect.fromLTWH(
        (x + point.x) * cellSize,
        (y + point.y) * cellSize,
        cellSize,
        cellSize,
      );

      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
