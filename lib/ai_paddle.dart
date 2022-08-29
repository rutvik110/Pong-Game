import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pong/ball.dart';

class AiPaddle extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  late final RectangleHitbox paddleHitBox;
  late final RectangleComponent paddle;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad

    final paddleSize = Vector2(10, 100);
    position.x = size.x * 0.1;
    position.y = size.y / 2 - paddleSize.y / 2;
    paddle = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.red,
    );
    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddle,
      paddleHitBox,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    final ball = gameRef.children.singleWhere((child) => child is Ball) as Ball;
    final paddleRect = paddle.toAbsoluteRect();
    final ballPositionWrtPaddleHeight = ball.y + (paddleRect.height);
    final isOutOfBounds =
        ballPositionWrtPaddleHeight > gameRef.size.y || ball.y < 0;

    if (!isOutOfBounds) {
      if (ball.y > position.y) {
        position.y += (400 * dt);
      }

      if (ball.y < position.y) {
        position.y -= (400 * dt);
      }
    }
  }
}
