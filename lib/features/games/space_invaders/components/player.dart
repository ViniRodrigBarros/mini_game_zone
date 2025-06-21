import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_zone/features/games/space_invaders/space_invaders_view_model.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceInvadersGame> {
  Player() : super(size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Criar sprite baseado em ícone
    final paint = Paint()..color = Colors.blue;
    final rect = size.toRect();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Desenhar um triângulo para representar a nave do jogador
    final path = Path();
    path.moveTo(rect.center.dx, rect.top);
    path.lineTo(rect.bottomLeft.dx, rect.bottom);
    path.lineTo(rect.bottomRight.dx, rect.bottom);
    path.close();

    canvas.drawPath(path, paint);
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    sprite = Sprite(image);

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 60);
    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
    position.x = position.x.clamp(width / 2, gameRef.size.x - width / 2);
  }
}
