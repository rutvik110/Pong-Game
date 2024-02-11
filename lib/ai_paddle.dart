import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pong/ball.dart';

class AIPaddle extends RectangleComponent with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  late final RectangleHitbox paddleHitBox;

  @override
  Future<void> onLoad() async {
    final worldRect = gameRef.size.toRect();

    size = Vector2(10, 100);
    position.x = worldRect.width * 0.1;
    position.y = worldRect.height / 2 - size.y / 2;
    paint = Paint()..color = Colors.red;
    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddleHitBox,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    final ball = gameRef.children.singleWhere((child) => child is Ball) as Ball;
    final ballPositionWrtPaddleHeight = ball.y + (size.y);
    final isOutOfBounds = ballPositionWrtPaddleHeight > gameRef.size.y || ball.y < 0;

    if (!isOutOfBounds) {
      if (ball.y > position.y) {
        // Ball is above paddle. Move down.
        position.y += (400 * dt);
      }

      if (ball.y < position.y) {
        // Ball is below paddle. Move up.
        position.y -= (400 * dt);
      }
    }
  }
}
