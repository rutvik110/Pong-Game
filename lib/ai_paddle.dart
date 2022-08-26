import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pong/balls.dart';

class AiPaddle extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  late final RectangleHitbox paddleHitBox;
  late final RectangleComponent paddle;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad
    final worldRect = gameRef.size.toRect();

    final size = Vector2(10, 100);
    position = Vector2(worldRect.width * 0.1, 500);
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
    // update the aipaddle position with respect to balls positions

    final ball = gameRef.children.singleWhere((child) => child is Ball) as Ball;
    final paddleRect = paddle.toAbsoluteRect();
    final ballPositionWrtPaddleHeight = ball.y + (paddleRect.height);
    final isOutOfBounds = ballPositionWrtPaddleHeight > gameRef.size.y ||
        ball.y - (paddleRect.width / 2) < 0;

    if (!isOutOfBounds) {
      if (ball.y > position.y + (paddleRect.width / 2)) {
        position.y += (300 * dt);
      }

      if (ball.y < position.y + (paddleRect.width / 2)) {
        position.y -= (300 * dt);
      }
    }

    // position.y = (ball.y - paddleRect.top - paddleRect.height / 2) * 0.8;

    // position.y += 5 * (ball.y.sign.isNegative ? -1 : 1);
  }
}
