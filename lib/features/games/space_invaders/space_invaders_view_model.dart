import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_zone/features/games/space_invaders/space_invaders.dart';
import 'package:mini_game_zone/features/games/space_invaders/components/components.dart';

abstract class SpaceInvadersViewModel extends State<SpaceInvaders> {
  late final SpaceInvadersGame game;

  int score = 0;
  int lives = 3;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    game = SpaceInvadersGame(
      onScoreUpdate: (newScore) {
        setState(() {
          score = newScore;
        });
      },
      onLivesUpdate: (newLives) {
        setState(() {
          lives = newLives;
        });
      },
      onGameOver: () {
        setState(() {
          isGameOver = true;
        });
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      lives = 3;
      isGameOver = false;
      game.reset();
    });
  }
}

class SpaceInvadersGame extends FlameGame with HasCollisionDetection {
  final Function(int) onScoreUpdate;
  final Function(int) onLivesUpdate;
  final VoidCallback onGameOver;

  int _score = 0;
  int _lives = 3;
  double _timeSinceLastShot = 0.0;
  double _invaderMoveTime = 0.0;
  bool _invadersMoveRight = true;

  SpaceInvadersGame({
    required this.onScoreUpdate,
    required this.onLivesUpdate,
    required this.onGameOver,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(Player());
    spawnInvaders();
  }

  void spawnInvaders() {
    const rows = 4;
    const cols = 8;
    const invaderWidth = 32.0;
    const invaderHeight = 32.0;
    const spacing = 16.0;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final x = (j * (invaderWidth + spacing)) + 50;
        final y = (i * (invaderHeight + spacing)) + 50;
        add(Invader(position: Vector2(x, y)));
      }
    }
  }

  void firePlayerBullet() {
    final player = children.whereType<Player>().firstOrNull;
    if (player != null) {
      add(
        Bullet(
          position: player.position + Vector2(player.width / 2, 0),
          velocity: Vector2(0, -300),
          isPlayer: true,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastShot += dt;
    _invaderMoveTime += dt;

    if (_invaderMoveTime > 1.0) {
      _invaderMoveTime = 0;
      bool edgeReached = false;
      for (final invader in children.whereType<Invader>()) {
        invader.position.x += _invadersMoveRight ? 10 : -10;
        if ((_invadersMoveRight &&
                invader.position.x > size.x - invader.width) ||
            (!_invadersMoveRight && invader.position.x < 0)) {
          edgeReached = true;
        }
      }

      if (edgeReached) {
        _invadersMoveRight = !_invadersMoveRight;
        for (final invader in children.whereType<Invader>()) {
          invader.position.y += 20;
        }
      }
    }

    if (_timeSinceLastShot > 1.5) {
      _timeSinceLastShot = 0.0;
      final invaders = children.whereType<Invader>().toList();
      if (invaders.isNotEmpty) {
        final randomInvader = invaders[Random().nextInt(invaders.length)];
        add(
          Bullet(
            position: randomInvader.position.clone(),
            velocity: Vector2(0, 150),
            isPlayer: false,
          ),
        );
      }
    }
  }

  void playerDied() {
    _lives--;
    onLivesUpdate(_lives);
    if (_lives <= 0) {
      onGameOver();
      pauseEngine();
    }
  }

  void increaseScore() {
    _score += 100;
    onScoreUpdate(_score);
  }

  void reset() {
    children.whereType<Invader>().forEach(
      (invader) => invader.removeFromParent(),
    );
    children.whereType<Bullet>().forEach((bullet) => bullet.removeFromParent());
    children.whereType<Player>().forEach((player) => player.removeFromParent());
    add(Player());
    spawnInvaders();
    _score = 0;
    _lives = 3;
    onScoreUpdate(_score);
    onLivesUpdate(_lives);
    resumeEngine();
  }
}
