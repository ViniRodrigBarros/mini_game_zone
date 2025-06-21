import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_zone/core/app_constants.dart';
import 'package:mini_game_zone/core/i18n/i18n.dart';
import './space_invaders_view_model.dart';
import 'components/components.dart';

class SpaceInvadersView extends SpaceInvadersViewModel {
  @override
  Widget build(BuildContext context) {
    final primary = AppConstants.primaryColor;
    final highlight = const Color(0xFF38BDF8);
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Space Invaders'),
        centerTitle: true,
        backgroundColor: primary,
      ),
      body: Column(
        children: [
          // Placar e Vidasf
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard('Score', '$score', highlight),
                _buildInfoCard('Lives', '❤️' * lives, Colors.red),
              ],
            ),
          ),
          // Área do Jogo
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GameWidget(game: game),
            ),
          ),
          // Controles
          if (!isGameOver) _buildControls(),
          if (isGameOver) _buildGameOverControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.arrow_left,
            onPressed: () => game.children
                .whereType<Player>()
                .firstOrNull
                ?.move(Vector2(-10, 0)),
          ),
          _buildControlButton(
            icon: Icons.rocket_launch,
            onPressed: () => game.firePlayerBullet(),
            color: Colors.red,
          ),
          _buildControlButton(
            icon: Icons.arrow_right,
            onPressed: () => game.children
                .whereType<Player>()
                .firstOrNull
                ?.move(Vector2(10, 0)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF38BDF8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        onPressed: resetGame,
        icon: const Icon(Icons.refresh),
        label: Text(I18n.strings.tttRestart),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: color ?? AppConstants.primaryColor,
      ),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
