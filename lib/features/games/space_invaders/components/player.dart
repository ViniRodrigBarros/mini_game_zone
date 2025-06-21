import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:mini_game_zone/features/games/space_invaders/space_invaders_view_model.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceInvadersGame> {
  Player() : super(size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png'); // Placeholder
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 60);
    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);
    position.x = position.x.clamp(width / 2, gameRef.size.x - width / 2);
  }
}
