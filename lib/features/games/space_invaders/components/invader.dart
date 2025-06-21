import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Invader extends SpriteComponent with CollisionCallbacks {
  Invader({required super.position})
    : super(size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Criar sprite baseado em ícone
    final paint = Paint()..color = Colors.red;
    final rect = size.toRect();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Desenhar um alienígena simples (retângulo com antenas)
    canvas.drawRect(rect, paint);

    // Antenas
    final antennaPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(rect.left + 8, rect.top - 4), 3, antennaPaint);
    canvas.drawCircle(Offset(rect.right - 8, rect.top - 4), 3, antennaPaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    sprite = Sprite(image);
    add(RectangleHitbox());
  }
}
