import 'package:flutter/material.dart';
import './maze_runner_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';

class MazeRunnerView extends StatefulWidget {
  const MazeRunnerView({super.key});
  static const route = '/MazeRunner/';

  @override
  State<MazeRunnerView> createState() => _MazeRunnerViewState();
}

class _MazeRunnerViewState extends State<MazeRunnerView> {
  late MazeRunnerViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = MazeRunnerViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
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
        title: Text(I18n.strings.minigameMazeRunner),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return Column(
              children: [
                // Header com informações do jogo
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard('Level', '${viewModel.level}', highlight),
                      _buildInfoCard('Score', '${viewModel.score}', primary),
                      _buildInfoCard(
                        'Items',
                        '${viewModel.collectedItems}/${viewModel.totalItems}',
                        Colors.orange,
                      ),
                    ],
                  ),
                ),

                // Área do labirinto
                Expanded(
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 400,
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
                        child: Stack(
                          children: [
                            // Labirinto
                            _buildMaze(),

                            // Overlay de Game Over
                            if (viewModel.isGameOver)
                              Positioned.fill(
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
                                          'Game Over!',
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Score: ${viewModel.score}',
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            textStyle: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: viewModel.restartGame,
                                          icon: const Icon(Icons.refresh),
                                          label: Text(I18n.strings.tttRestart),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Overlay de Vitória
                            if (viewModel.isWin)
                              Positioned.fill(
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
                                          'Level Complete!',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Score: ${viewModel.score}',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Items: ${viewModel.collectedItems}/${viewModel.totalItems}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: viewModel.nextLevel,
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                              ),
                                              label: const Text('Next Level'),
                                            ),
                                            const SizedBox(width: 16),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: highlight,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: viewModel.restartGame,
                                              icon: const Icon(Icons.refresh),
                                              label: Text(
                                                I18n.strings.tttRestart,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            // Overlay de início
                            if (!viewModel.isPlaying &&
                                !viewModel.isGameOver &&
                                !viewModel.isWin)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.explore,
                                          size: 64,
                                          color: highlight,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          I18n.strings.minigameMazeRunner,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: highlight,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Encontre a saída e colete os itens!',
                                          style: const TextStyle(
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            textStyle: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: viewModel.startGame,
                                          icon: const Icon(Icons.play_arrow),
                                          label: const Text('Iniciar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Controles
                if (viewModel.isPlaying)
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Controles direcionais
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDirectionButton(
                              Icons.keyboard_arrow_up,
                              MazeDirection.up,
                              Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDirectionButton(
                              Icons.keyboard_arrow_left,
                              MazeDirection.left,
                              Colors.blue,
                            ),
                            const SizedBox(width: 24),
                            _buildDirectionButton(
                              Icons.keyboard_arrow_down,
                              MazeDirection.down,
                              Colors.blue,
                            ),
                            const SizedBox(width: 24),
                            _buildDirectionButton(
                              Icons.keyboard_arrow_right,
                              MazeDirection.right,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  Widget _buildMaze() {
    if (viewModel.maze.isEmpty) return const SizedBox();

    final cellSize = 400.0 / viewModel.mazeHeight;

    return CustomPaint(
      size: const Size(400, 400),
      painter: MazePainter(
        maze: viewModel.maze,
        playerX: viewModel.playerX,
        playerY: viewModel.playerY,
        exitX: viewModel.exitX,
        exitY: viewModel.exitY,
        items: viewModel.items,
        cellSize: cellSize,
      ),
    );
  }

  Widget _buildDirectionButton(
    IconData icon,
    MazeDirection direction,
    Color color,
  ) {
    return GestureDetector(
      onTapDown: (_) => viewModel.movePlayer(direction),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 40),
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  final List<List<MazeCell>> maze;
  final int playerX;
  final int playerY;
  final int exitX;
  final int exitY;
  final List<MazeItem> items;
  final double cellSize;

  MazePainter({
    required this.maze,
    required this.playerX,
    required this.playerY,
    required this.exitX,
    required this.exitY,
    required this.items,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar paredes
    final wallPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    for (int y = 0; y < maze.length; y++) {
      for (int x = 0; x < maze[y].length; x++) {
        if (maze[y][x].isWall) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            wallPaint,
          );
        }
      }
    }

    // Desenhar saída
    final exitPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(exitX * cellSize, exitY * cellSize, cellSize, cellSize),
      exitPaint,
    );

    // Desenhar itens
    for (MazeItem item in items) {
      final itemPaint = Paint()
        ..color = item.type == ItemType.gem ? Colors.purple : Colors.yellow
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          item.x * cellSize + cellSize / 2,
          item.y * cellSize + cellSize / 2,
        ),
        cellSize / 4,
        itemPaint,
      );
    }

    // Desenhar jogador
    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(
        playerX * cellSize + cellSize / 2,
        playerY * cellSize + cellSize / 2,
      ),
      cellSize / 3,
      playerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
