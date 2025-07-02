import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_zone/features/games/space_invaders/space_invaders_view_model.dart';
import 'invader.dart';
import 'player.dart';

class Bullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceInvadersGame> {
  final Vector2 velocity;
  final bool isPlayer;

  Bullet({
    required super.position,
    required this.velocity,
    required this.isPlayer,
  }) : super(size: Vector2(4, 12), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final color = isPlayer ? Colors.cyan : Colors.red;
    add(RectangleHitbox(collisionType: CollisionType.active));
    // Placeholder sprite
    final paint = Paint()..color = color;
    final rect = size.toRect();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    sprite = Sprite(image);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    if (position.y < 0 || position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (isPlayer && other is Invader) {
      removeFromParent();
      other.removeFromParent();
      gameRef.increaseScore();
    } else if (!isPlayer && other is Player) {
      removeFromParent();
      gameRef.playerDied();
    }
  }
}
