import 'package:flutter/material.dart';
import './rhythm_tap_view_model.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import 'dart:async';

class RhythmTapView extends StatefulWidget {
  const RhythmTapView({super.key});

  @override
  State<RhythmTapView> createState() => _RhythmTapViewState();
}

class _RhythmTapViewState extends State<RhythmTapView> {
  late RhythmTapViewModel viewModel;
  Timer? animationTimer;

  @override
  void initState() {
    super.initState();
    viewModel = RhythmTapViewModel();

    // Timer para animação das notas
    animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (viewModel.isPlaying) {
        viewModel.updateNotes();
      }
    });
  }

  @override
  void dispose() {
    animationTimer?.cancel();
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
        title: Text(I18n.strings.minigameRhythmTap),
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
                      _buildInfoCard('Score', '${viewModel.score}', highlight),
                      _buildInfoCard('Combo', '${viewModel.combo}', primary),
                      _buildInfoCard(
                        'Level',
                        '${viewModel.level}',
                        Colors.orange,
                      ),
                      _buildInfoCard(
                        'Time',
                        '${viewModel.maxGameTime - viewModel.gameTime}s',
                        Colors.red,
                      ),
                    ],
                  ),
                ),

                // Área do jogo
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTapDown: (details) {
                        if (viewModel.isPlaying) {
                          viewModel.tapNote(
                            details.localPosition.dx,
                            details.localPosition.dy,
                          );
                        }
                      },
                      child: Container(
                        width: 360,
                        height: 600,
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
                        child: Stack(
                          children: [
                            // Linha alvo
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 550,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: highlight.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Notas
                            ...viewModel.activeNotes.map(
                              (note) => _buildNote(note),
                            ),

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
                                            color: highlight,
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
                                          'Max Combo: ${viewModel.maxCombo}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white70,
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

                            // Overlay de início
                            if (!viewModel.isPlaying && !viewModel.isGameOver)
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
                                          Icons.music_note,
                                          size: 64,
                                          color: highlight,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          I18n.strings.minigameRhythmTap,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: highlight,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Toque nas notas no momento certo!',
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(RhythmNote note) {
    final color = note.type == NoteType.bonus
        ? Colors.orange
        : AppConstants.primaryColor;

    return Positioned(
      left: note.x - 15,
      top: note.y - 15,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: note.type == NoteType.bonus
            ? const Icon(Icons.star, color: Colors.white, size: 16)
            : const Icon(Icons.music_note, color: Colors.white, size: 16),
      ),
    );
  }
}
