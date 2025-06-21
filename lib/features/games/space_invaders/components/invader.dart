import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Invader extends SpriteComponent with CollisionCallbacks {
  Invader({required super.position})
    : super(size: Vector2(32, 32), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('invader.png'); // Placeholder
    add(RectangleHitbox());
  }
}
